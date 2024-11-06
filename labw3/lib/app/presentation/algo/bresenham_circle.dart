import 'dart:math';

class BresenhamCircle {
  static List<Point<int>> bresenhamCircle(
    int x0,
    int y0,
    int radius,
    Function(String) logCallback,
  ) {
    List<Point<int>> points = [];
    int x = radius;
    int y = 0;
    int decisionOver2 = 1 - x;

    while (y <= x) {
      points.addAll([
        Point(x0 + x, y0 + y),
        Point(x0 + y, y0 + x),
        Point(x0 - y, y0 + x),
        Point(x0 - x, y0 + y),
        Point(x0 - x, y0 - y),
        Point(x0 - y, y0 - x),
        Point(x0 + y, y0 - x),
        Point(x0 + x, y0 - y),
      ]);
      y++;
      if (decisionOver2 <= 0) {
        decisionOver2 += 2 * y + 1;
      } else {
        x--;
        decisionOver2 += 2 * (y - x) + 1;
      }
    }
    return points;
  }
}
