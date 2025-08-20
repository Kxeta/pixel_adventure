import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/utils/collision_utils.dart';
import 'package:pixel_adventure/utils/player_utils.dart';

class Player extends SpriteAnimationGroupComponent with KeyboardHandler {
  Player({String? characterType})
    : characterType = characterType ?? playerTypes['ninja']! {
    debugMode = true;
  }

  // Required params

  // Local variables
  late final FlameGame<World>? game;
  String characterType;

  // Player animations
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation doubleJumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation wallJumpingAnimation;

  double horizontalMove = 0.0; // Horizontal movement input
  double speed = 100.0; // Speed of the player
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];
  bool isOnGround = false; // Check if the player is on the ground
  bool hasJumped = false; // Check if the player has jumped
  final double _gravity = 9.81; // Gravity constant
  final double _jumpForce = 250.0; // Force applied for jumping
  final double _terminalVelocity = 300.0; // Maximum falling speed

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    game = findGame();
    _loadAllAnimations();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _addGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMove = 0.0; // Reset horizontal movement
    bool isLeftPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    bool isRightPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    horizontalMove += isLeftPressed ? -1.0 : 0.0;
    horizontalMove += isRightPressed ? 1.0 : 0.0;

    hasJumped =
        velocity.y == 0 &&
        (keysPressed.contains(LogicalKeyboardKey.space) ||
            keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp));

    return super.onKeyEvent(event, keysPressed);
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
    current = PlayerState.running;
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
    if (velocity.y == 0) {
      if (horizontalMove == 0) {
        current = PlayerState.idle;
      } else {
        current = PlayerState.running;
      }
    } else {
      if (velocity.y < _gravity) {
        current = PlayerState.jumping;
      } else if (velocity.y > _gravity) {
        current = PlayerState.falling;
      }
    }

    if (hasJumped) _playerJump(dt);

    if (horizontalMove < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (horizontalMove > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    velocity.x = horizontalMove * speed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce; // Apply jump force
    position.y += velocity.y * dt; // Move player up
    hasJumped = false; // Reset jump state
    isOnGround = false; // Player is no longer on the ground
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform && checkCollision(this, block)) {
        if (velocity.x > 0) {
          velocity.x = 0; // Stop horizontal movement
          position.x = block.x - width; // Move left
          break; // Exit loop after first collision
        } else if (velocity.x < 0) {
          velocity.x = 0; // Stop horizontal movement
          position.x = block.x + block.width + width; // Move right
          break; // Exit loop after first collision
        }
        break; // Exit loop after first collision
      }
    }
  }

  void _addGravity(double dt) {
    velocity.y += _gravity; // Gravity effect
    velocity.y = velocity.y.clamp(
      -_jumpForce,
      _terminalVelocity,
    ); // Limit falling speed
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0; // Stop falling
            position.y = block.y - height; // Move above the block
            isOnGround = true; // Player is on the ground
            break; // Exit loop after first collision
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            // Falling down
            position.y = block.y - height; // Move above the block
            velocity.y = 0; // Stop falling
            isOnGround = true; // Player is on the ground
            break; // Exit loop after first collision
          } else if (velocity.y < 0) {
            // Jumping up
            position.y = block.y + block.height; // Move below the block
            velocity.y = 0; // Stop upward movement
            isOnGround = false;
            break; // Exit loop after first collision
          }
          break; // Exit loop after first collision
        }
      }
    }
  }
}
