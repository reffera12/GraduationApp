import 'package:flutter/material.dart';
import 'package:tic_tac_toe/homepage.dart';

import 'chess/chess.dart';
import 'sudoku/sudoku.dart';
import 'tic_tac_toe/tic_tac_toe.dart';
import 'memory_game/memory_home.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainMenu(),
        '/tictactoe': (context) => Tic_Tac_Toe(),
        '/sudoku': (context) => Sudoku(),
        '/chess': (context) => Chess(),
        '/memory': (context) => MemoryHomePage(),
      },
    );
  }
}
