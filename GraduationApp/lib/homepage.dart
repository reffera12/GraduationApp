import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GameButton(
                text: 'Tic-Tac-Toe',
                onPressed: () {
                  Navigator.pushNamed(context, '/tictactoe');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GameButton(
                text: 'Sudoku',
                onPressed: () {
                  Navigator.pushNamed(context, '/sudoku');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GameButton(
                text: 'Memory Game',
                onPressed: () {
                  Navigator.pushNamed(context, '/memory');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GameButton(
                  text: 'Chess',
                  onPressed: () {
                    Navigator.pushNamed(context, '/chess');
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GameButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        primary: Colors.blue,
      ),
    );
  }
}
