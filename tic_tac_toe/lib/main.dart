import 'package:flutter/material.dart';
import 'package:tic_tac_toe/homepage.dart';

import 'sudoku.dart';
import 'tic_tac_toe.dart';
import 'memory_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainMenu(),
        '/tictactoe': (context) => Tic_Tac_Toe(),
        '/sudoku': (context) => Sudoku(),
        '/chess': (context) => Placeholder(),
        '/memory': (context) => MemoryHomePage(),
      },
    );
  }
}
