part of mario;

class TileCollisionSystem extends EntitySystem {
  ComponentMapper<Position> positionMapper;
  ComponentMapper<Velocity> velocityMapper;
  ComponentMapper<CollisionRect> collisionRectMapper;
  
  TileCollisionSystem(): super(Aspect.getAspectForAllOf([Position,Velocity]));
  
  @override
  void initialize() {
    positionMapper = new ComponentMapper<Position>(Position, world);
    velocityMapper = new ComponentMapper<Velocity>(Velocity, world);
    collisionRectMapper = new ComponentMapper<CollisionRect>(CollisionRect, world);
  }
  
  @override
  void processEntities(ReadOnlyBag<Entity> entities) {
    entities.forEach((Entity entity) {
      Position pos = positionMapper.get(entity);
      CollisionRect rect = collisionRectMapper.get(entity);
      Engine.Vec2<int> _lastLocation = new Engine.Vec2<int>(pos.lastX.toInt(), pos.lastY.toInt());
      Engine.TileLayer collisionLayer = engine.level.getLayerByName("collision");
      Engine.Rect<int> collisionRect = new Engine.Rect<int>(
        new Engine.Vec2<int>(rect.x.toInt(), rect.y.toInt()),
        new Engine.Vec2<int>(rect.lenX.toInt(), rect.lenY.toInt())
      );
      Engine.Rect<int> collisionArea = new Engine.Rect<int>(
        new Engine.Vec2<int>((rect.x + pos.x).toInt(), (rect.y + pos.y).toInt()),
        new Engine.Vec2<int>(rect.lenX.toInt(), rect.lenY.toInt())
      );
      int firstRow = (collisionArea.minY / engine.level.tileHeight).floor();
      int firstCol = (collisionArea.minX / engine.level.tileWidth).floor();
      int lastRow = (collisionArea.maxY / engine.level.tileHeight).floor();
      int lastCol = (collisionArea.maxX / engine.level.tileWidth).floor();
      for (int row = firstRow; row <= lastRow; ++row) {
        for (int col = firstCol; col <= lastCol; ++col) {
          if (row < 0 || col < 0 || row >= engine.level.rows || col >= engine.level.cols) {
            continue;
          }
          int tileGid = collisionLayer.getGlobalTileId(row, col);
          if (tileGid != 1351) {
            continue;
          }
          double tileMinX = (col * engine.level.tileWidth).toDouble();
          double tileMinY = (row * engine.level.tileHeight).toDouble();
          double tileMaxX = tileMinX + engine.level.tileWidth-1;
          double tileMaxY = tileMinY + engine.level.tileHeight-1;
          if (row > 0 && collisionLayer.getGlobalTileId(row-1, col) != 1351) {
            if (_lastLocation.y + collisionRect.maxY - 1 < tileMinY && collisionArea.maxX > tileMinX && collisionArea.minX < tileMaxX) {
              handleFloorCollision(entity, tileMinY);
            }
          }
          if (row < engine.level.rows-1 && collisionLayer.getGlobalTileId(row+1, col) != 1351) {
            if (_lastLocation.y + collisionRect.minY + 1 > tileMaxY && collisionArea.maxX > tileMinX && collisionArea.minX < tileMaxX) {
              handleRoofCollision(entity, tileMaxY);
            }
          }
          if (col < engine.level.cols-1 && collisionLayer.getGlobalTileId(row, col+1) != 1351) {
            if (_lastLocation.x + collisionRect.minX + 1 > tileMaxX && collisionArea.maxY > tileMinY && collisionArea.minY < tileMaxY) {
              handleLeftWallCollision(entity, tileMaxX);
            }
          }
          if (col > 0 && collisionLayer.getGlobalTileId(row, col-1) != 1351) {
            if (_lastLocation.x + collisionRect.maxX - 1 < tileMinX && collisionArea.maxY > tileMinY && collisionArea.minY < tileMaxY) {
              handleRightWallCollision(entity, (col * engine.level.tileWidth).toDouble());
            }
          }
        }
      }
    });
  }
  
  @override
  bool checkProcessing() {
    return true;
  }
  
  void handleFloorCollision(Entity entity, double floorY) {
    Position pos = positionMapper.get(entity);
    Velocity vel = velocityMapper.get(entity);
    CollisionRect rect = collisionRectMapper.get(entity);
    pos.y = floorY - rect.maxY;
    vel.y = vel.y > 0.0 ? 0.0 : vel.y;
  }
  
  void handleRoofCollision(Entity entity, double roofY) {
    Position pos = positionMapper.get(entity);
    Velocity vel = velocityMapper.get(entity);
    CollisionRect rect = collisionRectMapper.get(entity);
    pos.y = roofY - rect.minY;
    vel.y = vel.y < 0.0 ? 0.0 : vel.y;
  }
  
  void handleLeftWallCollision(Entity entity, double wallX) {
    Position pos = positionMapper.get(entity);
    Velocity vel = velocityMapper.get(entity);
    CollisionRect rect = collisionRectMapper.get(entity);
    pos.x = wallX - rect.minX;
    vel.x = vel.x < 0.0 ? 0.0 : vel.x;
  }
  
  void handleRightWallCollision(Entity entity, double wallX) {
    Position pos = positionMapper.get(entity);
    Velocity vel = velocityMapper.get(entity);
    CollisionRect rect = collisionRectMapper.get(entity);
    pos.x = wallX - rect.maxX;
    vel.x = vel.x > 0.0 ? 0.0 : vel.x;
  }
}
