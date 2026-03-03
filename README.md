# Wird - وِرد 📿

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)

**تطبيق إسلامي شامل لتتبع الورد اليومي ومشاركته مع الأصدقاء**

[العربية](#-المزايا) • [English](#-features)

</div>

---

## 📱 نظرة عامة / Overview

**Wird** هو تطبيق إسلامي شامل يساعدك على:
- 📖 تتبع قراءة القرآن اليومية
- 🤲 إكمال الأذكار (صباح، مساء، نوم)
- 📿 عد التسبيح مع أهداف يومية
- 👥 مشاركة تقدمك مع أصدقائك في مجموعات
- 🔔 إشعارات ذكية للأذكار وأوقات الصلاة

**Wird** is a comprehensive Islamic app that helps you:
- 📖 Track daily Quran reading
- 🤲 Complete daily Adhkar (morning, evening, sleep)
- 📿 Count Tasbeeh with daily goals
- 👥 Share your progress with friends in groups
- 🔔 Smart notifications for Adhkar and prayer times

---

## ✨ المزايا / Features

### 🔐 المصادقة / Authentication
- تسجيل الدخول بـ Google
- إدارة الملف الشخصي
- حفظ البيانات في Firestore

### 📿 الورد اليومي / Daily Wird
- تتبع صفحات القرآن المقروءة
- قائمة مهام للأذكار (صباح/مساء/نوم)
- عداد التسبيح مع أهداف قابلة للتخصيص
- تحديثات فورية (Real-time)
- تاريخ الورد

### 👥 المجموعات / Groups
- إنشاء مجموعات خاصة
- دعوة الأصدقاء بكود
- مشاهدة تقدم الأعضاء
- أدوار المجموعة (Owner, Admin, Member)

### 📖 القرآن الكريم
- قارئ القرآن الكامل
- اختيار من بين 20+ قارئ
- مشغل صوتي عالمي مستمر
- تشغيل في الخلفية (Background playback)
- وضع علامات مرجعية

### 🤲 الأذكار والأدعية
- أذكار الصباح والمساء
- أذكار النوم
- أدعية متنوعة
- إشعارات تذكير

### 🕌 ميزات إضافية
- أوقات الصلاة
- اتجاه القبلة
- البحث عن المساجد
- التقويم الهجري
- عداد التسبيح

---

## 🏗️ البنية المعمارية / Architecture

التطبيق مبني على **Clean Architecture** مع:

```
lib/
├── core/                 # الأساسيات (DI, Routing, Theme)
├── features/            
│   ├── auth/            # المصادقة والملف الشخصي
│   ├── wird/            # تتبع الورد اليومي
│   ├── groups/          # إدارة المجموعات
│   ├── quran/           # قارئ القرآن
│   ├── adhkar/          # الأذكار
│   ├── prayer/          # أوقات الصلاة
│   ├── qibla/           # اتجاه القبلة
│   ├── tasbeeh/         # عداد التسبيح
│   └── ...
```

### الطبقات / Layers
- **Domain:** Entities, Repositories (interfaces), Use Cases
- **Data:** Models, Repository Implementations, Data Sources
- **Presentation:** Cubit/Bloc, Pages, Widgets

---

## 🚀 البدء / Getting Started

### المتطلبات / Prerequisites
- Flutter 3.10 أو أحدث
- Dart 3.0 أو أحدث
- Firebase project
- Android Studio / Xcode

### التثبيت / Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/wird.git
cd wird

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### إعداد Firebase / Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)

2. Add Android & iOS apps to your Firebase project

3. Download configuration files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

4. Enable Authentication providers (Google)

5. Deploy Firestore Security Rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

📖 **راجع `DEPLOYMENT_GUIDE.md` للتفاصيل الكاملة**

---

## 📦 التقنيات المستخدمة / Technologies

### Frontend
- **Flutter** - UI Framework
- **flutter_bloc** - State Management
- **go_router** - Navigation
- **get_it** - Dependency Injection

### Backend & Services
- **Firebase Auth** - Authentication
- **Cloud Firestore** - Database
- **Firebase Storage** - File Storage
- **Firebase Analytics** - Analytics

### Audio
- **just_audio** - Audio Player
- **audio_service** - Background Audio
- **audio_session** - Audio Session Management

### Other Packages
- `quran_with_tafsir` - Quran API
- `adhan` - Prayer times
- `hijri` - Hijri calendar
- `flutter_compass` - Qibla direction
- `share_plus` - Sharing
- `permission_handler` - Permissions

---

## 📸 لقطات الشاشة / Screenshots

<div align="center">

| Login | Wird Dashboard | Groups |
|-------|---------------|--------|
| ![Login](docs/screenshots/login.png) | ![Wird](docs/screenshots/wird.png) | ![Groups](docs/screenshots/groups.png) |

| Quran Reader | Prayer Times | Qibla |
|--------------|--------------|-------|
| ![Quran](docs/screenshots/quran.png) | ![Prayer](docs/screenshots/prayer.png) | ![Qibla](docs/screenshots/qibla.png) |

</div>

---

## 📚 الوثائق / Documentation

- 📋 [WIRD_IMPLEMENTATION_STATUS.md](WIRD_IMPLEMENTATION_STATUS.md) - حالة التطوير
- 🚀 [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - دليل النشر
- 🔗 [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) - دليل التكامل
- 🎨 [DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) - نظام التصميم (قريباً)

---

## 🧪 الاختبار / Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Generate coverage report
flutter test --coverage
```

---

## 🤝 المساهمة / Contributing

نرحب بالمساهمات! الرجاء:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 الترخيص / License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 المطور / Developer

**تم التطوير بواسطة:** Your Name
- 📧 Email: your.email@example.com
- 🐙 GitHub: [@yourusername](https://github.com/yourusername)
- 🐦 Twitter: [@yourusername](https://twitter.com/yourusername)

---

## 🙏 شكر وتقدير / Acknowledgments

- [Quran.com API](https://quran.com)
- [EveryAyah.com](https://everyayah.com) - Quran audio
- [Islamic Network](https://aladhan.com) - Prayer times API
- Flutter & Firebase teams
- جميع المساهمين في المشروع

---

## 📊 إحصائيات / Stats

![GitHub stars](https://img.shields.io/github/stars/yourusername/wird?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/wird?style=social)
![GitHub issues](https://img.shields.io/github/issues/yourusername/wird)
![GitHub pull requests](https://img.shields.io/github/issues-pr/yourusername/wird)

---

<div align="center">

**صُنع بـ ❤️ و ☕️**

**Made with ❤️ and ☕️**

[⬆ العودة للأعلى / Back to top](#wird---وِرد-)

</div>
