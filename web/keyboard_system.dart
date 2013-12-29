part of mario;

class KeyboardSystem extends EntitySystem {
  ComponentMapper<Position> positionMapper;
  ComponentMapper<Velocity> velocityMapper;
  ComponentMapper<Acceleration> accelerationMapper;
  ComponentMapper<AnimationFrame> animationFrameMapper;
  
  KeyboardSystem(): super(Aspect.getAspectForAllOf([Position,Velocity,Acceleration,AnimationFrame,KeyboardControl]));
  
  @override
  void initialize() {
    positionMapper = new ComponentMapper<Position>(Position, world);
    velocityMapper = new ComponentMapper<Velocity>(Velocity, world);
    accelerationMapper = new ComponentMapper<Acceleration>(Acceleration, world);
    animationFrameMapper = new ComponentMapper<AnimationFrame>(AnimationFrame, world);
  }
  
  @override
  void processEntities(ReadOnlyBag<Entity> entities) {
    entities.forEach((Entity entity) {
      Position pos = positionMapper.get(entity);
      Velocity vel = velocityMapper.get(entity);
      Acceleration acc = accelerationMapper.get(entity);
      AnimationFrame ani = animationFrameMapper.get(entity);
      double ax = 0.0;
      double ay = 500.0;
      bool ducking = false;
      bool lookingUp = false;
      if (engine.inputManager.isPressed("left")) {
        ax = -200.0;
      } else if (engine.inputManager.isPressed("right")) {
        ax = 200.0;
      } else if (engine.inputManager.isPressed("down")) {
        if (ani.animation.name != marioDuckAnimation.name) {
          ani.animation = marioDuckAnimation;
          ani.currentFrame = 0;
        }
        ducking = true;
      } else if (engine.inputManager.isPressed("up")) {
        if (ani.animation.name != marioLookUpAnimation.name) {
          ani.animation = marioLookUpAnimation;
          ani.currentFrame = 0;
        }
        lookingUp = true;
        // do look up animation
      } else {
      }
      if (-0.01 < vel.y && vel.y < 0.01 && engine.inputManager.isPressed("jump")) {
        vel.y = -500.0;
      }
      acc.x = ax;
      acc.y = ay;
      if (vel.x < -0.001 || vel.x > 0.001) {
        ani.flipX = vel.x < 0.0;
      }
      double speedX = vel.x.abs().toDouble();
      if (!ducking && !lookingUp) {
        if (ax == 0.0 && speedX < 10.0) {
          vel.x = 0.0;
          ani.animation = marioIdleAnimation;
          ani.currentFrame = 0;
        } else if (speedX > 200.0 && ani.animation.name != marioRunAnimation.name) {
          ani.animation = marioRunAnimation;
          ani.currentFrame = 0;
        } else if (ani.animation.name != marioWalkAnimation.name) {
          ani.animation = marioWalkAnimation;
          ani.currentFrame = 0;
        }
      }
    });
  }
  
  @override
  bool checkProcessing() {
    return true;
  }
}
