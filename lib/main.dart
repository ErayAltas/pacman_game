import 'package:flutter/material.dart';
import 'package:pacman_game/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: false),
      home: const GameScreen(),
    );
  }
}
