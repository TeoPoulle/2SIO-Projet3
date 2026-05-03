import 'package:flutter/material.dart';
// Import des widgets customs
import 'package:flutter_projet3/view/customWidget/app_bar.dart';

class ParameterApp extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const ParameterApp({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Paramètres", isDark: isDark),

      // Contenu de la page paramètres
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Changer le thème de l'application
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Choix du thème : ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Padding(padding: const EdgeInsets.only(left: 4)),
                const SizedBox(height: 8),
                ToggleButtons(
                  isSelected: [!isDark, isDark],
                  onPressed: (index) {
                    onThemeChanged(index == 1);
                  },
                  borderRadius: BorderRadius.circular(12),
                  constraints: const BoxConstraints(
                    minHeight: 48,
                    minWidth: 120,
                  ),
                  children: const [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(IconData(0xe37a, fontFamily: 'MaterialIcons')),
                        Text(' Clair'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(IconData(0xe1b0, fontFamily: 'MaterialIcons')),
                        Text(' Sombre'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
