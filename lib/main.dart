import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  Game game = PixelAdventure();

  GameWidget gameWidget = GameWidget(
    game: kDebugMode ? PixelAdventure() : game,
  );

  runApp(gameWidget);
}
