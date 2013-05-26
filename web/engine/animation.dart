part of engine;

class Animation {
  String name;
  String imageResName;
  Vec2<int> startLoc;
  Vec2<int> len;
  Vec2<int> step;
  List<int> frameSequence;
  int frameRate;
  
  Animation({this.name, this.imageResName, this.startLoc, this.len, this.step, this.frameSequence, this.frameRate});
  
  void render(ResourceManager resourceManager, Surface surface, Vec2<int> pos, int frameIndex, bool flipped) {
    Image image = resourceManager.lookupResource(imageResName).data;
    if (!flipped) {
      surface.drawImage(
        image,
        startLoc.x + frameSequence[frameIndex] * step.x,
        startLoc.y + frameSequence[frameIndex] * step.y,
        len.x,
        len.y,
        pos.x,
        pos.y,
        len.x,
        len.y,
        false
      );
    } else {
      surface.drawImage(
        image,
        startLoc.x + frameSequence[frameIndex] * step.x,
        startLoc.y + frameSequence[frameIndex] * step.y,
        len.x,
        len.y,
        pos.x + len.x,
        pos.y,
        len.x,
        len.y,
        true
      );
    }
  }
}
