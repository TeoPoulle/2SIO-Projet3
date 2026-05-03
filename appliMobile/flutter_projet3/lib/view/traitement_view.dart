import 'package:flutter/material.dart';
// Import des widgets customs
import 'package:flutter_projet3/view/customWidget/app_bar.dart';
import 'package:flutter_projet3/view/customWidget/bottom_nav_bar.dart';

class TraitementApp extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const TraitementApp({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Mes Traitements", isDark: isDark),
      bottomNavigationBar: buildBottomNavBar(context),
      body: Center(
        child: Column(
          children: [
            Row(children: []),
          ],
        ),
      ),
    );
  }
}
