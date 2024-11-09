import 'dart:math';

class BresenhamCircle {
  static List<Point<int>> bresenhamCircle(
    int x0,
    int y0,
    int radius,
    Function(String) logCallback,
  ) {
    List<Point<int>> points = [];
    final stopwatch = Stopwatch()..start();

    int x = radius;
    int y = 0;
    int decisionOver2 = 1 - x;

    logCallback(
        "[BresenhamCircle] Начальные значения: x0 = $x0, y0 = $y0, радиус = $radius");

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

      logCallback("[BresenhamCircle] Рисуем точки: "
          "(${x0 + x}, ${y0 + y}), (${x0 + y}, ${y0 + x}), (${x0 - y}, ${y0 + x}), (${x0 - x}, ${y0 + y}), "
          "(${x0 - x}, ${y0 - y}), (${x0 - y}, ${y0 - x}), (${x0 + y}, ${y0 - x}), (${x0 + x}, ${y0 - y})");

      y++;
      if (decisionOver2 <= 0) {
        decisionOver2 += 2 * y + 1;
        logCallback(
            "[BresenhamCircle] Изменение по y: y = $y, decisionOver2 = $decisionOver2");
      } else {
        x--;
        decisionOver2 += 2 * (y - x) + 1;
        logCallback(
            "[BresenhamCircle] Изменение по x и y: x = $x, y = $y, decisionOver2 = $decisionOver2");
      }
    }

    stopwatch.stop();
    logCallback(
        '[BresenhamCircle] Circle закончил работу (${stopwatch.elapsedMicroseconds} мкс)');
    return points;
  }
}
