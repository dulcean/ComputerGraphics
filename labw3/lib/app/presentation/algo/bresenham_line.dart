import 'dart:math';

class BresenhamLine {
  static List<Point<int>> bresenhamLine(
    int x0,
    int y0,
    int x1,
    int y1,
    Function(String) logCallback,
  ) {
    List<Point<int>> points = [];
    int dx = (x1 - x0).abs();
    int dy = -(y1 - y0).abs();
    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;
    int err = dx + dy;

    while (true) {
      points.add(Point(x0, y0));
      if (x0 == x1 && y0 == y1) break;
      int e2 = 2 * err;
      if (e2 >= dy) {
        err += dy;
        x0 += sx;
      }
      if (e2 <= dx) {
        err += dx;
        y0 += sy;
      }
    }
    return points;
  }
}
