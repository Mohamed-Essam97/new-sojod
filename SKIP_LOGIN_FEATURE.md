# Skip Login Feature - ميزة تخطي تسجيل الدخول

## ✅ تم التنفيذ

تمت إضافة ميزة **"تخطي تسجيل الدخول"** للسماح للمستخدمين باستخدام التطبيق بدون إنشاء حساب.

---

## 🎯 الميزات

### 1. زر "تخطي الآن" في صفحة Login
- يظهر في أسفل الصفحة
- نص: "تخطي الآن" / "Skip for now"
- ينتقل مباشرة إلى الصفحة الرئيسية

### 2. Splash Screen لا يتطلب تسجيل دخول
- يفحص الـPermissions فقط
- ينتقل مباشرة للـHome بدون فحص Auth

### 3. الميزات المتاحة بدون تسجيل دخول ✅
- ✅ **القرآن الكريم** - قراءة كاملة مع مشغل صوتي
- ✅ **أوقات الصلاة** - جميع الأوقات والإشعارات
- ✅ **الأذكار** - جميع الأذكار والأدعية
- ✅ **القبلة** - اتجاه القبلة مع البوصلة
- ✅ **التسبيح** - العداد كامل
- ✅ **البحث عن المساجد** - الخريطة والمواقع
- ✅ **التقويم الهجري** - التواريخ والأحداث

### 4. الميزات التي تتطلب تسجيل دخول 🔒
- 🔒 **وِردي اليومي** - تتبع الورد (يحتاج حفظ في Firestore)
- 🔒 **المجموعات** - إنشاء والانضمام للمجموعات
- 🔒 **الملف الشخصي** - تعديل البيانات الشخصية

---

## 📱 تجربة المستخدم

### بدون تسجيل دخول:
```
Splash → Home → جميع الميزات الأساسية متاحة
```

### عند محاولة الوصول لـWird/Groups:
```
Wird/Groups Page → شاشة "تسجيل الدخول مطلوب" → زر "تسجيل الدخول"
```

---

## 🎨 الواجهات المُحدّثة

### 1. Login Page
```dart
// زر جديد في الأسفل
TextButton(
  onPressed: () => context.go('/home'),
  child: Text('تخطي الآن' / 'Skip for now'),
)
```

### 2. Wird Dashboard
```dart
// إذا لم يسجل دخول
_SignInRequiredView(
  title: 'تسجيل الدخول مطلوب',
  message: 'سجل دخول لتتبع وِردك اليومي',
  icon: Icons.lock_outline,
)
```

### 3. Groups List
```dart
// نفس التصميم مع أيقونة مختلفة
_SignInRequiredView(
  title: 'تسجيل الدخول مطلوب',
  message: 'سجل دخول لإنشاء والانضمام للمجموعات',
  icon: Icons.lock_outline,
)
```

### 4. Settings Page
```dart
// تبديل ديناميكي
isAuthenticated 
  ? 'الملف الشخصي' 
  : 'تسجيل الدخول'
```

---

## 🔧 التعديلات التقنية

### الملفات المُعدّلة:

1. **`lib/features/auth/presentation/pages/login_page.dart`**
   - ✅ إضافة زر "Skip for now"

2. **`lib/features/splash/presentation/pages/splash_page.dart`**
   - ✅ إزالة فحص Auth
   - ✅ الانتقال مباشرة للـHome بعد فحص Permissions

3. **`lib/features/wird/presentation/pages/wird_dashboard_page.dart`**
   - ✅ إضافة `_SignInRequiredView` widget
   - ✅ فحص Auth state قبل عرض المحتوى

4. **`lib/features/groups/presentation/pages/groups_list_page.dart`**
   - ✅ إضافة فحص Auth في البداية
   - ✅ إضافة `_SignInRequiredView` widget

5. **`lib/features/settings/presentation/pages/settings_page.dart`**
   - ✅ إضافة imports للـAuth Cubit
   - ✅ تبديل ديناميكي بين "Profile" و "Sign In"

---

## 📊 حالات الاستخدام

### Case 1: مستخدم جديد بدون حساب
```
1. يفتح التطبيق
2. Splash → يطلب permissions
3. يضغط "تخطي الآن" في Login
4. يصل للـHome
5. يستخدم القرآن، الأذكار، القبلة، إلخ
6. إذا حاول فتح Wird → "تسجيل الدخول مطلوب"
```

### Case 2: مستخدم لديه حساب
```
1. يفتح التطبيق
2. Splash → يفحص permissions
3. يسجل دخول (Google/Facebook)
4. جميع الميزات متاحة (بما فيها Wird & Groups)
```

### Case 3: مستخدم بدون حساب يريد استخدام Wird
```
1. يفتح Wird من Home
2. شاشة "تسجيل الدخول مطلوب"
3. يضغط "تسجيل الدخول"
4. ينتقل لصفحة Login
5. يسجل دخول
6. يُعاد توجيهه للـHome
7. يفتح Wird مرة أخرى → متاح الآن ✅
```

---

## 🎯 الفوائد

1. **تجربة أسهل** - المستخدم يجرب التطبيق بدون التزام
2. **معدل تنزيل أعلى** - لا يتطلب حساب فوراً
3. **مرونة** - المستخدم يقرر متى يسجل دخول
4. **احترام الخصوصية** - لا يُجبر على مشاركة بياناته

---

## 🧪 الاختبار

### Checklist:
- [ ] فتح التطبيق → يمكن تخطي Login
- [ ] جميع الميزات الأساسية تعمل بدون Auth
- [ ] فتح Wird بدون تسجيل → شاشة "Sign In Required"
- [ ] فتح Groups بدون تسجيل → شاشة "Sign In Required"
- [ ] Settings → "تسجيل الدخول" بدلاً من "Profile"
- [ ] تسجيل الدخول بعد التخطي → كل شيء يعمل

---

## 📝 ملاحظات للمطورين

### إضافة ميزة جديدة تحتاج Auth:
```dart
final authState = context.read<AuthCubit>().state;
if (authState is! AuthAuthenticated) {
  return _SignInRequiredView(
    isAr: isAr,
    isDark: isDark,
  );
}

// الكود العادي هنا...
```

### إضافة ميزة لا تحتاج Auth:
```dart
// لا حاجة لأي فحص - اشتغل مباشرة!
@override
Widget build(BuildContext context) {
  return YourWidget();
}
```

---

## 🚀 المستقبل (V2)

- [ ] Guest Mode كامل مع حفظ محلي (SharedPreferences/Hive)
- [ ] تحويل Guest Data إلى Account عند التسجيل
- [ ] رسالة ترحيبية للـGuest users
- [ ] تذكير بسيط للتسجيل بعد استخدام مكثف

---

*تم التنفيذ: 2026-02-28*
*الحالة: ✅ مكتمل وجاهز للاختبار*
