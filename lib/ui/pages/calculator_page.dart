import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/calculator_logic.dart';
import '../widgets/calc_button.dart';
import '../widgets/display_area.dart';
import 'settings_page.dart';

class CalculatorPage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  CalculatorPage({required this.onToggleTheme});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '';
  final CalculatorLogic _logic = CalculatorLogic();
  List<String> _history = [];
  double _memory = 0;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadMemory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList('calc_history') ?? [];
    setState(() {});
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('calc_history', _history);
  }

  Future<void> _loadMemory() async {
    final prefs = await SharedPreferences.getInstance();
    _memory = prefs.getDouble('calc_memory') ?? 0;
  }

  Future<void> _saveMemory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('calc_memory', _memory);
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == '=') {
        _result = _logic.evaluateExpression(_input);
        if (_result != 'Error') {
          _history.insert(0, '$_input = $_result');
          if (_history.length > 10) _history.removeLast();
          _saveHistory();
        }
      } else if (value == 'C') {
        _input = '';
        _result = '';
      } else if (value == 'History') {
        _showHistoryBottomSheet();
      } else if (value == 'M+') {
        double val = double.tryParse(_result) ?? 0;
        _memory += val;
        _saveMemory();
        _showSnackBar('Added to Memory: $_memory');
      } else if (value == 'M-') {
        double val = double.tryParse(_result) ?? 0;
        _memory -= val;
        _saveMemory();
        _showSnackBar('Subtracted from Memory: $_memory');
      } else if (value == 'MR') {
        _input += _memory.toString();
      } else if (value == 'MC') {
        _memory = 0;
        _saveMemory();
        _showSnackBar('Memory Cleared');
      } else {
        _input += value;
      }
    });
  }

  void _showHistoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        height: 400,
        child: Column(
          children: [
            Text(
              'History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(
              child: _history.isEmpty
                  ? Center(child: Text('No history yet.'))
                  : ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(_history[i]),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _history.clear();
                });
                _saveHistory();
                Navigator.pop(context);
              },
              child: Text('Clear History'),
            )
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsPage(
          onClearHistory: () {
            setState(() {
              _history.clear();
            });
            _saveHistory();
          },
          onClearMemory: () {
            setState(() {
              _memory = 0;
            });
            _saveMemory();
          },
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CalcPro'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _goToSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          DisplayArea(input: _input, result: _result),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildButtonRow(['C', 'History', 'M+', 'M-']),
                _buildButtonRow(['7', '8', '9', '÷']),
                _buildButtonRow(['4', '5', '6', '×']),
                _buildButtonRow(['1', '2', '3', '-']),
                _buildButtonRow(['0', '.', '=', '+']),
                _buildButtonRow(['MR', 'MC']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((b) {
          bool isOperator = ['÷', '×', '-', '+', '=', 'M+', 'M-', 'MR', 'MC'].contains(b);
          return CalcButton(
            text: b,
            onTap: () => _onButtonPressed(b),
            color: isOperator ? Colors.blue[100] : Colors.grey[200],
            textColor: isOperator ? Colors.black : Colors.black,
          );
        }).toList(),
      ),
    );
  }
}
