part of mario;

class AnimationSystem extends EntitySystem {
  ComponentMapper<AnimationFrame> animationFrameMapper;
  
  AnimationSystem(): super(Aspect.getAspectForAllOf([AnimationFrame]));
  
  @override
  void initialize() {
    animationFrameMapper = new ComponentMapper<AnimationFrame>(AnimationFrame, world);
  }
  
  @override
  void processEntities(ReadOnlyBag<Entity> entities) {
    entities.forEach((Entity entity) {
      AnimationFrame ani = animationFrameMapper.get(entity);
      ani.timeUtilNextFrame -= world.delta;
      while (ani.timeUtilNextFrame <= 0.0) {
        ani.timeUtilNextFrame += 1.0 / ani.animation.frameRate.toDouble();
        ++ani.currentFrame;
      }
      while (ani.currentFrame >= ani.animation.frameSequence.length) {
        ani.currentFrame -= ani.animation.frameSequence.length;
      }
    });
  }
  
  @override
  bool checkProcessing() {
    return true;
  }
}
