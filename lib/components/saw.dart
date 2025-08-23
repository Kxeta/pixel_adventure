import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/components/object_hitbox.dart';

class Saw extends SpriteAnimationComponent with CollisionCallbacks {
  final bool isVertical;
  final double offNeg;
  final double offPos;
  Saw({
    this.isVertical = false,
    this.offNeg = 0,
    this.offPos = 0,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);
  late FlameGame<World>? game;
  final double stepTime = 0.03;
  static const moveSpeed = 50.0; // Speed of the saw movement
  static const tileSize = 16.0; // Size of the tile in pixels
  double direction =
      1.0; // Direction of movement, 1 for down/right, -1 for up/left
  double rangeNeg = 0; // Negative range for movement
  double rangePos = 0; // Positive range for movement

  ObjectHitbox hitbox = ObjectHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 32,
    height: 32,
  );

  @override
  Future<void> onLoad() async {
    // debugMode = true;
    priority = -1;

    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    game = findGame();
    animation = SpriteAnimation.fromFrameData(
      game!.images.fromCache('Traps/Saw/On (38x38).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: stepTime,
        textureSize: Vector2.all(38),
      ),
    );

    add(
      CircleHitbox(
        radius: 16,
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      position.y += direction * moveSpeed * dt;
      if (position.y <= rangeNeg || position.y >= rangePos) {
        direction *= -1; // Reverse direction when reaching the limits
      }
    } else {
      position.x += direction * moveSpeed * dt;
      if (position.x <= rangeNeg || position.x >= rangePos) {
        direction *= -1; // Reverse direction when reaching the limits
      }
    }
    super.update(dt);
  }

  // void collidingWithPlayer() {
  //   if (!_isCollected) {
  //     animation = SpriteAnimation.fromFrameData(
  //       game!.images.fromCache('Items/Fruits/Collected.png'),
  //       SpriteAnimationData.sequenced(
  //         amount: 6,
  //         stepTime: stepTime,
  //         textureSize: Vector2.all(32),
  //         loop: false,
  //       ),
  //     );
  //     _isCollected = true;
  //     removeOnFinish = true;
  //   }
  // }
}
