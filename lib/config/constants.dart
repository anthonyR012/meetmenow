import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


const primaryColor = Colors.purple;
const secondaryColor = Color(0xFF7D1C4A);
const thirdColor = Color(0xFFD17D98);
const fourthColor = Color(0xFFF4CCE9);

final ligthTheme = ThemeData(
    canvasColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
      color: secondaryColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: secondaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: thirdColor,
    ),
    tabBarTheme: const TabBarTheme(
        labelColor: Colors.white, unselectedLabelColor: Colors.grey),
    cardTheme: const CardTheme(
        elevation: 4,
        color: Color.fromARGB(255, 255, 255, 255),
        surfaceTintColor: Colors.transparent),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: thirdColor,
            width: 1,
            style: BorderStyle.solid,
          )),
      enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: thirdColor,
            width: 1,
            style: BorderStyle.solid,
          )),
      focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: fourthColor,
            width: 1,
            style: BorderStyle.solid,
          )),
      contentPadding: const EdgeInsets.all(5),
      labelStyle: TextStyle(
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      filled: true,
    ),
    iconTheme: const IconThemeData(color: primaryColor));

  enum Repository { firebase  }
  enum MuteOption { all, myself }


const String keyEnv = "ENV";
const String keyAppId = "APP_ID_AGORA";
const String keyChannelName = "CHANNEL_NAME";
const String keyTokenAgora = "TOKEN_AGORA";