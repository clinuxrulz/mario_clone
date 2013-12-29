library mario;

import 'dart:html' as html;
import 'dart:async';
import 'dart:math';
import 'package:dartemis/dartemis.dart';
import 'engine/engine.dart' as Engine;

part 'player.dart';
part 'goomba.dart';
part 'position.dart';
part 'velocity.dart';
part 'max_velocity.dart';
part 'acceleration.dart';
part 'damping.dart';
part 'movement_system.dart';
part 'animation_frame.dart';
part 'animation_system.dart';
part 'rendering_system.dart';
part 'tile_collision_system.dart';
part 'collision_rect.dart';
part 'keyboard_control.dart';
part 'keyboard_system.dart';
part 'cam_follow.dart';
part 'cam_follow_system.dart';
part 'character_type.dart';
part 'character_type_component.dart';
part 'squishee_component.dart';
part 'squisher_component.dart';
part 'squish_system.dart';

World world = new World();

Engine.Engine engine;

var screen;

void main() {
  engine = new Engine.Engine(graphicsTarget: Engine.Engine.GRAPHICS_TARGET_HTML_5_CANVAS);
  screen = engine.createScreen(480, 320);
  engine.resourceManager.addResource(new Engine.Resource(name: "metatiles16x16",  type: "image", path: "data/img/map/metatiles16x16.png"));
  engine.resourceManager.addResource(new Engine.Resource(name: "sma4_tiles",      type: "image", path: "data/img/map/sma4_tiles.png"));
  engine.resourceManager.addResource(new Engine.Resource(name: "mario33",         type: "image", path: "data/img/sprite/mario33.png"));
  engine.resourceManager.addResource(new Engine.Resource(name: "super_mario",     type: "image", path: "data/img/sprite/super_mario.png"));
  engine.resourceManager.addResource(new Engine.Resource(name: "world_1_level_1", type: "map",   path: "data/map/world_1_level_1.tmx"));
  engine.cameraLoc = new Engine.Vec2<int>(0,200);
  
  engine.inputManager.bind(html.KeyCode.LEFT, "left");
  engine.inputManager.bind(html.KeyCode.RIGHT, "right");
  engine.inputManager.bind(html.KeyCode.UP, "up");
  engine.inputManager.bind(html.KeyCode.DOWN, "down");
  engine.inputManager.bind(html.KeyCode.Z, "jump");
  engine.inputManager.bind(html.KeyCode.X, "run");
  engine.inputManager.bind(html.KeyCode.X, "pickUp");
  
  world.addSystem(new KeyboardSystem(), passive: false);
  world.addSystem(new MovementSystem(), passive: false);
  world.addSystem(new AnimationSystem(), passive: false);
  world.addSystem(new TileCollisionSystem(), passive: false);
  world.addSystem(new SquishSystem(), passive: false);
  world.addSystem(new CamFollowSystem(), passive: false);
  world.addSystem(new RenderingSystem(), passive: true);
  
  world.initialize();
  for (int i = 0; i < 3; ++i) {
    num vx = cos((i+1) * 20 * 3.14 / 180.0) * 200;
    num vy = -sin((i+1) * 20 * 3.14 / 180.0) * 200;
    Entity player = world.createEntity();
    player.addComponent(new Damping(0.4));
    player.addComponent(new Position(0.0, 300));
    player.addComponent(new Velocity(vx, vy));
    player.addComponent(new MaxVelocity(300, 300));
    player.addComponent(new Acceleration(0, 500));
    player.addComponent(new AnimationFrame(animation: marioIdleAnimation));
    player.addComponent(new CollisionRect(x:0, y:0, lenX:16, lenY:29));
    player.addComponent(new KeyboardControl());
    player.addComponent(new CharacterTypeComponent(CharacterType.MARIO));
    if (i == 0) {
      player.addComponent(new CamFollow());
    }
    player.addComponent(new SquisherComponent());
    player.addToWorld();
  }
  
  { // Goomba
    for (int i = 0; i < 20; ++i) {
      world.createEntity()
        ..addComponent(new Position(100 + 50 * i, 300))
        ..addComponent(new Velocity(0,0))
        ..addComponent(new Acceleration(0,500))
        ..addComponent(new AnimationFrame(animation: goombaWalkAnimation))
        ..addComponent(new CollisionRect(x:0, y:0, lenX:16, lenY:16))
        ..addComponent(new CharacterTypeComponent(CharacterType.GOOMBA))
        ..addComponent(new SquisheeComponent(squishAnimation: goombaSquishedAnimation, timeUntilDisappear: 2))
        ..addToWorld();
    }
  }
  
  engine.loadResources().then((_) {
    engine.level = engine.resourceManager.lookupResource("world_1_level_1").data;
    new Timer.periodic(new Duration(milliseconds:20), (_) {
      engine.update(0.02);
      /*
      engine.cameraLoc = new Engine.Vec2<int>(
        max((mario.location.x + 9.0 - 0.5 * screen.width).toInt(), 0),
        (mario.location.y + 16.0 - 0.5 * screen.height).toInt()
      );*/
      world.delta = 0.02;
      world.process();
      engine.draw(screen);
      world.getSystem(RenderingSystem).process();
    });
  });
}
