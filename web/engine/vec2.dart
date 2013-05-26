part of engine;

class Vec2<T extends num> {
  final T x, y;
  
  const Vec2(this.x, this.y);
  
  Vec2<T> operator+(Vec2<T> rhs) {
    return new Vec2(x + rhs.x, y + rhs.y);
  }
  
  Vec2<T> operator-(Vec2<T> rhs) {
    return new Vec2(x - rhs.x, y - rhs.y);
  }
  
  Vec2<T> operator*(T a) {
    return new Vec2(x * a, y * a);
  }
  
  T dot(Vec2<T> rhs) {
    return x * rhs.x + y * rhs.y;
  }
  
  T cross(Vec2<T> rhs) {
    return x * rhs.y - y * rhs.x;
  }
  
  T lengthSquared() {
    return this.dot(this);
  }
  
  T length() {
    return sqrt(lengthSquared());
  }
  
  Vec2<int> toVec2Int() {
    return new Vec2<int>(x.toInt(), y.toInt());
  }
  
  Vec2<double> toVec2Double() {
    return new Vec2<double>(x.toDouble(), y.toDouble());
  }
}
