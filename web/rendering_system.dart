part of mario;

class RenderingSystem extends EntitySystem {
  ComponentMapper<Position> positionMapper;
  ComponentMapper<AnimationFrame> animationFrameMapper;
  ComponentMapper<CollisionRect> collisionRectMapper;
  
  RenderingSystem(): super(Aspect.getAspectForAllOf([Position,AnimationFrame]));
  
  @override
  void initialize() {
    positionMapper = new ComponentMapper<Position>(Position, world);
    animationFrameMapper = new ComponentMapper<AnimationFrame>(AnimationFrame, world);
    collisionRectMapper = new ComponentMapper<CollisionRect>(CollisionRect, world);
  }
  
  @override
  void processEntities(ReadOnlyBag<Entity> entities) {
    entities.forEach((Entity entity) {
      Position pos = positionMapper.get(entity);
      AnimationFrame ani = animationFrameMapper.get(entity);
      ani.animation.render(engine.resourceManager, screen, new Engine.Vec2<int>(pos.x.toInt() - engine.cameraLoc.x, pos.y.toInt() - engine.cameraLoc.y), ani.currentFrame, ani.flipX);
      if (collisionRectMapper.has(entity)) {
        CollisionRect collisionRect = collisionRectMapper.get(entity);
        screen.drawRect(
          (collisionRect.minX + pos.x - engine.cameraLoc.x).toInt(),
          (collisionRect.minY + pos.y - engine.cameraLoc.y).toInt(),
          collisionRect.lenX.toInt(),
          collisionRect.lenY.toInt(),
          "red"
        );
      }
    });
  }
  
  @override
  bool checkProcessing() {
    return true;
  }
}
