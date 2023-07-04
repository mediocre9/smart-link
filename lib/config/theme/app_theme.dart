import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: AppColors.kPrimary,
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xFFE2D9F8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.kElevatedButton,
        foregroundColor: AppColors.kElevatedButtonText,
        shape: CircleBorder(),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: BeveledRectangleBorder(),
        backgroundColor: AppColors.kScaffold,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.kProgressIndicator,
      ),
      cardTheme: CardTheme(
        color: AppColors.kCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(
            color: AppColors.kCardBorder,
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        tileColor: AppColors.kListTile,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            AppColors.kElevatedButton,
          ),
          foregroundColor: MaterialStateProperty.all(
            AppColors.kElevatedButtonText,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.kSnackbar,
        contentTextStyle: const TextStyle(
          color: AppColors.kSnackbarText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.kMediumDisplay,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.kMediumDisplay,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: AppColors.kSmallTitle,
          fontWeight: FontWeight.w300,
        ),
        titleMedium: TextStyle(
          color: AppColors.kMediumTitle,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        labelSmall: TextStyle(
          color: AppColors.kSmallLabel,
        ),
        labelMedium: TextStyle(
          color: AppColors.kMediumLabel,
        ),
        labelLarge: TextStyle(
          color: AppColors.kLargeLabel,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
