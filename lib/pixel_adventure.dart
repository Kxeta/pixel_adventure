import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() {
    return const Color(0xFF211F30); // Set a purple background color
  }

  @override
  Future<void> onLoad() async {
    world = Level();
    camera = CameraComponent();
    camera.viewport = FixedResolutionViewport(resolution: Vector2(640, 360));
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.world = world;
    addAll([camera, world]);
    super.onLoad();
  }
}
