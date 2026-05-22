import 'package:math_expressions/math_expressions.dart';

class MathParser {
  static String evaluate(String expression, {bool isDeg = false}) {
    try {
      final processed = _preprocess(expression, isDeg);
      final exp = ShuntingYardParser().parse(processed);
      final result =
          exp.evaluate(EvaluationType.REAL, ContextModel()) as double;

      if (result.isNaN || result.isInfinite) return 'Error';
      return _format(result);
    } catch (_) {
      return 'Error';
    }
  }

  static String _preprocess(String expr, bool isDeg) {
    String e = expr
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('²', '^(2)')
        .replaceAll('√(', 'sqrt(')
        //Inverse trig
        .replaceAll('sin⁻¹(', 'asin(')
        .replaceAll('cos⁻¹(', 'acos(')
        .replaceAll('tan⁻¹(', 'atan(')
        //Constants
        .replaceAll('ℯ', '2.71828182845905')
        .replaceAll('π', '3.14159265358979')
        //Natural log (math_expressions uses 'log' for natural log)
        .replaceAll('ln(', 'log(')
        //Modulo
        .replaceAll(' mod ', '%');

    //log10(expr) -> (log(expr)/log(10)) using a paren-matching stack
    e = _replaceLog10(e);

    //Factorial: 5! -> 120
    e = e.replaceAllMapped(RegExp(r'(\d+)!'), (m) {
      final n = int.tryParse(m[1]!) ?? -1;
      if (n < 0 || n > 170) return 'NaN';
      return _format(_factorial(n));
    });

    //Implicit multiplication: 2(x) -> 2*(x), (a)(b) -> (a)*(b)
    e = e.replaceAllMapped(RegExp(r'(\d)\('), (m) => '${m[1]}*(');
    e = e.replaceAllMapped(RegExp(r'\)(\d)'), (m) => ')*${m[1]}');
    e = e.replaceAll(')(', ')*(');

    //TODO: implement degree mode conversion for trig functions
    return e;
  }

  //Transforms log10(expr) -> (log(expr)/log(10)) with correct paren matching
  static String _replaceLog10(String e) {
    final result = StringBuffer();
    int i = 0;
    while (i < e.length) {
      if (i + 6 <= e.length && e.substring(i, i + 6) == 'log10(') {
        result.write('(log(');
        i += 6;
        int depth = 1;
        final arg = StringBuffer();
        while (i < e.length && depth > 0) {
          if (e[i] == '(') {
            depth++;
          } else if (e[i] == ')') {
            depth--;
          }
          if (depth > 0) {
            arg.write(e[i]);
          }
          i++;
        }
        result.write(arg);
        result.write(')/log(10))');
      } else {
        result.write(e[i]);
        i++;
      }
    }
    return result.toString();
  }

  static double _factorial(int n) {
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  static String _format(double value) {
    if (value == value.truncateToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }
    if (value.abs() >= 1e10 || (value != 0 && value.abs() < 1e-4)) {
      return value.toStringAsExponential(4);
    }
    return double.parse(value.toStringAsFixed(10)).toString();
  }
}
