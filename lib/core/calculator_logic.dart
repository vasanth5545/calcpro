import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  String evaluateExpression(String input) {
    try {
      input = input.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }
}
