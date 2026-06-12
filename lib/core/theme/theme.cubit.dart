import 'package:corporate_filter/core/theme/app.theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final AppThemeMode themeMode;
  final ThemeData themeData;

  ThemeState({required this.themeMode, required this.themeData});
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(
          themeMode: AppThemeMode.original,
          themeData: AppTheme.originalTheme,
        ));

  void toggleTheme() {
    switch (state.themeMode) {
      case AppThemeMode.original:
        emit(ThemeState(themeMode: AppThemeMode.light, themeData: AppTheme.lightTheme));
        break;
      case AppThemeMode.light:
        emit(ThemeState(themeMode: AppThemeMode.dark, themeData: AppTheme.darkTheme));
        break;
      case AppThemeMode.dark:
        emit(ThemeState(themeMode: AppThemeMode.original, themeData: AppTheme.originalTheme));
        break;
    }
  }
}