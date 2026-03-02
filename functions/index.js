import { initializeApp } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { onCall, HttpsError } from 'firebase-functions/v2/https';

initializeApp();
const db = getFirestore();

/**
 * Join a group using an invite code. Runs with Admin SDK so it is not blocked
 * by client Firestore rules (e.g. when collectionGroup('invites') read is denied).
 * Validates: invite exists, not expired, not over maxUses; then creates member +
 * membership and increments invite uses in a transaction.
 * Throws HttpsError with code: not-found (invalid code), failed-precondition
 * (expired/maxed), already-exists (already member).
 */
export const joinGroupWithCode = onCall(
  { enforceAppCheck: false },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'You must be signed in to join a group.');
    }

    const { code: rawCode, displayName, photoUrl } = request.data || {};
    const code = typeof rawCode === 'string' ? rawCode.trim().toUpperCase() : '';
    if (!code || code.length < 6) {
      throw new HttpsError('invalid-argument', 'Invalid invite code.');
    }

    const uid = request.auth.uid;
    const name = typeof displayName === 'string' ? displayName : (request.auth.token.name || '');
    const photo = typeof photoUrl === 'string' ? photoUrl : null;

    const invitesSnap = await db.collectionGroup('invites')
      .where('code', '==', code)
      .limit(1)
      .get();

    if (invitesSnap.empty) {
      throw new HttpsError('not-found', 'Invalid invite code.');
    }

    const inviteDoc = invitesSnap.docs[0];
    const inviteRef = inviteDoc.ref;
    const groupId = inviteRef.parent.parent.id;
    const inviteData = inviteDoc.data();
    const maxUses = inviteData.maxUses ?? 20;
    const uses = inviteData.uses ?? 0;
    const expiresAt = inviteData.expiresAt?.toDate?.() ?? null;
    const now = new Date();

    if (expiresAt && now > expiresAt) {
      throw new HttpsError('failed-precondition', 'Invite has expired.');
    }
    if (uses >= maxUses) {
      throw new HttpsError('failed-precondition', 'This invite code has reached its usage limit.');
    }

    const groupRef = db.collection('groups').doc(groupId);
    const memberRef = groupRef.collection('members').doc(uid);
    const membershipRef = db.collection('users').doc(uid).collection('memberships').doc(groupId);

    const groupSnap = await groupRef.get();
    if (!groupSnap.exists) {
      throw new HttpsError('not-found', 'Group not found.');
    }

    const memberSnap = await memberRef.get();
    if (memberSnap.exists) {
      await membershipRef.set(
        { groupId, joinedAt: FieldValue.serverTimestamp() },
        { merge: true }
      );
      return { success: true, alreadyMember: true };
    }

    await db.runTransaction(async (tx) => {
      const memberAgain = await tx.get(memberRef);
      if (memberAgain.exists) {
        return;
      }
      tx.set(memberRef, {
        uid,
        displayName: name,
        role: 'member',
        photoUrl: photo || null,
        joinedAt: FieldValue.serverTimestamp(),
      });
      tx.set(membershipRef, {
        groupId,
        joinedAt: FieldValue.serverTimestamp(),
      });
      tx.update(inviteRef, { uses: FieldValue.increment(1) });
    });

    return { success: true, alreadyMember: false };
  }
);
