# دليل التثبيت والتشغيل - نظام واصل
## Installation Guide - Wasel Portal System

---

## 📥 تحميل المشروع

### الطريقة الأولى: Git Clone
```bash
git clone https://github.com/fahmy1284/Wasel-Portal-.git
cd Wasel-Portal-/wasel_system
```

### الطريقة الثانية: تحميل ZIP
1. اذهب إلى: https://github.com/fahmy1284/Wasel-Portal-
2. اضغط على الزر الأخضر "Code"
3. اختر "Download ZIP"
4. فك الضغط عن الملف

---

## 🛠️ المتطلبات الأساسية

### 1. Flutter SDK
```bash
# تحميل Flutter من الموقع الرسمي
https://flutter.dev/docs/get-started/install

# التحقق من التثبيت
flutter doctor
```

### 2. Dart SDK
```bash
# يأتي مع Flutter تلقائياً
dart --version
```

### 3. محرر النصوص
- Android Studio (مُوصى به)
- VS Code مع إضافة Flutter
- IntelliJ IDEA

---

## 🗄️ إعداد قاعدة البيانات

### 1. إنشاء حساب Supabase
1. اذهب إلى: https://supabase.com
2. أنشئ حساب جديد
3. أنشئ مشروع جديد

### 2. تشغيل ملف قاعدة البيانات
1. اذهب إلى SQL Editor في Supabase
2. انسخ محتوى ملف `wasel_system/database/supabase_schema.sql`
3. شغل الكود في SQL Editor

### 3. الحصول على مفاتيح API
1. اذهب إلى Settings > API
2. انسخ:
   - Project URL
   - Anon Public Key

---

## ⚙️ تكوين المشروع

### 1. تحديث الثوابت
افتح ملف `wasel_system/common/lib/constants/app_constants.dart` وحدث:

```dart
class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
  
  // باقي الثوابت...
}
```

### 2. تثبيت التبعيات

```bash
# للمكتبة المشتركة
cd wasel_system/common
flutter pub get

# لبوابة الإدارة
cd ../admin_portal
flutter pub get

# لتطبيق المواطنين
cd ../user_portal
flutter pub get
```

---

## 🚀 تشغيل التطبيقات

### بوابة الإدارة (Admin Portal)
```bash
cd wasel_system/admin_portal
flutter run
```

### تطبيق المواطنين (User Portal)
```bash
cd wasel_system/user_portal
flutter run
```

---

## 👥 بيانات تسجيل الدخول الافتراضية

### للإدارة:
- **البريد الإلكتروني**: admin@wasel.gov.ye
- **كلمة المرور**: Admin@123

### للمواطن:
- **البريد الإلكتروني**: citizen@example.com
- **كلمة المرور**: Citizen@123

*ملاحظة: يجب إنشاء هذه الحسابات في قاعدة البيانات أولاً*

---

## 📱 إنشاء حسابات المستخدمين

### 1. حساب الإدارة
```sql
-- في Supabase SQL Editor
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  'admin@wasel.gov.ye',
  crypt('Admin@123', gen_salt('bf')),
  now(),
  now(),
  now()
);

-- إضافة بيانات المستخدم
INSERT INTO users (id, email, full_name, role, is_active, created_at)
VALUES (
  (SELECT id FROM auth.users WHERE email = 'admin@wasel.gov.ye'),
  'admin@wasel.gov.ye',
  'مدير النظام',
  'super_admin',
  true,
  now()
);
```

### 2. حساب المواطن
```sql
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  'citizen@example.com',
  crypt('Citizen@123', gen_salt('bf')),
  now(),
  now(),
  now()
);

INSERT INTO users (id, email, full_name, national_id, role, is_active, created_at)
VALUES (
  (SELECT id FROM auth.users WHERE email = 'citizen@example.com'),
  'citizen@example.com',
  'أحمد محمد علي',
  '123456789',
  'citizen',
  true,
  now()
);
```

---

## 🔧 استكشاف الأخطاء

### مشكلة: Flutter Doctor يظهر أخطاء
```bash
flutter doctor --android-licenses
flutter doctor
```

### مشكلة: خطأ في الاتصال بـ Supabase
1. تأكد من صحة URL و API Key
2. تأكد من تشغيل ملف قاعدة البيانات
3. تحقق من إعدادات RLS في Supabase

### مشكلة: خطأ في تثبيت التبعيات
```bash
flutter clean
flutter pub get
```

### مشكلة: خطأ في البناء
```bash
flutter clean
flutter pub get
flutter pub deps
flutter run
```

---

## 📚 الموارد المفيدة

### الوثائق:
- [Flutter Documentation](https://flutter.dev/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### المجتمع:
- [Flutter Community](https://flutter.dev/community)
- [Supabase Community](https://supabase.com/docs/guides/getting-started)

---

## 🆘 الدعم والمساعدة

### للمساعدة التقنية:
- **البريد الإلكتروني**: support@wasel.gov.ye
- **GitHub Issues**: https://github.com/fahmy1284/Wasel-Portal-/issues

### الإبلاغ عن الأخطاء:
1. اذهب إلى GitHub Issues
2. أنشئ Issue جديد
3. اكتب وصف مفصل للمشكلة

---

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT. راجع ملف LICENSE للتفاصيل.

---

**تم التطوير بـ ❤️ للجمهورية اليمنية**

*آخر تحديث: ديسمبر 2024*