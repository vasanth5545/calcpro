import 'package:flutter/material.dart';
import 'ui/pages/calculator_page.dart';
import 'utils/theme.dart';

void main() {
  runApp(CalcPro());
}

class CalcPro extends StatefulWidget {
  @override
  State<CalcPro> createState() => _CalcProState();
}

class _CalcProState extends State<CalcPro> {
  bool _isDark = false;

  void toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalcPro',
      theme: _isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(onToggleTheme: toggleTheme),
    );
  }
}
