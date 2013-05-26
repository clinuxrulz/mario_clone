part of engine;

class Rect<T extends num> {
  final Vec2<T> pos;
  final Vec2<T> len;
  
  const Rect(this.pos, this.len);
  
  T get minX { return pos.x; }
  T get minY { return pos.y; }
  T get maxX { return pos.x + len.x; }
  T get maxY { return pos.y + len.y; }
  Vec2<double> get centre { return new Vec2<double>(pos.x + len.x / 2, pos.y + len.y / 2); }
}
