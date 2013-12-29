part of engine;

abstract class PhysicsObject {
  Vec2<double> _lastLocation = new Vec2<double>(0.0,0.0);
  Vec2<double> _lastVelocity = new Vec2<double>(0.0,0.0);
  Vec2<double> location = new Vec2<double>(0.0,0.0);
  Vec2<double> velocity = new Vec2<double>(0.0,0.0);
  Vec2<double> acceleration = new Vec2<double>(0.0,0.0);
  Vec2<double> maxVelocity = new Vec2<double>(0.0,0.0);
  double damping = 0.40;
  Rect<int> collisionRect = new Rect<int>(new Vec2<int>(0,0), new Vec2<int>(16,29));
  
  Vec2<double> get lastLocation {
    return _lastLocation;
  }
  
  void updatePhysics(Engine engine) {
    double dt = engine.dt;
    _lastLocation = location;
    _lastVelocity = velocity;
    Vec2<double> newLocation = location + velocity * dt;
    Vec2<double> newVelocity = (velocity + acceleration * dt);
    newVelocity = newVelocity * (1.0 - damping * dt);
    location = newLocation;
    velocity = newVelocity;
    double vx, vy;
    if (velocity.x < 0) {
      if (velocity.x < -maxVelocity.x) {
        vx = -maxVelocity.x;
      } else {
        vx = velocity.x;
      }
    } else {
      if (velocity.x > maxVelocity.x) {
        vx = maxVelocity.x;
      } else {
        vx = velocity.x;
      }
    }
    if (velocity.y < 0) {
      if (velocity.y < -maxVelocity.y) {
        vy = -maxVelocity.y;
      } else {
        vy = velocity.y;
      }
    } else {
      if (velocity.y > maxVelocity.y) {
        vy = maxVelocity.y;
      } else {
        vy = velocity.y;
      }
    }
    velocity = new Vec2<double>(vx, vy);
  }
  
  Rect<int> get collisionArea {
    return new Rect<int>(collisionRect.pos + location.toVec2Int(), collisionRect.len);
  }
  
  void doCollisions(Engine engine) {
    TileLayer collisionLayer = engine.level.getLayerByName("collision");
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
            handleFloorCollision(tileMinY);
          }
        }
        if (row < engine.level.rows-1 && collisionLayer.getGlobalTileId(row+1, col) != 1351) {
          if (_lastLocation.y + collisionRect.minY + 1 > tileMaxY && collisionArea.maxX > tileMinX && collisionArea.minX < tileMaxX) {
            handleRoofCollision(tileMaxY);
          }
        }
        if (col < engine.level.cols-1 && collisionLayer.getGlobalTileId(row, col+1) != 1351) {
          if (_lastLocation.x + collisionRect.minX + 1 > tileMaxX && collisionArea.maxY > tileMinY && collisionArea.minY < tileMaxY) {
            handleLeftWallCollision(tileMaxX);
          }
        }
        if (col > 0 && collisionLayer.getGlobalTileId(row, col-1) != 1351) {
          if (_lastLocation.x + collisionRect.maxX - 1 < tileMinX && collisionArea.maxY > tileMinY && collisionArea.minY < tileMaxY) {
            handleRightWallCollision((col * engine.level.tileWidth).toDouble());
          }
        }
      }
    }
  }
  
  void handleFloorCollision(double floorY) {
    location = new Vec2<double>(location.x, floorY - collisionRect.maxY);
    double vy = velocity.y > 0.0 ? 0.0 : velocity.y;
    velocity = new Vec2<double>(velocity.x, vy);
  }
  
  void handleRoofCollision(double roofY) {
    location = new Vec2<double>(location.x, roofY - collisionRect.minY);
    double vy = velocity.y < 0.0 ? 0.0 : velocity.y;
    velocity = new Vec2<double>(velocity.x, vy);
  }
  
  void handleLeftWallCollision(double wallX) {
    location = new Vec2<double>(wallX - collisionRect.minX, location.y);
    double vx = velocity.x < 0.0 ? 0.0 : velocity.x;
    velocity = new Vec2<double>(vx, velocity.y);
  }
  
  void handleRightWallCollision(double wallX) {
    location = new Vec2<double>(wallX - collisionRect.maxX, location.y);
    double vx = velocity.x > 0.0 ? 0.0 : velocity.x;
    velocity = new Vec2<double>(vx, velocity.y);
  }
}
