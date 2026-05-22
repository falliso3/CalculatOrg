import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/modeProvider.dart';
import '../providers/themeProvider.dart';
import '../theme/appTheme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final modeProvider = context.watch<ModeProvider>();
    final gradient = themeProvider.isDark ? AppTheme.darkGradient : AppTheme.lightGradient;

    return Drawer(
      child: Column(
        children: [
          //Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            decoration: BoxDecoration(gradient: gradient),
            child: Text(
              'CalculatOrg',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDark
                    ? AppTheme.darkOnPrimary
                    : AppTheme.lightOnSurface,
              ),
            ),
          ),

          //Mode list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ...CalcMode.values.map((mode) {
                  final info = calcModeInfo[mode]!;
                  final isSelected = modeProvider.mode == mode;

                  return ListTile(
                    leading: Icon(
                      info.$2,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(
                      info.$1,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    selected: isSelected,
                    onTap: () {
                      modeProvider.setMode(mode);
                      Navigator.of(context).pop();
                    },
                  );

                }),

                const Divider(),

                //Theme toggle
                ListTile(
                  leading: Icon(
                    themeProvider.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  ),
                  title: Text(themeProvider.isDark ? 'Light Mode' : 'Dark Mode'),
                  onTap: () => themeProvider.toggleTheme(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
