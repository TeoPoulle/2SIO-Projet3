import 'package:flutter/material.dart';
// Import des widgets customs
import 'package:flutter_projet3/view/customWidget/app_bar.dart';

class CompteApp extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const CompteApp({
    super.key,
    required this.isDark,
    required this.onThemeChanged
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Compte", isDark: isDark),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}