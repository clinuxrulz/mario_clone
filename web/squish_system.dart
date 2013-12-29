part of mario;

class SquishSystem extends EntitySystem {
  ComponentMapper<Position> positionMapper;
  ComponentMapper<CollisionRect> collisionRectMapper;
  ComponentMapper<SquisherComponent> squisherComponentMapper;
  ComponentMapper<SquisheeComponent> squisheeComponentMapper;
  ComponentMapper<AnimationFrame> animationFrameMapper;
  ComponentMapper<Velocity> velocityMapper;
  
  SquishSystem(): super(Aspect.getAspectForAllOf([Position,CollisionRect,AnimationFrame]).oneOf([SquisheeComponent, SquisherComponent]));
  
  @override
  void initialize() {
    positionMapper = new ComponentMapper<Position>(Position, world);
    collisionRectMapper = new ComponentMapper<CollisionRect>(CollisionRect, world);
    squisherComponentMapper = new ComponentMapper<SquisherComponent>(SquisherComponent, world);
    squisheeComponentMapper = new ComponentMapper<SquisheeComponent>(SquisheeComponent, world);
    animationFrameMapper = new ComponentMapper<AnimationFrame>(AnimationFrame, world);
    velocityMapper = new ComponentMapper<Velocity>(Velocity, world);
  }
  
  @override
  void processEntities(ReadOnlyBag<Entity> entities) {
    entities.forEach((Entity squisher) {
      if (!squisherComponentMapper.has(squisher)) { return; }
      entities.forEach((Entity squishee) {
        if (!squisheeComponentMapper.has(squishee)) { return; }
        if (squisher.id == squishee.id) { return; }
        SquisheeComponent squisheeComponent = squisheeComponentMapper.get(squishee);
        if (!squisheeComponent.alive) { return; }
        Position squisherPos = positionMapper.get(squisher);
        Position squisheePos = positionMapper.get(squishee);
        CollisionRect squisherRect = collisionRectMapper.get(squisher);
        CollisionRect squisheeRect = collisionRectMapper.get(squishee);
        num squisherMinX = squisherRect.minX + squisherPos.x;
        num squisherMaxX = squisherRect.maxX + squisherPos.x;
        num squisherMinY = squisherRect.minY + squisherPos.y;
        num squisherMaxY = squisherRect.maxY + squisherPos.y;
        num squisheeMinX = squisheeRect.minX + squisheePos.x;
        num squisheeMaxX = squisheeRect.maxX + squisheePos.x;
        num squisheeMinY = squisheeRect.minY + squisheePos.y;
        num squisheeMaxY = squisheeRect.maxY + squisheePos.y;
        if (squisherMinX < squisheeMaxX &&
            squisherMaxX > squisheeMinX &&
            squisherMinY < squisheeMaxY &&
            squisherMaxY > squisheeMinY) {
          if (squisherPos.lastY + squisherRect.maxY < squisheePos.y + squisheeRect.minY) {
            squisheeComponent.alive = false;
            AnimationFrame ani = animationFrameMapper.get(squishee);
            ani.animation = squisheeComponent.squishAnimation;
            ani.currentFrame = 0;
            if (velocityMapper.has(squisher)) {
              Velocity vel = velocityMapper.get(squisher);
              vel.y = -vel.y.abs();
            }
          }
        }
      });
    });
    entities.forEach((Entity squishee) {
      if (!squisheeComponentMapper.has(squishee)) { return; }
      SquisheeComponent squisheeComponent = squisheeComponentMapper.get(squishee);
      if (!squisheeComponent.alive) {
        squisheeComponent.timeUntilDisappear -= world.delta;
        if (squisheeComponent.timeUntilDisappear <= 0) {
          world.deleteEntity(squishee);
        }
      }
    });
  }
  
  @override
  bool checkProcessing() {
    return true;
  }
}
