part of mario;

class AnimationFrame extends ComponentPoolable {
  Engine.Animation animation;
  int currentFrame;
  double timeUtilNextFrame;
  bool flipX;
  
  AnimationFrame._();
  
  factory AnimationFrame({Engine.Animation animation}) {
    AnimationFrame animationFrame = new Poolable.of(AnimationFrame, _constructor);
    animationFrame.animation = animation;
    animationFrame.currentFrame = 0;
    animationFrame.timeUtilNextFrame = 1.0 / animation.frameRate.toDouble();
    animationFrame.flipX = false;
    return animationFrame;
  }
  
  static AnimationFrame _constructor() => new AnimationFrame._();
}