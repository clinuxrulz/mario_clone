part of engine;

class TmxTileLayer implements TileLayer {
  XmlElement _xml;
  List<int> _cellBytes;
  
  TmxTileLayer(XmlElement xml) {
    this._xml = xml;
    _init();
  }
  
  void _init() {
    XmlElement data = _xml.children.firstWhere((XmlElement element) => element.name == "data");
    _cellBytes = CryptoUtils.base64StringToBytes(data.text);
  }
  
  String get name {
    return _xml.attributes["name"];
  }
  
  int get width {
    return int.parse(_xml.attributes["width"]);
  }
  
  int get height {
    return int.parse(_xml.attributes["height"]);
  }
  
  int getGlobalTileId(int rowIndex, int colIndex) {
    int offset = (rowIndex * width + colIndex) * 4;
    int id = (_cellBytes[offset])
           + (_cellBytes[offset+1] << 8)
           + (_cellBytes[offset+2] << 16)
           + (_cellBytes[offset+3] << 24);
    return id;
  }
}
