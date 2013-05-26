library mario;

import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'engine/engine.dart';

part 'player.dart';

Engine engine;

void main() {
  engine = new Engine(graphicsTarget: Engine.GRAPHICS_TARGET_HTML_5_CANVAS);
  var screen = engine.createScreen(480, 320);
  engine.resourceManager.addResource(new Resource(name: "metatiles16x16",  type: "image", path: "data/img/map/metatiles16x16.png"));
  engine.resourceManager.addResource(new Resource(name: "sma4_tiles",      type: "image", path: "data/img/map/sma4_tiles.png"));
  engine.resourceManager.addResource(new Resource(name: "mario33",         type: "image", path: "data/img/sprite/mario33.png"));
  engine.resourceManager.addResource(new Resource(name: "super_mario",     type: "image", path: "data/img/sprite/super_mario.png"));
  engine.resourceManager.addResource(new Resource(name: "world_1_level_1", type: "map",   path: "data/map/world_1_level_1.tmx"));
  engine.cameraLoc = new Vec2<int>(0,200);
  
  engine.inputManager.bind(KeyCode.LEFT, "left");
  engine.inputManager.bind(KeyCode.RIGHT, "right");
  engine.inputManager.bind(KeyCode.UP, "up");
  engine.inputManager.bind(KeyCode.DOWN, "down");
  engine.inputManager.bind(KeyCode.Z, "jump");
  engine.inputManager.bind(KeyCode.X, "run");
  engine.inputManager.bind(KeyCode.X, "pickUp");
  
  Player mario = new Player();
  mario.currentAnimation = marioWalkAnimation;
  mario.location = new Vec2<double>(0.0, 300.0);
  engine.objectPool.add(mario);
  
  engine.loadResources().then((_) {
    engine.level = engine.resourceManager.lookupResource("world_1_level_1").data;
    new Timer.periodic(new Duration(milliseconds:20), (_) {
      engine.update(0.02);
      engine.cameraLoc = new Vec2<int>(
        max((mario.location.x + 9.0 - 0.5 * screen.width).toInt(), 0),
        (mario.location.y + 16.0 - 0.5 * screen.height).toInt()
      );
      engine.draw(screen);
    });
  });
}
