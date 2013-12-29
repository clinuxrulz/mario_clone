part of engine;

class GameObject extends PhysicsObject {
  Animation _currentAnimation;
  int currentAnimationFrame;
  double timeUntilNextFrame;
  bool flipX = false;
  
  GameObject({Animation currentAnimation}) {
    this._currentAnimation = currentAnimation;
    currentAnimationFrame = 0;
  }
  
  Animation get currentAnimation {
    return _currentAnimation;
  }
  
  set currentAnimation(Animation currentAnimation) {
    _currentAnimation = currentAnimation;
    timeUntilNextFrame = 1.0 / this._currentAnimation.frameRate;
  }
  
  void update(Engine engine) {
    updatePhysics(engine);
    doCollisions(engine);
    updateAnimation(engine);
  }
  
  void updateAnimation(Engine engine) {
    if (_currentAnimation == null) { return; }
    timeUntilNextFrame -= engine.dt;
    while (timeUntilNextFrame < 0.0) {
      timeUntilNextFrame += 1.0 / _currentAnimation.frameRate;
      ++currentAnimationFrame;
      if (currentAnimationFrame >= _currentAnimation.frameSequence.length) {
        currentAnimationFrame = 0;
      }
    }
  }
  
  void render(ResourceManager resourceManager, Surface surface, Vec2<int> pos) {
    return _currentAnimation.render(resourceManager, surface, pos, currentAnimationFrame, flipX);
  }
}
