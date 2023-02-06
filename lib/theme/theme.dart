import 'package:flutter/material.dart';

import '../config/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: AppColors.PRIMARY_COLOR,

      /**
      * Scaffold theme...
      */
      scaffoldBackgroundColor: AppColors.SCAFFOLD_COLOR,

      /**
      * AppBar theme...
      */
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.APP_BAR_COLOR,
        titleTextStyle: TextStyle(
          color: AppColors.APP_BAR_TEXT_COLOR,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),

      /**
      * Popup menu theme
      */
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xFFE2D9F8),
      ),

      /**
      * Bottom Sheet theme data...
      */
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.BOTTOM_SHEET_COLOR,
      ),

      /**
      * Progress Indicator theme...
      */
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.PROGRESS_INDICATOR_COLOR,
      ),

      /**
      * Card theme...
      */
      cardTheme: CardTheme(
        color: AppColors.CARD_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(
            color: AppColors.CARD_BORDER_COLOR,
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        tileColor: AppColors.LIST_TILE_COLOR,
      ),

      /**
      * Elevated button theme....
      */
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            AppColors.ELEVATED_BUTTON_COLOR,
          ),
          foregroundColor: MaterialStateProperty.all(
            AppColors.ELEVATED_BUTTON_TEXT_COLOR,
          ),
        ),
      ),

      /**
      * SnackBar theme...
      */
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.SNACKBAR_COLOR,
        contentTextStyle: const TextStyle(
          color: AppColors.SNACKBAR_CONTENT_COLOR,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      /**
      * Text Theme...
      */
      textTheme: const TextTheme(
        displayMedium: TextStyle(
          color: AppColors.DISPLAY_MEDIUM_COLOR,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: AppColors.TITLE_SMALL_COLOR,
          fontWeight: FontWeight.w300,
        ),
        titleMedium: TextStyle(
          color: AppColors.TITLE_MEDIUM_COLOR,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        labelSmall: TextStyle(
          color: AppColors.LABEL_SMALL_COLOR,
        ),
        labelMedium: TextStyle(
          color: AppColors.LABEL_MEDIUM_COLOR,
        ),
        labelLarge: TextStyle(
          color: AppColors.LABEL_LARGE_COLOR,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
