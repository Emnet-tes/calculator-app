import 'package:flutter/material.dart';

import 'pages/my_home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSwitched = false; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: isSwitched ? ThemeMode.dark : ThemeMode.light, // Dynamic theme
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(), // Add a dark theme
      home: MyHomePage(
        isSwitched: isSwitched,
        onSwitchChanged: (value) {
          setState(() {
            isSwitched = value;
          });
        },
      ),
    );
  }
}
