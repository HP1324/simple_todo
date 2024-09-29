import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const darkTeal = Color(0xff008080);
  static const tealShade50 = Color(0xFFE0F2F1);
  static const tealShade100 = Color(0xFFB2DFDB); // #B2DFDB
  static const tealShade200 = Color(0xFF80CBC4); // #80CBC4
  static const tealShade300 = Color(0xFF4DB6AC); // #4DB6AC
  static const tealShade400 = Color(0xFF26A69A); // #26A69A
  static const tealShade500 = Color(0xFF009688); // #009688
  static const tealShade600 = Color(0xFF00897B); // #00897B
  static const tealShade700 = Color(0xFF00796B); // #00796B
  static const tealShade800 = Color(0xFF00695C); // #00695C
  static const tealShade900 = Color(0xFF004D40); // #004D40
  static const cardTeal = Color(0xffC8E6E6);

  static const popupItemStyle = TextStyle(color: darkTeal, fontWeight: FontWeight.bold);

  static ThemeData lightMode = ThemeData(
    fontFamily: GoogleFonts.gabarito().fontFamily,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: tealShade50),
      titleTextStyle: TextStyle(
        fontSize: 25,
        color: tealShade50
      ),
      actionsIconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Color(0xff00796B),
    ),
    scaffoldBackgroundColor: tealShade50,
    navigationBarTheme: NavigationBarThemeData(
      elevation: 5,
      backgroundColor: darkTeal,
      indicatorColor: tealShade100,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: darkTeal);
        }
        return const IconThemeData(color: Color(0xffffffff));
      }),
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: tealShade500,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: tealShade50,
      titleTextStyle: TextStyle(color: darkTeal,fontWeight: FontWeight.bold,fontSize: 21),
    ),
    cardTheme: const CardTheme(
      color: cardTeal,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      iconColor: darkTeal,
      color: tealShade50,
      position: PopupMenuPosition.under,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: const WidgetStatePropertyAll(tealShade100),
      fillColor: WidgetStateProperty.resolveWith(
          (states){
            if(states.contains(WidgetState.selected)){
              return darkTeal;
            } return null;
          }
      ),
    ),
    listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(fontWeight: FontWeight.w500,fontSize : 15,color: Color(0xff000000))
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(tealShade50),
      )
    )
  );

  static ThemeData darkMode = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff49a0b6),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xff414141),
    listTileTheme: const ListTileThemeData(
        titleTextStyle: TextStyle(color: Colors.white)
    ),
  );
}
