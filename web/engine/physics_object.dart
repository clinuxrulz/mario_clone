part of engine;

abstract class PhysicsObject {
  Vec2<double> location = new Vec2<double>(0.0,0.0);
  Vec2<double> velocity = new Vec2<double>(0.0,0.0);
  Vec2<double> acceleration = new Vec2<double>(0.0,0.0);
  Vec2<double> maxVelocity = new Vec2<double>(0.0,0.0);
  double damping = 0.40;
  Rect<int> collisionRect = new Rect<int>(new Vec2<int>(0,0), new Vec2<int>(16,29));
  
  void updatePhysics(Engine engine) {
    double dt = engine.dt;
    Vec2<double> newLocation = location + velocity * dt;
    Vec2<double> newVelocity = (velocity + acceleration * dt) * pow(damping,dt);
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
        bool floorHandled;
        if (row > 0 && collisionLayer.getGlobalTileId(row-1, col) != 1351) {
          handleFloorCollision((row * engine.level.tileHeight).toDouble());
        }
        if (row < engine.level.rows-1 && collisionLayer.getGlobalTileId(row+1, col) != 1351) {
          handleRoofCollision((row * engine.level.tileHeight + engine.level.tileHeight-1).toDouble());
        }
        if (col > 0 && collisionLayer.getGlobalTileId(row, col-1) != 1351) {
          handleLeftWallCollision((col * engine.level.tileWidth + engine.level.tileWidth - 1).toDouble());
        }
        if (col < engine.level.cols-1 && collisionLayer.getGlobalTileId(row, col+1) != 1351) {
          handleRightWallCollision((col * engine.level.tileWidth).toDouble());
        }
      }
    }
  }
  
  void handleFloorCollision(double floorY) {
    if (collisionArea.minY < floorY && collisionArea.maxY > floorY) {
      location = new Vec2<double>(location.x, floorY - collisionRect.len.y - collisionRect.pos.y);
      velocity = new Vec2<double>(velocity.x, 0.0);
    }
  }
  
  void handleRoofCollision(double roofY) {
    if (collisionArea.minY < roofY && collisionArea.maxY > roofY) {
      location = new Vec2<double>(location.x, roofY - collisionRect.pos.y);
      velocity = new Vec2<double>(velocity.x, 20.0);
    }
  }
  
  void handleLeftWallCollision(double wallX) {
    if (collisionArea.minX < wallX && collisionArea.maxX > wallX) {
      location = new Vec2<double>(wallX - collisionRect.pos.x, location.y);
      velocity = new Vec2<double>(0.0, velocity.y);
    }
  }
  
  void handleRightWallCollision(double wallX) {
    if (collisionArea.minX < wallX && collisionArea.maxX > wallX) {
      location = new Vec2<double>(wallX - collisionRect.len.x - collisionRect.pos.x, location.y);
      velocity = new Vec2<double>(0.0, velocity.y);
    }
  }
}
