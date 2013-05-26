library engine;

import 'dart:async';
import 'dart:html';
import 'dart:crypto';
import 'dart:math';
import 'package:xml/xml.dart';

part 'image.dart';
part 'surface.dart';
part 'image_loader.dart';
part 'tilemap.dart';
part 'tileset.dart';
part 'tile_layer.dart';
part 'tile.dart';
part 'tilemap_loader.dart';
part 'resource_manager.dart';
part 'vec2.dart';
part 'rect.dart';
part 'animation.dart';
part 'game_object.dart';
part 'physics_object.dart';
part 'input_manager.dart';

part 'impl/html_canvas_image.dart';
part 'impl/html_canvas_image_loader.dart';
part 'impl/html_canvas_screen.dart';
part 'impl/tmx_tileset.dart';
part 'impl/tmx_tilemap.dart';
part 'impl/tmx_tile_layer.dart';
part 'impl/tmx_tilemap_loader.dart';

typedef void CollisionResolution(GameObject o1, GameObject o2);

class Engine {
  static const int GRAPHICS_TARGET_HTML_5_CANVAS = 0;
  static const int GRAPHICS_TARGET_WEB_GL = 1;
  
  ResourceManager _resourceManager = new ResourceManager();
  InputManager _inputManager = new InputManager();
  Vec2<int> cameraLoc = new Vec2<int>(0,0);
  double dt = 0.01;
  List<GameObject> objectPool = new List<GameObject>();
  List<GameObject> deadObjectPool = new List<GameObject>();
  Tilemap level;
  CollisionResolution collisionResolution = (_1, _2) {};
  
  int _graphicsTarget;
  
  Engine({int graphicsTarget}) {
    _graphicsTarget = graphicsTarget;
  }
  
  ResourceManager get resourceManager {
    return _resourceManager;
  }
  
  InputManager get inputManager {
    return _inputManager;
  }
  
  Future<bool> loadResources() {
    Completer<bool> completer = new Completer<bool>();
    int progress_at = 0;
    int progress_total = resourceManager.resources.length;
    void increaseProgress() {
      ++progress_at;
      print("loaded " + progress_at.toString() + " of " + progress_total.toString());
      if (progress_at == progress_total) {
        completer.complete(true);
      }
    }
    resourceManager.resources.forEach((Resource resource) {
      switch (resource.type) {
        case "image":
          getImageLoader().loadImage(resource.path).listen((Image img) {
            resource.data = img;
            increaseProgress();
          });
          break;
        case "map":
          loadTilemap(resource.path).listen((Tilemap tilemap) {
            resource.data = tilemap;
            increaseProgress();
          });
          break;
        default:
          print("Warning: unknown resource type \"" + resource.type + "\"");
      }
    });
    return completer.future;
  }
  
  Surface createScreen(int width, int height) {
    switch (_graphicsTarget) {
      case GRAPHICS_TARGET_HTML_5_CANVAS:
        return new HtmlCanvasScreen(width, height);
      case GRAPHICS_TARGET_WEB_GL:
        throw new UnimplementedError();
      default:
        throw new AssertionError("Invalid Graphics Target");
    }
  }
  
  ImageLoader getImageLoader() {
    switch (_graphicsTarget) {
      case GRAPHICS_TARGET_HTML_5_CANVAS:
        return new HtmlCanvasImageLoader();
      case GRAPHICS_TARGET_WEB_GL:
        throw new UnimplementedError();
      default:
        throw new AssertionError("Invalid Graphics Target");
    }
  }
  
  Iterable<TilemapLoader> getTilemapLoaderForExtension(String extension) {
    switch (extension) {
      case ".tmx":
        return new Iterable.generate(1, (_) => new TmxTilesetLoader());
      default:
        return new Iterable.generate(0, (_) => null);
    }
  }
  
