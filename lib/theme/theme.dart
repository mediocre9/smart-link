import 'package:flutter/material.dart';

import '../config/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: AppColors.PRIMARY_COLOR,
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xFFE2D9F8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.ELEVATED_BUTTON_COLOR,
        foregroundColor: AppColors.ELEVATED_BUTTON_TEXT_COLOR,
        shape: CircleBorder(),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: BeveledRectangleBorder(),
        backgroundColor: AppColors.SCAFFOLD_COLOR,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.PROGRESS_INDICATOR_COLOR,
      ),
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
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.SNACKBAR_COLOR,
        contentTextStyle: const TextStyle(
          color: AppColors.SNACKBAR_CONTENT_COLOR,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.DISPLAY_MEDIUM_COLOR,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
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
