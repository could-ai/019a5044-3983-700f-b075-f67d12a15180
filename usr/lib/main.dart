import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'main_menu.dart';
import 'game_scene.dart';
import 'game_over.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setPortraitUpOnly();
  await Flame.device.fullScreen();
  runApp(const BladeDashApp());
}

class BladeDashApp extends StatelessWidget {
  const BladeDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blade Dash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenu(),
        '/game': (context) => const GameScene(),
        '/game_over': (context) => const GameOver(),
      },
    );
  }
}