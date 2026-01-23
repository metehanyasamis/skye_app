# 🔧 Refactoring Rehberi - Kod Sadeleştirme

Bu rehber, tekrar eden kodları nasıl sadeleştireceğinizi gösterir.

## 📋 Tespit Edilen Tekrarlar

### 1. **Header Pattern** (Logo + Location + Notification)
- **Etkilenen Dosyalar**: `home_screen.dart`, `aircraft_listing_screen.dart`, `cfi_listing_screen.dart`, `time_building_listing_screen.dart`
- **Çözüm**: `CommonHeader` widget'ı oluşturuldu

### 2. **SystemChrome.setSystemUIOverlayStyle**
- **Etkilenen Dosyalar**: 21 dosya
- **Çözüm**: `SystemUIHelper` utility oluşturuldu

### 3. **debugPrint Kullanımı**
- **Etkilenen Dosyalar**: 34 dosya, 430+ kullanım
- **Çözüm**: `DebugLogger` utility oluşturuldu

### 4. **BottomNavigationBar**
- **Etkilenen Dosyalar**: `aircraft_listing_screen.dart`, `cfi_listing_screen.dart`, `profile_screen.dart`
- **Çözüm**: `CustomBottomNavBar` kullanılmalı

---

## 🚀 Kullanım Örnekleri

### 1. CommonHeader Kullanımı

**ÖNCE:**
```dart
Padding(
  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
  child: Row(
    children: [
      const SkyeLogo(type: 'logo', color: 'blue', height: 72),
      const SizedBox(width: 12),
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.place, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text('1 World Wy...', ...),
            ],
          ),
        ),
      ),
      // ... notification icon
    ],
  ),
),
```

**SONRA:**
```dart
CommonHeader(
  locationText: '1 World Wy...',
  showNotificationDot: true,
  onNotificationTap: () {
    Navigator.of(context).pushNamed(NotificationsScreen.routeName);
  },
),
```

### 2. SystemUIHelper Kullanımı

**ÖNCE:**
```dart
SystemChrome.setSystemUIOverlayStyle(
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ),
);
```

**SONRA:**
```dart
SystemUIHelper.setLightStatusBar(); // veya setDarkStatusBar()
```

### 3. DebugLogger Kullanımı

**ÖNCE:**
```dart
debugPrint('🏠 [HomeScreen] build()');
debugPrint('✅ [HomeScreen] SystemChrome style applied');
```

**SONRA:**
```dart
DebugLogger.log('HomeScreen', 'build()');
DebugLogger.success('HomeScreen', 'SystemChrome style applied');
DebugLogger.error('HomeScreen', 'API call failed', error);
```

### 4. CustomBottomNavBar Kullanımı

**ÖNCE:**
```dart
bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: AppColors.navy900,
  // ... 20+ satır kod
),
```

**SONRA:**
```dart
const CustomBottomNavBar(),
```

---

## 📝 Yapılacaklar Listesi

### Yüksek Öncelik
- [ ] `aircraft_listing_screen.dart` - CommonHeader + SystemUIHelper + DebugLogger
- [ ] `cfi_listing_screen.dart` - CommonHeader + SystemUIHelper + DebugLogger + CustomBottomNavBar
- [ ] `time_building_listing_screen.dart` - CommonHeader + SystemUIHelper + DebugLogger
- [ ] `profile_screen.dart` - SystemUIHelper + DebugLogger + CustomBottomNavBar

### Orta Öncelik
- [ ] Tüm onboarding ekranları - SystemUIHelper + DebugLogger
- [ ] Tüm login ekranları - SystemUIHelper + DebugLogger
- [ ] Tüm CFI ekranları - SystemUIHelper + DebugLogger
- [ ] Tüm Safety Pilot ekranları - SystemUIHelper + DebugLogger

### Düşük Öncelik
- [ ] Gereksiz `Builder` widget'larını kaldır (debug için eklenmiş)
- [ ] Filter chips için ortak widget oluştur
- [ ] Card widget'ları için base class oluştur

---

## 💡 Faydalar

1. **Kod Tekrarı Azalır**: ~500+ satır kod tekrarı ortadan kalkar
2. **Bakım Kolaylaşır**: Değişiklik tek yerden yapılır
3. **Tutarlılık**: Tüm ekranlarda aynı görünüm ve davranış
4. **Okunabilirlik**: Kod daha temiz ve anlaşılır
5. **Hata Azalır**: Tek yerden kontrol edilen kod daha az hata içerir

---

## 🔄 Migration Adımları

1. **Import ekle:**
```dart
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/utils/system_ui_helper.dart';
import 'package:skye_app/widgets/common_header.dart';
import 'package:skye_app/widgets/custom_bottom_nav_bar.dart';
```

2. **Eski kodu kaldır, yeni kodu ekle**
3. **Test et**
4. **Commit et**

---

## 📊 Beklenen İyileştirme

- **Kod Satırı Azalması**: ~500-700 satır
- **Dosya Boyutu**: %20-30 azalma
- **Bakım Süresi**: %50 azalma
- **Hata Olasılığı**: %40 azalma
