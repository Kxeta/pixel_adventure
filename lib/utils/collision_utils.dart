import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final dynamicPlayerX = player.scale.x < 0 ? playerX - playerWidth : playerX;
  final dynamicPlayerY = block.isPlatform ? playerY + playerHeight : playerY;

  // Check for collision
  return (dynamicPlayerX < blockX + blockWidth &&
      dynamicPlayerX + playerWidth > blockX &&
      dynamicPlayerY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
}
