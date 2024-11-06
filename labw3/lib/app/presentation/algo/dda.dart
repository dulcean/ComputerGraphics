import 'dart:math';

class DdaLine {
  static List<Point<int>> ddaLine(
    int x0,
    int y0,
    int x1,
    int y1,
    Function(String) logCallback,
  ) {
    List<Point<int>> points = [];
    int dx = x1 - x0;
    int dy = y1 - y0;
    int steps = dx.abs() > dy.abs() ? dx.abs() : dy.abs();
    double xIncrement = dx / steps;
    double yIncrement = dy / steps;
    double x = x0.toDouble();
    double y = y0.toDouble();

    for (int i = 0; i <= steps; i++) {
      points.add(Point(x.round(), y.round()));
      x += xIncrement;
      y += yIncrement;
    }
    return points;
  }
}
