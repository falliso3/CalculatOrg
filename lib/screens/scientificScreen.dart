import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/historyEntry.dart';
import '../providers/historyProvider.dart';
import '../providers/themeProvider.dart';
import '../utils/mathParser.dart';
import '../widgets/calcButton.dart';
import '../widgets/calcDisplay.dart';

class ScientificScreen extends StatefulWidget {
  const ScientificScreen({super.key});

  @override
  State<ScientificScreen> createState() => _ScientificScreenState();
}

class _ScientificScreenState extends State<ScientificScreen> {
  String _expr = '';
  String _displayTop = '';
  String _displayBottom = '0';
  bool _justEvaluated = false;
  bool _is2nd = false;

  //TODO: implement degree/radian conversion for trig functions
  bool _isDeg = false;

  void _onButton(String label) {
    setState(() {
      if (label == '2nd') {
        _is2nd = !_is2nd;
        return;
      }
      _is2nd = false;

      switch (label) {
        case 'AC':
          _expr = '';
          _displayTop = '';
          _displayBottom = '0';
          _justEvaluated = false;

        case '+/-':
          if (_displayBottom != '0' && _displayBottom != 'Error') {
            if (_expr.startsWith('-')) {
              _expr = _expr.substring(1);
            } else {
              _expr = '-$_expr';
            }
            _displayBottom = _expr;
          }

        case '⌫':
          if (_expr.isNotEmpty && !_justEvaluated) {
            _expr = _expr.substring(0, _expr.length - 1);
            _displayBottom = _expr.isEmpty ? '0' : _expr;
          }

        case '=':
          if (_expr.isNotEmpty) {
            final result = MathParser.evaluate(_expr, isDeg: _isDeg);
            context.read<HistoryProvider>().add(HistoryEntry(
              expression: _expr,
              result: result,
              timestamp: DateTime.now(),
            ));
            _displayTop = _expr;
            _displayBottom = result;
            _expr = result == 'Error' ? '' : result;
            _justEvaluated = true;
          }

        //Postfix: apply to whatever is already in the expression
        case 'x²':
          if (_expr.isNotEmpty) {
            _expr += '²';
            _displayBottom = _expr;
            _displayTop = '';
          }

        case '∛':
          if (_expr.isNotEmpty) {
            _expr += '^(1/3)';
            _displayBottom = _expr;
            _displayTop = '';
          }

        case 'n!':
          if (_expr.isNotEmpty) {
            _expr += '!';
            _displayBottom = _expr;
            _displayTop = '';
          }

        //General power - opens paren for exponent entry
        case 'xⁿ' || '^':
          if (_justEvaluated) { _justEvaluated = false; }
          _expr += '^(';
          _displayBottom = _expr;
          _displayTop = '';

        //Constants with implicit multiplication (e.g. 2π → 2×π)
        case 'π':
          final needMul = !_justEvaluated && _expr.isNotEmpty
              && RegExp(r'[\d)πℯ]$').hasMatch(_expr);
          if (_justEvaluated) {
            _expr = 'π';
            _justEvaluated = false;
          } else {
            _expr += needMul ? '×π' : 'π';
          }
          _displayBottom = _expr;
          _displayTop = '';

        case 'e':
          //Stored as ℯ to avoid ambiguity with scientific notation (e.g. 1.5e10)
          final needMul = !_justEvaluated && _expr.isNotEmpty
              && RegExp(r'[\d)πℯ]$').hasMatch(_expr);
          if (_justEvaluated) {
            _expr = 'ℯ';
            _justEvaluated = false;
          } else {
            _expr += needMul ? '×ℯ' : 'ℯ';
          }
          _displayBottom = _expr;
          _displayTop = '';

        case 'mod':
          if (_expr.isNotEmpty && !_justEvaluated) {
            _expr += ' mod ';
            _displayBottom = _expr;
          }

        //log base 10 - stored as log10( for preprocessing
        case 'log':
          if (_justEvaluated) { _justEvaluated = false; }
          _expr += 'log10(';
          _displayBottom = _expr;
          _displayTop = '';

        //Prefix functions that append label followed by open paren
        case 'sin' || 'cos' || 'tan' || '√'
            || 'sin⁻¹' || 'cos⁻¹' || 'tan⁻¹'
            || 'ln' || '|x|':
          if (_justEvaluated) { _justEvaluated = false; }
          _expr += '$label(';
          _displayBottom = _expr;
          _displayTop = '';

        case '(' || ')':
          if (_justEvaluated) { _justEvaluated = false; }
          _expr += label;
          _displayBottom = _expr;
          _displayTop = '';

        case '.':
          if (_justEvaluated) {
            _expr = '0.';
            _displayBottom = '0.';
            _displayTop = '';
            _justEvaluated = false;
          } else {
            final lastNum = RegExp(r'[0-9.]*$').stringMatch(_expr) ?? '';
            if (!lastNum.contains('.')) {
              _expr += _expr.isEmpty ? '0.' : '.';
              _displayBottom = _expr;
            }
          }

        default:
          final isNum = RegExp(r'^[0-9]$').hasMatch(label);
          if (_justEvaluated) {
            if (isNum) {
              _expr = label;
              _displayTop = '';
            } else {
              _displayTop = _displayBottom;
              _expr += label;
            }
            _justEvaluated = false;
          } else {
            _expr += label;
          }
          _displayBottom = _expr;
      }
    });
  }

