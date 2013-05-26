part of engine;

class TmxTileset implements Tileset {
  XmlElement _xml;
  
  TmxTileset(XmlElement xml) {
    this._xml = xml;
  }
  
  String get name {
    return _xml.attributes["name"];
  }
  
  int get tileWidth {
    return int.parse(_xml.attributes["tilewidth"]);
  }
  
  int get tileHeight {
    return int.parse(_xml.attributes["tileheight"]);
  }
  
  int get spacing {
    if (_xml.attributes.containsKey("spacing")) {
      return int.parse(_xml.attributes["spacing"]);
    } else {
      return 0;
    }
  }
  
  int get margin {
    if (_xml.attributes.containsKey("margin")) {
      return int.parse(_xml.attributes["margin"]);
    } else {
      return 0;
    }
  }
  
  String get imageSource {
    XmlElement image = _xml.children.firstWhere((_) => _.name == "image");
    return image.attributes["source"];
  }
}
