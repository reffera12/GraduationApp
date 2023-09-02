import 'package:flutter/material.dart';
import 'package:tic_tac_toe/sudoku.dart';
import 'package:tic_tac_toe/tic_tac_toe.dart';

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
        '/': (context) => Game(),
        '/sudoku': (BuildContext context) => Sudoku(),
      },
    );
  }
}
