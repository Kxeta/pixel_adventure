import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/components/object_hitbox.dart';

class Fruit extends SpriteAnimationComponent with CollisionCallbacks {
  final String fruit;
  Fruit({
    required Vector2 position,
    required Vector2 size,
    this.fruit = 'Apple',
  }) : super(position: position, size: size);

  late FlameGame<World>? game;
  bool _isCollected = false;
  final double stepTime = 0.05;

  ObjectHitbox hitbox = ObjectHitbox(
    offsetX: 9,
    offsetY: 8,
    width: 14,
    height: 14,
  );

  @override
  Future<void> onLoad() async {
    game = findGame();
    animation = SpriteAnimation.fromFrameData(
      game!.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    add(
      RectangleHitbox(
        size: Vector2(hitbox.width, hitbox.height),
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }

  void collidingWithPlayer() {
    if (!_isCollected) {
      animation = SpriteAnimation.fromFrameData(
        game!.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      _isCollected = true;
      removeOnFinish = true;
    }
  }
}
