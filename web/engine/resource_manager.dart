part of engine;

class Resource {
  String name;
  String type;
  String path;
  var data;
  
  Resource({this.name,this.type,this.path});
}

class ResourceManager {
  Map<String,Resource> _resources = new Map();
  
  void addResource(Resource resource) {
    _resources[resource.name] = resource;
  }
  
  Iterable<Resource> get resources {
    return _resources.values;
  }
  
  void setResourceData(String name, var data) {
    if (!_resources.contains(name)) {
      throw new Exception("resource not found");
    }
    _resources[name].data = data;
  }
  
  Resource lookupResource(String name) {
    return _resources[name];
  }
}
