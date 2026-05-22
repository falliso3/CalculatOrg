import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/appTheme.dart';
import 'providers/themeProvider.dart';
import 'providers/modeProvider.dart';
import 'providers/historyProvider.dart';
import 'screens/homeScreen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ModeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const CalculatOrg(),
    ),
  );
}

class CalculatOrg extends StatelessWidget {
  const CalculatOrg({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'CalculatOrg',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      home: const HomeScreen(),
    );
  }
}
