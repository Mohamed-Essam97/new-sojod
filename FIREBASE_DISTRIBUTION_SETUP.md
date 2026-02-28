# Firebase App Distribution Setup Guide

دليل إعداد ونشر التطبيق على Firebase App Distribution

---

## 📋 المتطلبات الأساسية

### 1. تثبيت Firebase CLI

```bash
# باستخدام npm
npm install -g firebase-tools

# أو باستخدام Homebrew (macOS)
brew install firebase-cli

# تسجيل الدخول
firebase login
```

### 2. تثبيت أدوات Flutter

```bash
# تأكد من تثبيت Flutter
flutter doctor

# تأكد من تثبيت Xcode (لـ iOS)
xcode-select --install
```

---

## 🔧 إعداد المشروع

### خطوة 1: تهيئة Firebase في المشروع

```bash
cd /Users/amjaad/Developement/noor
firebase init
```

اختر:
- ✅ App Distribution
- ✅ المشروع: `wird-islamic-app`

### خطوة 2: إعداد iOS (اختياري)

افتح `ios/ExportOptions.plist` وعدّل:
```xml
<key>teamID</key>
<string>YOUR_TEAM_ID_HERE</string>
```

للحصول على Team ID:
1. افتح Xcode
2. اذهب إلى Runner → Signing & Capabilities
3. انسخ Team ID

### خطوة 3: إعداد مجموعات التوزيع

اذهب إلى Firebase Console:
```
https://console.firebase.google.com/project/wird-islamic-app/appdistribution
```

أنشئ مجموعة:
- الاسم: `testers`
- أضف emails المختبرين

---

## 🚀 استخدام السكريبت

### إعطاء صلاحيات التنفيذ

```bash
chmod +x deploy_firebase.sh
```

### تشغيل السكريبت

```bash
./deploy_firebase.sh
```

ستظهر لك خيارات:
```
1) Android only        - بناء ونشر APK فقط
2) iOS only           - بناء ونشر IPA فقط
3) Both               - بناء ونشر الاثنين
4) Clean and build    - تنظيف وبناء الاثنين
```

---

## 📱 بناء يدوي (بدون السكريبت)

### Android APK

```bash
# بناء
flutter build apk --release

# نشر
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app 1:405620285471:android:ab37420b030207df03b52a \
  --groups testers \
  --release-notes "Version 1.0.0"
```

### iOS IPA

```bash
# بناء
flutter build ios --release

# Archive
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  archive

# Export IPA
xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportPath build \
  -exportOptionsPlist ExportOptions.plist

cd ..

# نشر
firebase appdistribution:distribute \
  ios/build/Runner.ipa \
  --app 1:405620285471:ios:42a935e75e6b167003b52a \
  --groups testers \
  --release-notes "Version 1.0.0"
```

---

## 🎯 نشر سريع (Quick Deploy)

### Android فقط
```bash
./deploy_firebase.sh
# اختر: 1
```

### iOS فقط
```bash
./deploy_firebase.sh
# اختر: 2
```

### الاثنين
```bash
./deploy_firebase.sh
# اختر: 3
```

---

## 📊 مراقبة التوزيع

### عبر Firebase Console
```
https://console.firebase.google.com/project/wird-islamic-app/appdistribution
```

### عبر CLI
```bash
# عرض التوزيعات
firebase appdistribution:distributions:list --app APP_ID

# عرض تفاصيل توزيع معين
firebase appdistribution:distributions:get RELEASE_ID --app APP_ID
```

---

## 🔐 إعداد Android Signing (للإنتاج)

### 1. إنشاء Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. تكوين Gradle

أنشئ `android/key.properties`:
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=/Users/amjaad/upload-keystore.jks
```

### 3. تعديل `android/app/build.gradle`

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

---

## 🧪 اختبار التوزيع

### 1. المختبرون يستلمون Email
- رابط التحميل
- Release notes
- معلومات النسخة

### 2. تثبيت التطبيق
- Android: مباشرة من الرابط
- iOS: يحتاج UDID مسجل في Provisioning Profile

### 3. تقديم Feedback
- عبر Firebase Console
- أو داخل التطبيق (إذا أضفت SDK)

---

## 🔄 التحديثات التلقائية

### إضافة Firebase App Distribution SDK (اختياري)

**pubspec.yaml:**
```yaml
dependencies:
  firebase_app_distribution: ^0.2.0
```

**الكود:**
```dart
import 'package:firebase_app_distribution/firebase_app_distribution.dart';

// فحص التحديثات
FirebaseAppDistribution.instance.checkForUpdate().then((update) {
  if (update != null) {
    // عرض dialog للتحديث
  }
});
```

---

## 🐛 حل المشاكل

### المشكلة: Firebase CLI غير موجود
```bash
npm install -g firebase-tools
```

### المشكلة: Permission denied على السكريبت
```bash
chmod +x deploy_firebase.sh
```

### المشكلة: iOS build فشل
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### المشكلة: Android signing فشل
- تأكد من `key.properties` موجود
- تأكد من صحة الـpasswords
- تأكد من مسار الـkeystore

### المشكلة: Firebase authentication فشل
```bash
firebase logout
firebase login
```

---

## 📈 أفضل الممارسات

### 1. إدارة النسخ
```yaml
# pubspec.yaml
version: 1.0.0+1  # version+buildNumber
```

### 2. Release Notes واضحة
```
Version 1.0.0

🚀 New Features:
• Feature 1
• Feature 2

🐛 Bug Fixes:
• Fix 1
• Fix 2

⚠️ Breaking Changes:
• Change 1
```

### 3. مجموعات متعددة
```bash
--groups "testers,internal,beta"
```

### 4. اختبار قبل النشر
```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

---

## 📚 أوامر مفيدة

```bash
# عرض المساعدة
firebase appdistribution --help

# عرض التطبيقات
firebase apps:list

# عرض التوزيعات
firebase appdistribution:distributions:list --app APP_ID

# حذف توزيع
firebase appdistribution:distributions:delete RELEASE_ID --app APP_ID

# إضافة مختبرين
firebase appdistribution:testers:add email@example.com --groups testers
```

---

## 🎉 نشر ناجح!

بعد النشر:
1. ✅ تحقق من Firebase Console
2. ✅ تأكد من وصول Email للمختبرين
3. ✅ اختبر التنزيل والتثبيت
4. ✅ اجمع Feedback

---

## 🔗 روابط مفيدة

- [Firebase Console](https://console.firebase.google.com/project/wird-islamic-app/appdistribution)
- [Firebase CLI Docs](https://firebase.google.com/docs/cli)
- [App Distribution Docs](https://firebase.google.com/docs/app-distribution)
- [Flutter Release Guide](https://docs.flutter.dev/deployment/android)

---

*آخر تحديث: 2026-02-28*
