import 'package:flutter/material.dart';

// ======================
// APP COLORS
// ======================
class AppColors {
  // COLORS UNTUK LOGIN/REGISTER (JANGAN DIUBAH!)
  static const primary = Color(0xFF5B67CA);
  static const secondary = Color(0xFF9055FF);
  static const background = Color(0xFFF8F9FE);
  static const textDark = Color(0xFF2E3E5C);
  static const textLight = Color(0xFF9FA5C0);
  static const success = Color(0xFF00D09E);
  static const danger = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFECA57);
  static const income = Color(0xFF00D09E);
  static const expense = Color(0xFFFF6B6B);
  
  // COLORS TAMBAHAN UNTUK DASHBOARD (BARU)
  static const incomeBg = Color(0xFFD1FAE5);       // Light green
  static const expenseBg = Color(0xFFFEE2E2);      // Light red
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const cardBg = Color(0xFFFFFFFF);
  static const inputBg = Color(0xFFF3F4F6);
  static const divider = Color(0xFFE5E7EB);
}

// ======================
// APP CONSTANTS
// ======================
class AppConstants {
  // CURRENCY API (SUDAH ADA)
  static const String currencyApiKey = '00f6c996f0bb00ac7245b00a';
  static const String currencyApiUrl = 'https://v6.exchangerate-api.com/v6/';
  static const String defaultCurrency = 'IDR';
  
  // APP INFO (BARU)
  static const String appName = 'Money Tracker';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Level up finansialmu!';
  
  // ASSETS PATHS (BARU)
  static const String bgLogin = 'assets/img/bglogin.png';    // Untuk login/register
  static const String bgApp = 'assets/img/bgapp.png';        // Untuk dashboard/app (ganti nama sesuai file kamu)
  
  // PIXEL DESIGN CONSTANTS (BARU - UNTUK DASHBOARD)
  static const double pixelBorderWidth = 3.0;
  static const double pixelBorderWidthThin = 2.0;
  static const double pixelShadowOffset = 4.0;
  static const double pixelCardRadius = 0.0;
  static const double pixelButtonRadius = 12.0;
  
  // SPACING (BARU)
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  
  // FONT SIZES (BARU)
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeTitle = 32.0;
  
  // ICON SIZES (BARU)
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 40.0;
}

// ======================
// TRANSACTION CATEGORIES (SUDAH ADA)
// ======================
class TransactionCategories {
  static const List<String> expenseCategories = [
    'Makanan & Minuman',
    'Transport',
    'Belanja',
    'Hiburan',
    'Tagihan',
    'Kesehatan',
    'Pendidikan',
    'Lainnya',
  ];
  
  static const List<String> incomeCategories = [
    'Gaji',
    'Bonus',
    'Investasi',
    'Bisnis',
    'Hadiah',
    'Lainnya',
  ];
  
  static const Map<String, String> categoryIcons = {
    'Makanan & Minuman': '🍔',
    'Transport': '🚗',
    'Belanja': '🛍️',
    'Hiburan': '🎮',
    'Tagihan': '💡',
    'Kesehatan': '🏥',
    'Pendidikan': '📚',
    'Gaji': '💰',
    'Bonus': '🎁',
    'Investasi': '📈',
    'Bisnis': '💼',
    'Hadiah': '🎉',
    'Lainnya': '📦',
  };
  
  // CATEGORY COLORS (BARU - UNTUK DASHBOARD)
  static const Map<String, Color> categoryColors = {
    'Makanan & Minuman': Color(0xFFFF6B6B),
    'Transport': Color(0xFF5B67CA),
    'Belanja': Color(0xFF9055FF),
    'Hiburan': Color(0xFFFECA57),
    'Tagihan': Color(0xFF00D09E),
    'Kesehatan': Color(0xFFFF6B6B),
    'Pendidikan': Color(0xFF5B67CA),
    'Lainnya': Color(0xFF6B7280),
    'Gaji': Color(0xFF00D09E),
    'Bonus': Color(0xFFFECA57),
    'Investasi': Color(0xFF5B67CA),
    'Bisnis': Color(0xFF9055FF),
    'Hadiah': Color(0xFFFF6B6B),
  };
}

// ======================
// PIXEL DECORATIONS (BARU - UNTUK DASHBOARD)
// ======================
class PixelDecorations {
  static BoxDecoration pixelCard({
    Color? bgColor,
    double? borderWidth,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: bgColor ?? AppColors.white,
      border: Border.all(
        color: borderColor ?? AppColors.black,
        width: borderWidth ?? AppConstants.pixelBorderWidth,
      ),
      borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
      boxShadow: [
        BoxShadow(
          color: AppColors.black,
          offset: Offset(
            AppConstants.pixelShadowOffset,
            AppConstants.pixelShadowOffset,
          ),
          blurRadius: 0,
        ),
      ],
    );
  }
  
  static BoxDecoration pixelButton({
    required Color bgColor,
    double? borderWidth,
  }) {
    return BoxDecoration(
      color: bgColor,
      border: Border.all(
        color: AppColors.black,
        width: borderWidth ?? AppConstants.pixelBorderWidth,
      ),
      borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.3),
          offset: Offset(
            AppConstants.pixelShadowOffset,
            AppConstants.pixelShadowOffset,
          ),
          blurRadius: 0,
        ),
      ],
    );
  }
  
  static BoxDecoration pixelStatCard({
    required Color bgColor,
  }) {
    return BoxDecoration(
      color: bgColor,
      border: Border.all(
        color: AppColors.black,
        width: AppConstants.pixelBorderWidthThin,
      ),
      borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
    );
  }
}

// ======================
// TEXT STYLES (BARU - UNTUK DASHBOARD)
// ======================
class PixelTextStyles {
  static const String fontFamily = 'Minecraftia';
  
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeTitle,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    letterSpacing: 1,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeXXL,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    letterSpacing: 1,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeXL,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    letterSpacing: 1,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeM,
    color: AppColors.textDark,
  );
  
  static const TextStyle bodyLight = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeM,
    color: AppColors.textLight,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeS,
    color: AppColors.textLight,
  );
  
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeL,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppConstants.fontSizeXS,
    color: AppColors.textLight,
  );
}

// ======================
// PIXEL BACKGROUND WIDGETS (BARU)
// ======================

// Background untuk Login/Register (JANGAN DIPAKAI DI LOGIN/REGISTER KARENA MEREKA UDAH HANDLE SENDIRI)
class PixelBackgroundAuth extends StatelessWidget {
  final Widget child;
  
  const PixelBackgroundAuth({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppConstants.bgLogin),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

// Background untuk Dashboard & App
class PixelBackgroundApp extends StatelessWidget {
  final Widget child;
  
  const PixelBackgroundApp({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppConstants.bgApp),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}