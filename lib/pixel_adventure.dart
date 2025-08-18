import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/actors/player_utils.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() {
    return const Color(0xFF211F30); // Set a purple background color
  }

  Player player = Player(characterType: playerTypes['ninja']!);
  late JoystickComponent joystick;
  bool isJoystickActive = true;

  @override
  Future<void> onLoad() async {
    await images.loadAllImages(); // Load all images used in the game
    world = Level(levelName: 'Level-01', player: player);
    camera = CameraComponent();
    camera.priority = 1;
    camera.viewport = FixedResolutionViewport(resolution: Vector2(640, 360));
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.world = world;
    addAll([camera, world]);
    if (isJoystickActive) {
      addJoystick();
    }
    super.onLoad();
  }

  @override
  void update(double dt) {
    if (isJoystickActive) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
        size: Vector2.all(32),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
        size: Vector2.all(64),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      priority: 2,
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.currentPlayerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.currentPlayerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.idle:
        player.currentPlayerDirection = PlayerDirection.none;
        break;
      default:
        player.currentPlayerDirection = PlayerDirection.none;
    }
  }
}