  //Returns primary or secondary label depending on 2nd mode
  String _f(String primary, String secondary) => _is2nd ? secondary : primary;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Column(
      children: [
        CalcDisplay(
          displayTop: _displayTop,
          displayBottom: _displayBottom,
          isDark: isDark,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _buildGrid(isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(bool isDark) {
    return Column(
      children: [
        //Row 1: 2nd (highlights when active), AC, backspace, divide
        _row([
          ('2nd',                    _is2nd ? CalcBtnType.equals : CalcBtnType.modifier, 1),
          ('AC',                     CalcBtnType.clear, 1),
          ('⌫',                     CalcBtnType.modifier, 1),
          ('÷',                      CalcBtnType.operator, 1),
        ], isDark),
        //Row 2: sin/sin⁻¹, cos/cos⁻¹, tan/tan⁻¹, multiply
        _row([
          (_f('sin', 'sin⁻¹'),       CalcBtnType.function, 1),
          (_f('cos', 'cos⁻¹'),       CalcBtnType.function, 1),
          (_f('tan', 'tan⁻¹'),       CalcBtnType.function, 1),
          ('×',                      CalcBtnType.operator, 1),
        ], isDark),
        //Row 3: log/ln, sqrt/cbrt, square/power, subtract
        _row([
          (_f('log', 'ln'),           CalcBtnType.function, 1),
          (_f('√',   '∛'),           CalcBtnType.function, 1),
          (_f('x²',  'xⁿ'),          CalcBtnType.function, 1),
          ('-',                       CalcBtnType.operator, 1),
        ], isDark),
        //Row 4: factorial/abs, pi/e, parentheses
        _row([
          (_f('n!', '|x|'),           CalcBtnType.function, 1),
          (_f('π',  'e'),             CalcBtnType.modifier, 1),
          ('(',                       CalcBtnType.modifier, 1),
          (')',                       CalcBtnType.modifier, 1),
        ], isDark),
        //Row 5: power, 7-9
        _row([
          ('^',   CalcBtnType.function, 1),
          ('7',   CalcBtnType.number,   1),
          ('8',   CalcBtnType.number,   1),
          ('9',   CalcBtnType.number,   1),
        ], isDark),
        //Row 6: mod, 4-6
        _row([
          ('mod', CalcBtnType.function, 1),
          ('4',   CalcBtnType.number,   1),
          ('5',   CalcBtnType.number,   1),
          ('6',   CalcBtnType.number,   1),
        ], isDark),
        //Row 7: +/-, 1-3
        _row([
          ('+/-', CalcBtnType.modifier, 1),
          ('1',   CalcBtnType.number,   1),
          ('2',   CalcBtnType.number,   1),
          ('3',   CalcBtnType.number,   1),
        ], isDark),
        //Row 8: 0 (double width), decimal, add, equals
        _row([
          ('0',   CalcBtnType.number,   2),
          ('.',   CalcBtnType.number,   1),
          ('+',   CalcBtnType.operator, 1),
          ('=',   CalcBtnType.equals,   1),
        ], isDark),
      ],
    );
  }

  Widget _row(List<(String, CalcBtnType, int)> buttons, bool isDark) {
    return Expanded(
      child: Row(
        children: buttons.map((b) => _btn(b.$1, b.$2, isDark, flex: b.$3)).toList(),
      ),
    );
  }

  Widget _btn(String label, CalcBtnType type, bool isDark, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: CalcButton(
          label: label,
          type: type,
          isDark: isDark,
          onPressed: () => _onButton(label),
        ),
      ),
    );
  }
}
