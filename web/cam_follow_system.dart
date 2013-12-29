part of mario;

class CamFollowSystem extends EntitySystem {
  ComponentMapper<Position> positionMapper;
  
  CamFollowSystem(): super(Aspect.getAspectForAllOf([Position,CamFollow]));
  
  @override
  void initialize() {
    positionMapper = new ComponentMapper<Position>(Position, world);
  }
  
  @override
  void processEntities(ReadOnlyBag<Entity> entities) {
    entities.forEach((Entity entity) {
      Position pos = positionMapper.get(entity);
      engine.cameraLoc = new Engine.Vec2<int>(
        max((pos.x + 9.0 - 0.5 * screen.width).toInt(), 0),
        (pos.y + 16.0 - 0.5 * screen.height).toInt()
      );
    });
  }
  
  @override
  bool checkProcessing() {
    return true;
  }
}
