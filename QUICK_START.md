# البدء السريع - نظام واصل
## Quick Start Guide

---

## ⚡ البدء في 5 دقائق

### 1. تحميل المشروع
```bash
git clone https://github.com/fahmy1284/Wasel-Portal-.git
cd Wasel-Portal-/wasel_system
```

### 2. إعداد Supabase
1. أنشئ حساب في [Supabase](https://supabase.com)
2. أنشئ مشروع جديد
3. انسخ محتوى `database/supabase_schema.sql` وشغله في SQL Editor

### 3. تكوين المفاتيح
```dart
// في common/lib/constants/app_constants.dart
static const String supabaseUrl = 'YOUR_URL_HERE';
static const String supabaseAnonKey = 'YOUR_KEY_HERE';
```

### 4. تثبيت التبعيات
```bash
cd common && flutter pub get
cd ../admin_portal && flutter pub get
cd ../user_portal && flutter pub get
```

### 5. تشغيل التطبيق
```bash
# بوابة الإدارة
cd admin_portal && flutter run

# أو تطبيق المواطنين
cd user_portal && flutter run
```

---

## 🎯 الميزات الرئيسية

### بوابة الإدارة:
- ✅ لوحة تحكم شاملة
- ✅ إدارة المستخدمين والخدمات
- ✅ تقارير وإحصائيات
- ✅ معالجة الطلبات

### تطبيق المواطنين:
- ✅ تسجيل دخول آمن
- ✅ تصفح الخدمات
- ✅ تقديم الطلبات
- ✅ تتبع الحالة

---

## 🔗 روابط مهمة

- **المشروع**: https://github.com/fahmy1284/Wasel-Portal-
- **التحميل المباشر**: https://github.com/fahmy1284/Wasel-Portal-/archive/refs/heads/main.zip
- **الوثائق الكاملة**: [README.md](wasel_system/README.md)
- **دليل التثبيت**: [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)

---

**جاهز للاستخدام! 🚀**