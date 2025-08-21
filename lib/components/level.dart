import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/player.dart';

class Level extends World {
  // Required params
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});
  late FlameGame<World>? game;
  late TiledComponent level;

  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    game = findGame();

    _scrollingBackground();
    _spawnObjects();
    _addCollisionBlocks();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');
    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor') ?? 'Blue';
      final background = ParallaxComponent(
        priority: -1,
        parallax: Parallax([
          ParallaxLayer(
            ParallaxImage(
              game!.images.fromCache('Background/$backgroundColor.png'),
              repeat: ImageRepeat.repeat,
              fill: LayerFill.none,
            ),
          ),
        ], baseVelocity: Vector2(0, -50)),
      );
      add(background);
    }
  }

  void _spawnObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            // Player spawn point, handled below
            player.position = spawnPoint.position;
            add(player);
            break;
          case 'Fruit':
            final fruitObject = Fruit(
              position: spawnPoint.position,
              size: Vector2.all(32),
              fruit: spawnPoint.name,
            );
            add(fruitObject);
          default:
            // Handle other spawn points if necessary
            break;
        }
      }
    }
  }

  void _addCollisionBlocks() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
      player.collisionBlocks = collisionBlocks;
    }
  }
}
