part of mario;

Animation marioRunAnimation = new Animation(
  name: "mario_run",
  imageResName: "mario33",
  startLoc: new Vec2<int>(289, 46),
  len: new Vec2<int>(22,30),
  step: new Vec2<int>(23,0),
  frameSequence: [0,1,2,1],
  frameRate: 10
);

Animation marioWalkAnimation = new Animation(
  name: "mario_walk",
  imageResName: "mario33",
  startLoc: new Vec2<int>(196, 46),
  len: new Vec2<int>(18,29),
  step: new Vec2<int>(18,0),
  frameSequence: [0,1,2,1],
  frameRate: 10
);

Animation marioIdleAnimation = new Animation(
  name: "mario_idle",
  imageResName: "mario33",
  startLoc: new Vec2<int>(196, 46),
  len: new Vec2<int>(18,29),
  step: new Vec2<int>(0,0),
  frameSequence: [0],
  frameRate: 10
);

Animation marioDuckAnimation = new Animation(
  name: "mario_duck",
  imageResName: "mario33",
  startLoc: new Vec2<int>(378, 46),
  len: new Vec2<int>(18,29),
  step: new Vec2<int>(0,0),
  frameSequence: [0],
  frameRate: 10
);

Animation marioLookUpAnimation = new Animation(
  name: "mario_look_up",
  imageResName: "mario33",
  startLoc: new Vec2<int>(658, 46),
  len: new Vec2<int>(18,29),
  step: new Vec2<int>(0,0),
  frameSequence: [0],
  frameRate: 10
);

class Player extends GameObject {
  Player() {
    this.currentAnimationFrame = 0;
    this.maxVelocity = new Vec2<double>(300.0,300.0);
    this.acceleration = new Vec2<double>(0.0,0.0);
  }
  
  void update(Engine engine) {
    super.update(engine);
    double ax = 0.0;
    double ay = 500.0;
    bool ducking = false;
    bool lookingUp = false;
    if (engine.inputManager.isPressed("left")) {
      ax = -200.0;
    } else if (engine.inputManager.isPressed("right")) {
      ax = 200.0;
    } else if (engine.inputManager.isPressed("down")) {
      if (currentAnimation.name != marioDuckAnimation.name) {
        currentAnimation = marioDuckAnimation;
        currentAnimationFrame = 0;
      }
      ducking = true;
    } else if (engine.inputManager.isPressed("up")) {
      if (currentAnimation.name != marioLookUpAnimation.name) {
        currentAnimation = marioLookUpAnimation;
        currentAnimationFrame = 0;
      }
      lookingUp = true;
      // do look up animation
    } else {
    }
    if (-0.01 < velocity.y && velocity.y < 0.01 && engine.inputManager.isPressed("jump")) {
      velocity = new Vec2<double>(velocity.x, -500.0);
    }
    acceleration = new Vec2<double>(ax, ay);
    if (velocity.x < -0.001 || velocity.x > 0.001) {
      flipX = velocity.x < 0.0;
    }
    double speedX = velocity.x < 0.0 ? -velocity.x : velocity.x;
    if (!ducking && !lookingUp) {
      if (ax == 0.0 && speedX < 10.0) {
        velocity = new Vec2<double>(0.0,velocity.y);
        currentAnimation = marioIdleAnimation;
        currentAnimationFrame = 0;
      } else if (speedX > 200.0 && currentAnimation.name != marioRunAnimation.name) {
        currentAnimation = marioRunAnimation;
        currentAnimationFrame = 0;
      } else if (currentAnimation.name != marioWalkAnimation.name) {
        currentAnimation = marioWalkAnimation;
        currentAnimationFrame = 0;
      }
    }
  }
}
