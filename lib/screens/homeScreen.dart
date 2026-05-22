import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/modeProvider.dart';
import '../providers/themeProvider.dart';
import '../theme/appTheme.dart';
import '../widgets/appDrawer.dart';
import 'standardScreen.dart';
import 'scientificScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modeProvider = context.watch<ModeProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final modeName = calcModeInfo[modeProvider.mode]!.$1;
    final gradient = isDark ? AppTheme.darkGradient : AppTheme.lightGradient;
    final fgColor = isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: fgColor,
        elevation: 0,
        title: Text(modeName),
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(child: _buildScreen(modeProvider.mode)),
      ),
    );
  }

  Widget _buildScreen(CalcMode mode) {
    return switch (mode) {
      CalcMode.standard    => const StandardScreen(),
      CalcMode.scientific  => const ScientificScreen(),
      //TODO: add remaining mode screens
      _ => const Center(child: Text('Coming soon')),
    };
  }
}
