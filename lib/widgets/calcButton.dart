import 'package:flutter/material.dart';
import '../theme/appTheme.dart';

enum CalcBtnType { number, operator, equals, function, clear, modifier }

class CalcButton extends StatelessWidget {
  final String label;
  final CalcBtnType type;
  final bool isDark;
  final VoidCallback onPressed;
  final double fontSize;

  const CalcButton({
    super.key,
    required this.label,
    required this.type,
    required this.isDark,
    required this.onPressed,
    this.fontSize = 18,
  });

  //Exposed so non-button widgets (e.g. dropdowns) can match button colors
  static (Color, Color) colorsFor(CalcBtnType type, bool isDark) {
    if (isDark) {
      return switch (type) {
        CalcBtnType.number => (
          const Color.fromARGB(255, 31, 41, 55),
          AppTheme.darkOnSurface,
        ),
        CalcBtnType.operator => (
          const Color.fromARGB(255, 45, 22, 53),
          AppTheme.darkPrimary,
        ),
        CalcBtnType.equals => (
          const Color.fromARGB(255, 236, 72, 153),
          AppTheme.darkOnPrimary,
        ),
        CalcBtnType.function => (
          const Color.fromARGB(255, 31, 29, 46),
          const Color.fromARGB(255, 216, 180, 254),
        ),
        CalcBtnType.clear => (
          const Color.fromARGB(255, 45, 21, 21),
          const Color.fromARGB(255, 255, 138, 128),
        ),
        CalcBtnType.modifier => (
          const Color.fromARGB(255, 31, 41, 55),
          const Color.fromARGB(255, 156, 163, 175),
        ),
      };
    }

    return switch (type) {
      CalcBtnType.number => (
        const Color.fromARGB(255, 236, 232, 253),
        const Color.fromARGB(255, 124, 58, 237),
      ),
      CalcBtnType.operator => (
        const Color.fromARGB(255, 216, 180, 254),
        const Color.fromARGB(255, 91, 33, 182),
      ),
      CalcBtnType.equals => (
        const Color.fromARGB(255, 159, 103, 250),
        Colors.white,
      ),
      CalcBtnType.function => (
        const Color.fromARGB(255, 237, 233, 254),
        const Color.fromARGB(255, 124, 58, 237),
      ),
      CalcBtnType.clear => (
        const Color.fromARGB(255, 255, 139, 129),
        Colors.white,
      ),
      CalcBtnType.modifier => (
        const Color.fromARGB(255, 235, 217, 255),
        const Color.fromARGB(255, 124, 58, 237),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = colorsFor(type, isDark);

    return SizedBox.expand(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 3,
          shadowColor: const Color.fromARGB(84, 139, 92, 246),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
