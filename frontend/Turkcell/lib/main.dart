import 'package:flutter/material.dart';
import 'screens/user_selection_page.dart';

void main() {
  runApp(const TVPlusApp());
}

class TVPlusApp extends StatelessWidget {
  const TVPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turkcell TV+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserSelectionPage(),
    );
  }
}