  Stream<Tilemap> loadTilemap(String path) {
    int i = path.lastIndexOf(".");
    if (i == -1) {
      return new Future<Tilemap>.error("tileset missing extension").asStream();
    }
    String ext = path.substring(i);
    Iterable<TilemapLoader> maybeTilesetLoader = getTilemapLoaderForExtension(ext);
    if (maybeTilesetLoader.isEmpty) {
      return new Future<Tilemap>.error("no loader found for given tileset").asStream();
    }
    TilemapLoader tilemapLoader = maybeTilesetLoader.first;
    Completer<Tilemap> completer = new Completer<Tilemap>();
    HttpRequest request = new HttpRequest();
    request.overrideMimeType("text/xml");
    request.open("GET", path, async: true);
    request.onLoad.listen((e) {
      if ((request.status >= 200 && request.status < 300) ||
          request.status == 0 || request.status == 304) {
        var xml = request.response;
        tilemapLoader.loadTileset(xml).listen(
          (Tilemap tilemap) {
            completer.complete(tilemap);
          },
          onError: (e) {
            completer.completeError(e);
          }
        );
      } else {
        completer.completeError(e);
      }
    });
    request.onError.listen((e) {
      completer.completeError(e);
    });
    request.send();
    return completer.future.asStream();
  }
  
  void drawMap(Surface screen, Tilemap map) {
    int firstRow = (cameraLoc.y / map.tileHeight).toInt();
    int lastRow = ((cameraLoc.y + screen.height + (map.tileHeight-1)) / map.tileHeight).toInt();
    int firstCol = (cameraLoc.x / map.tileWidth).toInt();
    int lastCol = ((cameraLoc.x + screen.width + (map.tileWidth-1)) / map.tileWidth).toInt();
    int offsetX = firstCol * map.tileWidth - cameraLoc.x;
    int offsetY = firstRow * map.tileHeight - cameraLoc.y;
    screen.fillRect(0, 0, screen.width, screen.height, map.backgroundColour);
    for (int row = firstRow; row <= lastRow; ++row) {
      for (int col = firstCol; col <= lastCol; ++col) {
        if (row < 0 || col < 0 || row >= map.rows || col >= map.cols) { continue; }
        for (int layer = 0; layer < map.layerCount; ++layer) {
          int gid = map.getLayer(layer).getGlobalTileId(row, col);
          if (gid == 0) { continue; }
          if (gid >= 1351) { continue; }
          Image tilesetImg = _resourceManager.lookupResource("sma4_tiles").data;
          int sr = ((gid-1)/54).toInt();
          int sc = (gid-1)%54;
          int sx = sc * 18 + 2;
          int sy = sr * 18 + 2;
          screen.drawImage(tilesetImg, sx, sy, map.tileWidth, map.tileHeight, offsetX + (col-firstCol) * map.tileWidth, offsetY + (row-firstRow) * map.tileHeight, map.tileWidth, map.tileHeight, false);
        }
      }
    }
  }
  
  void update(double dt) {
    deadObjectPool.forEach((GameObject go) { objectPool.remove(go); });
    deadObjectPool.clear();
    this.dt = dt;
    objectPool.forEach((GameObject go) {
      go.update(this);
    });
    _doObjectObjectCollision();
  }
  
  void _doObjectObjectCollision() {
    for (int i = 0; i < objectPool.length-1; ++i) {
      GameObject o1 = objectPool[i];
      Rect<int> cArea1 = o1.collisionArea;
      for (int j = i+1; j < objectPool.length; ++j) {
        GameObject o2 = objectPool[j];
        Rect<int> cArea2 = o2.collisionArea;
        if (cArea1.minX < cArea2.maxX && cArea1.maxX > cArea2.minX && 
            cArea1.minY < cArea2.maxY && cArea1.maxY > cArea2.minY)
        {
          collisionResolution(o1, o2);
        }
      }
    }
  }
  
  void draw(Surface screen) {
    drawMap(screen, level);
    drawGameObjects(screen);
  }
  
  void drawGameObjects(Surface screen) {
    objectPool.forEach((GameObject go) {
      go.render(resourceManager, screen, new Vec2<int>(go.location.x.toInt() - cameraLoc.x, go.location.y.toInt() - cameraLoc.y));
      screen.drawRect(go.location.x.toInt() + go.collisionRect.minX - cameraLoc.x, go.location.y.toInt() + go.collisionRect.minY - cameraLoc.y, go.collisionRect.len.x, go.collisionRect.len.y, "#FF0000");
    });
  }
}
