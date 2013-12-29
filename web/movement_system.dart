part of mario;

class MovementSystem extends EntitySystem {
  ComponentMapper<Position> positionMapper;
  ComponentMapper<Velocity> velocityMapper;
  ComponentMapper<Acceleration> accelerationMapper;
  ComponentMapper<MaxVelocity> maxVelocityMapper;
  ComponentMapper<Damping> dampingMapper;
  
  MovementSystem(): super(Aspect.getAspectForAllOf([Position,Velocity]));
  
  @override
  void initialize() {
    positionMapper = new ComponentMapper<Position>(Position, world);
    velocityMapper = new ComponentMapper<Velocity>(Velocity, world);
    accelerationMapper = new ComponentMapper<Acceleration>(Acceleration, world);
    maxVelocityMapper = new ComponentMapper<MaxVelocity>(MaxVelocity, world);
    dampingMapper = new ComponentMapper<Damping>(Damping, world);
  }
  
  @override
  void processEntities(ReadOnlyBag<Entity> entities) {
    entities.forEach((Entity entity) {
      Position pos = positionMapper.get(entity);
      Velocity vel = velocityMapper.get(entity);
      if (accelerationMapper.has(entity)) {
        Acceleration acc = accelerationMapper.get(entity);
        vel.x += acc.x * world.delta;
        vel.y += acc.y * world.delta;
      }
      if (dampingMapper.has(entity)) {
        Damping damping = dampingMapper.get(entity);
        vel.x -= vel.x * damping.amount * world.delta;
        vel.y -= vel.y * damping.amount * world.delta;
      }
      if (maxVelocityMapper.has(entity)) {
        MaxVelocity maxVel = maxVelocityMapper.get(entity);
        if (vel.x.abs() > maxVel.x) {
          if (vel.x < 0.0) {
            vel.x = -maxVel.x;
          } else {
            vel.x = maxVel.x;
          }
        }
        if (vel.y.abs() > maxVel.y) {
          if (vel.y < 0.0) {
            vel.y = -maxVel.y;
          } else {
            vel.y = maxVel.y;
          }
        }
      }
      pos.lastX = pos.x;
      pos.lastY = pos.y;
      pos.x += vel.x * world.delta;
      pos.y += vel.y * world.delta;
    });
  }
  
  @override
  bool checkProcessing() {
    return true;
  }
}
