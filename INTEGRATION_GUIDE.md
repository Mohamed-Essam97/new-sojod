# Wird Integration Guide

هذا الدليل يشرح كيفية ربط الميزات الموجودة (Adhkar, Tasbeeh, Quran) مع نظام Wird للتتبع التلقائي.

## 🎯 الهدف

عندما يكمل المستخدم:
- **أذكار الصباح** → تحديث `adhkarMorningDone = true` في Wird اليوم
- **أذكار المساء** → تحديث `adhkarEveningDone = true`
- **أذكار النوم** → تحديث `sleepDhikrDone = true`
- **قراءة القرآن (صفحات)** → تحديث `quranProgressPages`
- **التسبيح** → تحديث `tasbeehProgress`

---

## 📝 خطوات التنفيذ

### 1. ربط صفحة Adhkar مع Wird

**الملف:** `lib/features/adhkar/presentation/pages/adhkar_page.dart`

```dart
// في نهاية الـAdhkarPage، عند إكمال فئة أذكار معينة:

import '../../../wird/presentation/cubit/wird_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

// في الـwidget state أو عند الانتهاء من الأذكار:
void _onAdhkarCompleted(String type) async {
  final authState = context.read<AuthCubit>().state;
  if (authState is! AuthAuthenticated) return;
  
  final wirdCubit = context.read<WirdCubit>();
  
  // تحديث Wird حسب النوع
  switch(type) {
    case 'morning':
      await wirdCubit.toggleAdhkarMorning();
      break;
    case 'evening':
      await wirdCubit.toggleAdhkarEvening();
      break;
    case 'sleep':
      await wirdCubit.toggleSleepDhikr();
      break;
  }
}
```

**أو أفضل:** إنشاء زر "تم" في نهاية كل فئة أذكار:

```dart
ElevatedButton(
  onPressed: () {
    _markAdhkarComplete('morning'); // أو evening أو sleep
  },
  child: Text('تم ✓'),
)
```

---

### 2. ربط صفحة Tasbeeh مع Wird

**الملف:** `lib/features/tasbeeh/presentation/pages/tasbeeh_page.dart`

```dart
// عند كل increment في العداد:

import '../../../wird/presentation/cubit/wird_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

void _incrementTasbeeh() {
  // الكود الحالي للـincrement
  final newCount = currentCount + 1;
  
  // تحديث Wird
  final authState = context.read<AuthCubit>().state;
  if (authState is AuthAuthenticated) {
    context.read<WirdCubit>().updateTasbeehProgress(newCount);
  }
  
  setState(() {
    currentCount = newCount;
  });
}
```

---

### 3. ربط Quran Reader مع Wird

**الملف:** `lib/features/quran/presentation/pages/quran_reader_page.dart`

عندما ينتقل المستخدم لصفحة جديدة، احسب عدد الصفحات المقروءة:

```dart
// في الـQuranReaderPage

import '../../../wird/presentation/cubit/wird_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

void _onPageChanged(int newPage) {
  // الكود الحالي
  setState(() {
    currentPage = newPage;
  });
  
  // تحديث Wird (اختياري: يمكن تتبع الصفحات المقروءة)
  final authState = context.read<AuthCubit>().state;
  if (authState is AuthAuthenticated) {
    // احسب عدد الصفحات المقروءة اليوم (يحتاج logic إضافي)
    final pagesReadToday = _calculatePagesReadToday();
    context.read<WirdCubit>().updateQuranProgress(pagesReadToday);
  }
}
```

**Note:** هذا يحتاج logic أكثر تعقيداً لتتبع الصفحات الفريدة المقروءة.

---

## 🔧 إضافة WirdCubit للصفحات

يجب إضافة `WirdCubit` للـBlocProvider في الصفحات التي تريد الربط معها:

### مثال: AdhkarPage

```dart
class AdhkarPage extends StatelessWidget {
  const AdhkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AdhkarCubit>()),
        BlocProvider(create: (_) => sl<WirdCubit>()), // ← إضافة هذا
      ],
      child: const _AdhkarView(),
    );
  }
}
```

تكرر نفس الشيء لـ:
- `TasbeehPage`
- `QuranReaderPage`

---

## 💡 نصائح إضافية

### 1. تحميل Wird اليوم عند فتح الصفحة

```dart
@override
void initState() {
  super.initState();
  final authState = context.read<AuthCubit>().state;
  if (authState is AuthAuthenticated) {
    context.read<WirdCubit>().loadTodayWird(authState.user.uid);
  }
}
```

### 2. عرض Progress في الصفحة

```dart
BlocBuilder<WirdCubit, WirdState>(
  builder: (context, state) {
    if (state is WirdLoaded) {
      return Text('صفحات اليوم: ${state.wird.quranProgressPages}/${state.wird.quranTargetPages}');
    }
    return SizedBox.shrink();
  },
)
```

### 3. Toast Message عند التحديث

```dart
void _updateWird() async {
  await context.read<WirdCubit>().toggleAdhkarMorning();
  
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحديث الورد ✓')),
    );
  }
}
```

---

## ✅ Checklist

- [ ] إضافة `WirdCubit` لـBlocProvider في كل صفحة
- [ ] تحميل Wird اليوم عند فتح الصفحة
- [ ] ربط Adhkar completion مع Wird
- [ ] ربط Tasbeeh counter مع Wird
- [ ] ربط Quran reading مع Wird (اختياري)
- [ ] اختبار التكامل
- [ ] عرض feedback للمستخدم

---

## 🎨 UI Enhancements (اختياري)

### عرض Wird Progress في Navigation Bar

```dart
// في CustomBottomNavBar أو أي مكان مناسب
BlocBuilder<WirdCubit, WirdState>(
  builder: (context, state) {
    if (state is WirdLoaded) {
      final progress = state.wird.quranProgress;
      return LinearProgressIndicator(value: progress);
    }
    return SizedBox.shrink();
  },
)
```

### Badge للإشعار بإكمال Wird

```dart
Badge(
  label: Text('✓'),
  isLabelVisible: state.wird.isQuranComplete,
  child: Icon(Icons.book),
)
```

---

*Last Updated: 2026-02-28*
