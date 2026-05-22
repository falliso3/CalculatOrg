import 'package:flutter/material.dart';
import '../theme/appTheme.dart';

class CalcDisplay extends StatelessWidget {
  final String displayTop;
  final String displayBottom;
  final bool isDark;

  const CalcDisplay({
    super.key,
    required this.displayTop,
    required this.displayBottom,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            displayTop,
            style: TextStyle(
              fontSize: 16,
              color: textColor.withValues(alpha: 0.55),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            displayBottom,
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w300,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
