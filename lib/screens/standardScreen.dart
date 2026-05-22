import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/historyEntry.dart';
import '../providers/historyProvider.dart';
import '../providers/themeProvider.dart';
import '../utils/mathParser.dart';
import '../widgets/calcButton.dart';
import '../widgets/calcDisplay.dart';

class StandardScreen extends StatefulWidget {
  const StandardScreen({super.key});

  @override
  State<StandardScreen> createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> {
  String _expr = '';
  String _displayTop = '';
  String _displayBottom = '0';
  bool _justEvaluated = false;

  //TODO: implement degree/radian conversion for trig functions
  bool _isDeg = false;

  void _onButton(String label) {
    setState(() {
      switch (label) {
        case 'AC':
          _expr = '';
          _displayTop = '';
          _displayBottom = '0';
          _justEvaluated = false;

        case 'DEG' || 'RAD':
          _isDeg = !_isDeg;

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

        case 'x²':
          if (_expr.isNotEmpty) {
            _expr += '²';
            _displayBottom = _expr;
            _displayTop = '';
          }

        case 'sin' || 'cos' || 'tan' || '√':
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
        Expanded(child: _buildButtons(isDark)),
      ],
    );
  }

  Widget _buildButtons(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _trigDropdownBtn(isDark),
                _btn('x²', CalcBtnType.function, isDark),
                _btn('AC', CalcBtnType.clear, isDark),
                _btn('⌫', CalcBtnType.modifier, isDark),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _btn('(', CalcBtnType.modifier, isDark),
                _btn(')', CalcBtnType.modifier, isDark),
                _btn('+/-', CalcBtnType.modifier, isDark),
                _btn('÷', CalcBtnType.operator, isDark),
              ],
            ),
          ),
          _buildRow([
            ('7', CalcBtnType.number),
            ('8', CalcBtnType.number),
            ('9', CalcBtnType.number),
            ('×', CalcBtnType.operator),
          ], isDark),
          _buildRow([
            ('4', CalcBtnType.number),
            ('5', CalcBtnType.number),
            ('6', CalcBtnType.number),
            ('-', CalcBtnType.operator),
          ], isDark),
          _buildRow([
            ('1', CalcBtnType.number),
            ('2', CalcBtnType.number),
            ('3', CalcBtnType.number),
            ('+', CalcBtnType.operator),
          ], isDark),
          _buildLastRow(isDark),
        ],
      ),
    );
  }

  Widget _trigDropdownBtn(bool isDark) {
    final (bg, fg) = CalcButton.colorsFor(CalcBtnType.function, isDark);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: PopupMenuButton<String>(
          onSelected: _onButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'sin', child: Text('sin')),
            const PopupMenuItem(value: 'cos', child: Text('cos')),
            const PopupMenuItem(value: 'tan', child: Text('tan')),
            const PopupMenuItem(value: '√', child: Text('√')),
            //TODO: add DEG/RAD toggle once degree mode is implemented
          ],
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x558B5CF6),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Trig',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: fg),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<(String, CalcBtnType)> buttons, bool isDark) {
    return Expanded(
      child: Row(
        children: buttons.map((b) => _btn(b.$1, b.$2, isDark)).toList(),
      ),
    );
  }

  Widget _buildLastRow(bool isDark) {
    return Expanded(
      child: Row(
        children: [
          _btn('0', CalcBtnType.number, isDark, flex: 2),
          _btn('.', CalcBtnType.number, isDark),
          _btn('=', CalcBtnType.equals, isDark),
        ],
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
