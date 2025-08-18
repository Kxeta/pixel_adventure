import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/actors/player_utils.dart';

class Player extends SpriteAnimationGroupComponent {
  Player({required this.characterType});
  // Required params
  String characterType;

  // Local variables
  late final FlameGame<World>? game;

  // Player animations
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation doubleJumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation wallJumpingAnimation;

  // Player movement
  PlayerDirection currentPlayerDirection = PlayerDirection.none;
  double speed = 100.0; // Speed of the player
  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    game = findGame();
    _loadAllAnimations();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  void _loadAllAnimations() {
    doubleJumpingAnimation = _getPlayerAnimation(PlayerState.doubleJumping, 6);
    fallingAnimation = _getPlayerAnimation(PlayerState.falling, 1);
    hitAnimation = _getPlayerAnimation(PlayerState.hit, 7);
    idleAnimation = _getPlayerAnimation(PlayerState.idle, 11);
    jumpingAnimation = _getPlayerAnimation(PlayerState.jumping, 1);
    runningAnimation = _getPlayerAnimation(PlayerState.running, 12);
    wallJumpingAnimation = _getPlayerAnimation(PlayerState.wallJumping, 5);
    // Add other animations like running, jumping, etc.
    animations = {
      PlayerState.doubleJumping: doubleJumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.idle: idleAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.wallJumping: wallJumpingAnimation,
    };

    // Set the initial animation to be idle
    current = PlayerState.idle;
  }

  SpriteAnimation _getPlayerAnimation(PlayerState playerState, int amount) {
    String state = playerAnimationsStates[playerState] ?? 'Idle';
    return SpriteAnimation.fromFrameData(
      game!.images.fromCache(
        'Main Characters/$characterType/$state (32x32).png',
      ),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
        loop: true,
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double deltaX = 0.0;
    switch (currentPlayerDirection) {
      case PlayerDirection.left:
        deltaX = -speed * dt;
        break;
      case PlayerDirection.right:
        deltaX = speed * dt;
        break;
      case PlayerDirection.none:
        deltaX = 0.0;
        break;
    }
  }
}
