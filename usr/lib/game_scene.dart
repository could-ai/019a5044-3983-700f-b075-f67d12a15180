import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScene extends StatelessWidget {
  const GameScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: BladeDashGame()),
    );
  }
}

class BladeDashGame extends FlameGame with TapDetector, HorizontalDragDetector {
  late Player player;
  late TextComponent scoreText, coinText, comboText;
  late SpriteComponent pauseButton;
  late OverlayComponent pauseOverlay;

  int score = 0;
  int coinCount = 0;
  int comboCount = 0;
  double gameSpeed = 200;
  bool playerShieldActive = false;
  bool isSlashing = false;
  bool gameOver = false;
  bool gamePaused = false;
  int highScore = 0;
  double timeElapsed = 0;

  late AudioPlayer bgmPlayer, sfxPlayer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load high score
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;

    // Initialize audio
    bgmPlayer = AudioPlayer();
    sfxPlayer = AudioPlayer();
    // Placeholder: bgmPlayer.play('assets/audio/bgm.mp3');

    // Add background
    add(SpriteComponent()
      ..sprite = await loadSprite('background.png') // Placeholder
      ..size = size);

    // Add player
    player = Player()
      ..position = Vector2(size.x / 4, size.y / 2)
      ..size = Vector2(50, 50);
    add(player);

    // Add UI elements
    scoreText = TextComponent(text: 'Score: 0', position: Vector2(10, 10));
    add(scoreText);
    coinText = TextComponent(text: 'Coins: 0', position: Vector2(10, 40));
    add(coinText);
    comboText = TextComponent(text: 'Combo: 0', position: Vector2(10, 70));
    add(comboText);

    // Pause button
    pauseButton = SpriteComponent()
      ..sprite = await loadSprite('pause.png') // Placeholder
      ..position = Vector2(size.x - 60, 10)
      ..size = Vector2(50, 50)
      ..onTap = () => pauseGame();
    add(pauseButton);

    // Start spawning obstacles, coins, power-ups
    add(Spawner());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gamePaused || gameOver) return;

    timeElapsed += dt;
    gameSpeed = 200 + timeElapsed * 10; // Gradually increase speed

    // Move player forward
    player.position.x += gameSpeed * dt;
    if (player.position.x > size.x) player.position.x = 0; // Loop

    // Update UI
    scoreText.text = 'Score: $score';
    coinText.text = 'Coins: $coinCount';
    comboText.text = 'Combo: $comboCount';
  }

  @override
  void onTap() {
    if (gamePaused || gameOver) return;
    isSlashing = true;
    // sfxPlayer.play('assets/audio/slash.mp3'); // Placeholder
    // Animation for slash
    Future.delayed(const Duration(milliseconds: 200), () => isSlashing = false);
  }

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (gamePaused || gameOver) return;
    player.position.y += details.delta.dy;
    player.position.y = clamp(player.position.y, 0, size.y - player.size.y);
  }

  void pauseGame() {
    gamePaused = !gamePaused;
    if (gamePaused) {
      // Show pause overlay
      overlays.add('pause');
    } else {
      overlays.remove('pause');
    }
  }

  void endGame() {
    gameOver = true;
    // Save high score
    if (score > highScore) {
      highScore = score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', highScore);
    }
    // Navigate to game over
    // Since FlameGame doesn't have direct navigation, we'll handle in widget
  }

  @override
  void onRemove() {
    bgmPlayer.dispose();
    sfxPlayer.dispose();
    super.onRemove();
  }
}

class Player extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('player.png'); // Placeholder
  }
}

class Obstacle extends SpriteComponent with HasGameRef<BladeDashGame> {
  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('obstacle.png'); // Placeholder
    size = Vector2(50, 50);
  }

  @override
  void update(double dt) {
    position.x -= game.gameSpeed * dt;
    if (position.x < -size.x) removeFromParent();
  }
}

class Coin extends SpriteComponent with HasGameRef<BladeDashGame> {
  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('coin.png'); // Placeholder
    size = Vector2(30, 30);
  }

  @override
  void update(double dt) {
    position.x -= game.gameSpeed * dt;
    if (position.x < -size.x) removeFromParent();
  }
}

class PowerUp extends SpriteComponent with HasGameRef<BladeDashGame> {
  bool isShield;
  PowerUp(this.isShield);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(isShield ? 'shield.png' : 'speed.png'); // Placeholder
    size = Vector2(40, 40);
  }

  @override
  void update(double dt) {
    position.x -= game.gameSpeed * dt;
    if (position.x < -size.x) removeFromParent();
  }
}

class Spawner extends Component with HasGameRef<BladeDashGame> {
  double spawnTimer = 0;

  @override
  void update(double dt) {
    spawnTimer += dt;
    if (spawnTimer > 1) {
      spawnTimer = 0;
      final rand = Random();
      final type = rand.nextInt(3); // 0: obstacle, 1: coin, 2: powerup
      final y = rand.nextDouble() * game.size.y;
      if (type == 0) {
        game.add(Obstacle()..position = Vector2(game.size.x, y));
      } else if (type == 1) {
        game.add(Coin()..position = Vector2(game.size.x, y));
      } else {
        game.add(PowerUp(rand.nextBool())..position = Vector2(game.size.x, y));
      }
    }
  }
}

// Collision detection would need to be implemented with CollisionCallbacks
// For simplicity, assuming basic collision checks in update methods