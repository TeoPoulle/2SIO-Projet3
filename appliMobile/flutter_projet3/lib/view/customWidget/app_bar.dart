import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';

AppBar buildAppBar(
  BuildContext context, {
  required String title,
  required bool isDark,
}) {
  Future<void> handleClick(int item) async {
    switch (item) {
      case 0:
        // Mon compte - à implémenter plus tard
        break;
      case 1:
        Navigator.pushNamed(context, '/parameter');
        break;
      case 2:
        // Déconnexion
        try {
          await AuthService.instance.logout();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Déconnecté')));
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
          );
        }
        break;
    }
  }

  return AppBar(
    centerTitle: true,
    title: Text(title, style: const TextStyle(color: Colors.white)),
    backgroundColor: isDark ? null : const Color.fromARGB(255, 49, 65, 155),
    leading: IconButton(
      icon: const Icon(Icons.home, color: Colors.white),
      onPressed: () => Navigator.pushNamed(context, '/'),
    ),
    actions: [
      PopupMenuButton<int>(
        icon: const Icon(Icons.menu, color: Colors.white),
        onSelected: (item) => handleClick(item),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                Icon(IconData(0xe043, fontFamily: 'MaterialIcons')),
                Text(' Mon compte'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(IconData(0xe57f, fontFamily: 'MaterialIcons')),
                Text(' Paramètres'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Icon(IconData(0xe3b3, fontFamily: 'MaterialIcons')),
                Text(' Déconnexion'),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
