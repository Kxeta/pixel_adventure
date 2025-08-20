import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final playerHitbox = player.hitbox;
  final playerX = player.position.x + playerHitbox.offsetX;
  final playerY = player.position.y + playerHitbox.offsetY;
  final playerWidth = playerHitbox.width;
  final playerHeight = playerHitbox.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final dynamicPlayerX = player.scale.x < 0
      ? playerX - (playerHitbox.offsetX * 2) - playerWidth
      : playerX;
  final dynamicPlayerY = block.isPlatform
      ? playerY + (playerHitbox.offsetY) + playerHeight
      : playerY;

  // Check for collision
  return (dynamicPlayerX < blockX + blockWidth &&
      dynamicPlayerX + playerWidth > blockX &&
      dynamicPlayerY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
}
