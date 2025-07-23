import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback onClearHistory;
  final VoidCallback onClearMemory;
  final VoidCallback onToggleTheme;

  SettingsPage({
    required this.onClearHistory,
    required this.onClearMemory,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: Text('Toggle Dark Mode'),
              trailing: Icon(Icons.brightness_6),
              onTap: onToggleTheme,
            ),
            Divider(),
            ListTile(
              title: Text('Clear History'),
              trailing: Icon(Icons.delete),
              onTap: () {
                onClearHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('History Cleared')));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Clear Memory'),
              trailing: Icon(Icons.memory),
              onTap: () {
                onClearMemory();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Memory Cleared')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
