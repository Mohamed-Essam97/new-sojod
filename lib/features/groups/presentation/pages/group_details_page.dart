import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/group_cubit.dart';
import '../cubit/group_state.dart';
import '../widgets/member_card.dart';

class GroupDetailsPage extends StatelessWidget {
  const GroupDetailsPage({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GroupCubit>()..loadGroupDetails(groupId),
      child: _GroupDetailsView(groupId: groupId),
    );
  }
}

class _GroupDetailsView extends StatelessWidget {
  const _GroupDetailsView({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = l10n.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: BlocConsumer<GroupCubit, GroupState>(
        listenWhen: (prev, curr) => curr is GroupError,
        listener: (context, state) {
          if (state is GroupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        buildWhen: (prev, curr) =>
            curr is GroupLoading || curr is GroupDetailsLoaded,
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.violet),
            );
          }

          if (state is GroupDetailsLoaded) {
            final group = state.group;
            final members = state.members;
            final authState = context.read<AuthCubit>().state;
            final currentUserId =
                authState is AuthAuthenticated ? authState.user.uid : null;
            final isOwner = currentUserId == group.ownerId;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: AppColors.violet,
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      group.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.violet,
                            AppColors.violet.withValues(alpha: 0.75),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: group.photoUrl != null &&
                              group.photoUrl!.isNotEmpty
                          ? Image.network(
                              group.photoUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) =>
                                  progress == null
                                      ? child
                                      : const _DefaultGroupImage(),
                              errorBuilder: (_, __, ___) =>
                                  const _DefaultGroupImage(),
                            )
                          : const _DefaultGroupImage(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (group.description != null &&
                            group.description!.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card(context),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isDark
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.06),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.violet,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    group.description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: AppColors.onSurfaceMutedColor(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (isOwner) ...[
                          _InviteCard(
                            isAr: isAr,
                            onGenerateInvite: () async {
                              final authState =
                                  context.read<AuthCubit>().state;
                              if (authState is AuthAuthenticated) {
                                final code = await context
                                    .read<GroupCubit>()
                                    .generateInviteCode(
                                        groupId, authState.user.uid);
                                if (code != null && context.mounted) {
                                  _showInviteCodeDialog(context, code, isAr);
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          isAr
                              ? 'الأعضاء (${members.length})'
                              : 'Members (${members.length})',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurfaceColor(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final member = members[index];
                        return MemberCard(
                          key: ValueKey(member.uid),
                          member: member,
                          isOwner: member.uid == group.ownerId,
                          isDark: isDark,
                        );
                      },
                      childCount: members.length,
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: AppColors.violet),
          );
        },
      ),
    );
  }

  static void _showInviteCodeDialog(
      BuildContext context, String code, bool isAr) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.violet.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_rounded,
                color: AppColors.violet,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(isAr ? 'كود الدعوة' : 'Invite Code'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.violet.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SelectableText(
                code,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: AppColors.violet,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isAr
                  ? 'شارك هذا الكود مع أصدقائك للانضمام للمجموعة'
                  : 'Share this code with friends to join the group',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceMutedColor(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(isAr ? 'إغلاق' : 'Close'),
          ),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isAr ? 'تم النسخ' : 'Copied'),
                  backgroundColor: AppColors.teal,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: Text(isAr ? 'نسخ' : 'Copy'),
          ),
          FilledButton.icon(
            onPressed: () {
              Share.share(
                isAr
                    ? 'انضم لمجموعتي على Wird! استخدم الكود: $code'
                    : 'Join my Wird group! Use code: $code',
              );
            },
            icon: const Icon(Icons.share_rounded, size: 18),
            label: Text(isAr ? 'مشاركة' : 'Share'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.violet,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultGroupImage extends StatelessWidget {
  const _DefaultGroupImage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.groups_rounded,
        size: 80,
        color: Colors.white.withValues(alpha: 0.35),
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard({
    required this.isAr,
    required this.onGenerateInvite,
  });

  final bool isAr;
  final VoidCallback onGenerateInvite;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.emerald,
            AppColors.emerald.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onGenerateInvite,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'دعوة أعضاء جدد' : 'Invite Members',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAr ? 'إنشاء كود دعوة للمجموعة' : 'Generate invite code',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
