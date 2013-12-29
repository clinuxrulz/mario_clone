part of mario;

Engine.Animation goombaWalkAnimation = new Engine.Animation(
  name: "goomba_walk",
  imageResName: "mario33",
  startLoc: new Engine.Vec2<int>(46,723),
  len: new Engine.Vec2<int>(16,16),
  step: new Engine.Vec2<int>(18,0),
  frameSequence: [0,1],
  frameRate: 5
);

Engine.Animation goombaSquishedAnimation = new Engine.Animation(
  name: "goomba_squish",
  imageResName: "mario33",
  startLoc: new Engine.Vec2<int>(82, 723),
  len: new Engine.Vec2<int>(16,16),
  step: new Engine.Vec2<int>(0,0),
  frameSequence: [0],
  frameRate: 5
);

const int _dir_left = 0;
const int _dir_right = 1;

class Goomba extends Engine.GameObject {
  int _dir = _dir_left;
  bool _dead = false;
  
  bool get alive { return !_dead; }
  bool get dead { return _dead; }
  
  Goomba() {
    this.currentAnimationFrame = 0;
    this.maxVelocity = new Engine.Vec2<double>(300.0,300.0);
    this.acceleration = new Engine.Vec2<double>(0.0,500.0);
    this.collisionRect = new Engine.Rect<int>(new Engine.Vec2<int>(0,0), new Engine.Vec2<int>(16,16));
  }
  
  void update(Engine.Engine engine) {
    super.update(engine);
    if (!_dead) {
      if (_dir == _dir_left) {
        this.velocity = new Engine.Vec2<double>(-10.0,velocity.y);
      } else {
        this.velocity = new Engine.Vec2<double>(10.0,velocity.y);
      }
    }
  }
  
  void squishDie(Engine.Engine engine) {
    currentAnimation = goombaSquishedAnimation;
    currentAnimationFrame = 0;
    velocity = new Engine.Vec2<double>(0.0, 0.0);
    _dead = true;
    new Timer(new Duration(seconds:3), () {
      engine.deadObjectPool.add(this);
    });
  }
}
