bool checkCollision(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final dynamicPlayerX = player.scale.x < 0 ? playerX - playerWidth : playerX;
  final dynamicPlayerY = player.scale.y < 0 ? playerY - playerHeight : playerY;

  // Check for collision
  return (dynamicPlayerX < blockX + blockWidth &&
      dynamicPlayerX + playerWidth > blockX &&
      dynamicPlayerY < blockY + blockHeight &&
      dynamicPlayerY + playerHeight > blockY);
}
