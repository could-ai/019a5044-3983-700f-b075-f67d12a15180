import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  const GameOver({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for final score and coins - would be passed via arguments
    int finalScore = 1000; // Placeholder
    int finalCoins = 50; // Placeholder

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.red,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Final Score: $finalScore',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              Text(
                'Coins Collected: $finalCoins',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/game'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text('RETRY', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Placeholder for Rewarded Ad and Extra Life
                  // Show ad, then retry
                  Navigator.pushReplacementNamed(context, '/game');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text('EXTRA LIFE', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text('MAIN MENU', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}