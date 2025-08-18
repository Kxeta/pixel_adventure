import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/actors/player_utils.dart';

class Level extends World {
  // Required params
  final String levelName;

  Level({required this.levelName});

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    final SpawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnPoint in SpawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          // Player spawn point, handled below
          final player = Player(characterType: playerTypes['ninja']!);
          player.position = spawnPoint.position;
          add(player);
          break;
        default:
          // Handle other spawn points if necessary
          break;
      }
    }

    return super.onLoad();
  }
}
