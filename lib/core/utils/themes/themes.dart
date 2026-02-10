import 'package:flutter/material.dart';
import 'create_material_color.dart';

class Themes {
  BuildContext baseContext;

  Themes({required this.baseContext});

  static final mainTheme = ThemeData(
    primarySwatch: createMaterialColor(Color(0xff04192D)),
    useMaterial3: false,

    cardTheme: CardThemeData(color: Colors.white, shadowColor: Colors.white, elevation: 2.0),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
