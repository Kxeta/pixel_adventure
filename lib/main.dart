import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  Game game = PixelAdventure();

  GameWidget gameWidget = GameWidget(
    game: kDebugMode ? PixelAdventure() : game,
    loadingBuilder: (context) =>
        const Center(child: CircularProgressIndicator()),
  );

  runApp(gameWidget);
}
