import 'package:flutter/material.dart';
import 'package:smart_link/config/config.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: AppColors.primary,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xFFE2D9F8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.elevatedButton,
        foregroundColor: AppColors.elevatedButtonContent,
        shape: CircleBorder(),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: BeveledRectangleBorder(),
        backgroundColor: AppColors.scaffold,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.progressIndicator,
      ),
      cardTheme: CardTheme(
        color: AppColors.pairedCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(
            color: AppColors.pairedCardBorder,
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        tileColor: AppColors.listTile,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            AppColors.elevatedButton,
          ),
          foregroundColor: MaterialStateProperty.all(
            AppColors.elevatedButtonContent,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.snackBar,
        contentTextStyle: const TextStyle(
          color: AppColors.snackBarContent,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.mediumDisplay,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.mediumDisplay,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(
          color: AppColors.smallTitle,
          fontWeight: FontWeight.w300,
        ),
        titleMedium: TextStyle(
          color: AppColors.mediumTitle,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        labelSmall: TextStyle(
          color: AppColors.smallLabel,
        ),
        labelMedium: TextStyle(
          color: AppColors.mediumLabel,
        ),
        labelLarge: TextStyle(
          color: AppColors.largeLabel,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
