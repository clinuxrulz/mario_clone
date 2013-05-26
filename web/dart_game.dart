library mario;

import 'dart:html' as html;
import 'dart:async';
import 'dart:math';
import 'engine/engine.dart';

part 'player.dart';
part 'goomba.dart';

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
  
  engine.inputManager.bind(html.KeyCode.LEFT, "left");
  engine.inputManager.bind(html.KeyCode.RIGHT, "right");
  engine.inputManager.bind(html.KeyCode.UP, "up");
  engine.inputManager.bind(html.KeyCode.DOWN, "down");
  engine.inputManager.bind(html.KeyCode.Z, "jump");
  engine.inputManager.bind(html.KeyCode.X, "run");
  engine.inputManager.bind(html.KeyCode.X, "pickUp");
  
  Player mario = new Player();
  mario.currentAnimation = marioWalkAnimation;
  mario.location = new Vec2<double>(0.0, 300.0);
  engine.objectPool.add(mario);
  
  {
    Goomba goomba = new Goomba();
    goomba.currentAnimation = goombaWalkAnimation;
    goomba.location = new Vec2<double>(300.0, 300.0);
    engine.objectPool.add(goomba);
  }
  {
    Goomba goomba = new Goomba();
    goomba.currentAnimation = goombaWalkAnimation;
    goomba.location = new Vec2<double>(250.0, 300.0);
    engine.objectPool.add(goomba);
  }
  {
    Goomba goomba = new Goomba();
    goomba.currentAnimation = goombaWalkAnimation;
    goomba.location = new Vec2<double>(450.0, 300.0);
    engine.objectPool.add(goomba);
  }
  
  engine.collisionResolution = (GameObject o1, GameObject o2) {
    Player player = null;
    Goomba goomba = null;
    if (o1 is Goomba) {
      goomba = o1;
    } else if (o1 is Player) {
      player = o1;
    }
    if (o2 is Goomba) {
      goomba = o2;
    } else if (o2 is Player) {
      player = o2;
    }
    if (player != null && goomba != null && goomba.alive) {
      if (player.lastLocation.y + player.collisionRect.maxY < goomba.location.y + goomba.collisionRect.minY) {
        player.velocity = new Vec2<double>(player.velocity.x, -player.velocity.y);
        goomba.squishDie(engine);
      }
    }
  };
  
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
