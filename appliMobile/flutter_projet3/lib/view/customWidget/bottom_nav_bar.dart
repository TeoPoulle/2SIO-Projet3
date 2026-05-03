import 'package:flutter/material.dart';

BottomNavigationBar buildBottomNavBar(BuildContext context){
  return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(IconData(0xe3d9, fontFamily: 'MaterialIcons')), label: 'Mes traitements'),
          BottomNavigationBarItem(icon: Icon(IconData(0xe6dc, fontFamily: 'MaterialIcons')),label: 'Mes passages'),
          BottomNavigationBarItem(icon: Icon(IconData(0xe1cf, fontFamily: 'MaterialIcons')),label: 'Mes repas',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              // Naviguer vers la page des traitements
              Navigator.pushNamed(context, '/traitement');
              break;
            case 1:
              // Naviguer vers la page des passages
              Navigator.pushNamed(context, '/passage');
              break;
            case 2:
              // Naviguer vers la page des repas
              Navigator.pushNamed(context, '/repas');
              break;
          }
        },
      );
}