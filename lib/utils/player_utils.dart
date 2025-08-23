enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  doubleJumping,
  wallJumping,
  appearing,
  desappearing,
}

enum PlayerDirection { left, right, none }

Map<String, String> playerTypes = {
  'ninja': 'Ninja Frog',
  'masked': 'Mask Dude',
  'pink': 'Pink Man',
  'virtual': 'Virtual Guy',
};

Map<PlayerState, String> playerAnimationsStates = {
  PlayerState.running: 'Run',
  PlayerState.idle: 'Idle',
  PlayerState.jumping: 'Jump',
  PlayerState.falling: 'Fall',
  PlayerState.hit: 'Hit',
  PlayerState.doubleJumping: 'Double Jump',
  PlayerState.wallJumping: 'Wall Jump',
  PlayerState.appearing: 'Appearing',
  PlayerState.desappearing: 'Desappearing',
};
