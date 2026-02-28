# Wird App - Deployment Guide

## 📋 Prerequisites

Before deploying, ensure you have:

1. **Firebase CLI installed**
   ```bash
   npm install -g firebase-tools
   ```

2. **Firebase project created**
   - Project ID: `wird-islamic-app`
   - Already configured in `firebase_options.dart`

3. **Authentication providers enabled in Firebase Console**
   - Google Sign-In
   - Facebook Sign-In

## 🔐 Step 1: Deploy Firestore Security Rules

### 1.1 Login to Firebase
```bash
firebase login
```

### 1.2 Initialize Firebase (if not already done)
```bash
firebase init firestore
```

Select your project: `wird-islamic-app`

### 1.3 Deploy Security Rules
```bash
firebase deploy --only firestore:rules
```

### 1.4 Verify Deployment
Go to Firebase Console → Firestore Database → Rules
You should see the rules from `firestore.rules` file.

---

## 🔑 Step 2: Configure Authentication

### 2.1 Enable Google Sign-In
1. Go to Firebase Console → Authentication → Sign-in method
2. Enable Google provider
3. Add your support email

### 2.2 Enable Facebook Sign-In
1. Create Facebook App at https://developers.facebook.com
2. Get App ID and App Secret
3. In Firebase Console → Authentication → Sign-in method
4. Enable Facebook provider
5. Enter Facebook App ID and App Secret
6. Copy OAuth redirect URI and add to Facebook App settings

### 2.3 Android Configuration

**Add SHA-1 & SHA-256 fingerprints:**

```bash
# Debug keystore
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore

# Release keystore (when ready)
keytool -list -v -alias <your-alias> -keystore <path-to-keystore>
```

Add fingerprints to Firebase Console → Project Settings → Android app

**Update `AndroidManifest.xml`** (already done):
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 2.4 iOS Configuration

**Add URL schemes** (already done in `Info.plist`):
- Google Sign-In: `com.googleusercontent.apps.{REVERSED_CLIENT_ID}`
- Facebook: `fb{FACEBOOK_APP_ID}`

**Update `Info.plist`** with Facebook App ID (if not done):
```xml
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookDisplayName</key>
<string>Wird</string>
```

---

## 📱 Step 3: Test the App

### 3.1 Install Dependencies
```bash
flutter pub get
```

### 3.2 Run on Device/Emulator
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

### 3.3 Test Features

**Authentication:**
- ✅ Sign in with Google
- ✅ Sign in with Facebook
- ✅ Profile update
- ✅ Sign out

**Wird:**
- ✅ Create daily wird
- ✅ Update Quran progress
- ✅ Toggle Adhkar completion
- ✅ Update Tasbeeh count
- ✅ Data persists in Firestore

**Groups:**
- ✅ Create group
- ✅ Generate invite code
- ✅ Join group with code
- ✅ View members
- ✅ Share invite

---

## 🚀 Step 4: Production Build

### 4.1 Android Release

**1. Create keystore:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**2. Configure `android/key.properties`:**
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

**3. Build APK/AAB:**
```bash
# APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### 4.2 iOS Release

**1. Configure signing in Xcode:**
- Open `ios/Runner.xcworkspace`
- Select Runner → Signing & Capabilities
- Configure Team and Bundle Identifier

**2. Build:**
```bash
flutter build ios --release
```

**3. Archive in Xcode:**
- Product → Archive
- Upload to App Store Connect

---

## 🔒 Security Checklist

- [ ] Firestore rules deployed
- [ ] Authentication providers configured
- [ ] API keys restricted in Google Cloud Console
- [ ] Facebook App reviewed and published
- [ ] SSL pinning enabled (optional, advanced)
- [ ] ProGuard rules configured for Android (optional)

---

## 📊 Monitoring & Analytics

### Enable Firebase Analytics
```bash
firebase deploy --only analytics
```

### Key Metrics to Track
- Daily Active Users (DAU)
- Wird completion rate
- Group creation rate
- User retention
- Authentication success/failure

---

## 🐛 Troubleshooting

### Issue: "Google Sign-In failed"
**Solution:** Ensure SHA-1 fingerprint is added to Firebase Console

### Issue: "Facebook Sign-In failed"
**Solution:** 
- Check Facebook App ID in Firebase
- Verify OAuth redirect URI in Facebook App settings

### Issue: "Permission denied" in Firestore
**Solution:** 
- Redeploy security rules
- Check user is authenticated
- Verify group membership

### Issue: "Invite code not working"
**Solution:**
- Check invite hasn't expired
- Verify maxUses not reached
- Ensure code is uppercase

---

## 📞 Support

For issues or questions:
- GitHub Issues: [your-repo-url]
- Email: [your-email]
- Documentation: This file

---

## 🎉 Launch Checklist

- [ ] All features tested
- [ ] Firestore rules deployed
- [ ] Authentication working
- [ ] Production builds created
- [ ] App store listings prepared
- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] Support channels ready

---

*Last Updated: 2026-02-28*
