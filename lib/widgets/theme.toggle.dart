import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app.theme.dart';
import '../core/theme/theme.cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        Alignment switchAlignment;
        IconData icon;
        Color iconColor;

        switch (state.themeMode) {
          case AppThemeMode.light:
            switchAlignment = Alignment.centerLeft;
            icon = Icons.wb_sunny_rounded;
            iconColor = Colors.orange;
            break;
          case AppThemeMode.dark:
            switchAlignment = Alignment.centerRight;
            icon = Icons.nightlight_round;
            iconColor = Colors.amber;
            break;
          case AppThemeMode.original:
            switchAlignment = Alignment.center;
            icon = Icons.auto_awesome;
            iconColor = Colors.cyan;
            break;
        }

        return GestureDetector(
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 75,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).dimColorRef.withOpacity(0.5),
              border: Border.all(
                color: Theme.of(context).primaryColorRef,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: switchAlignment,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).backgroundColorRef,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: iconColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}