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
    final stopwatch = Stopwatch()..start();
    int dx = (x1 - x0).abs();
    int dy = -(y1 - y0).abs();
    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;
    int err = dx + dy;

    logCallback(
        "[Bresenham] Начальные значения: x0 = $x0, y0 = $y0, x1 = $x1, y1 = $y1, dx = $dx, dy = $dy, err = $err");

    while (true) {
      points.add(Point(x0, y0));
      logCallback("[Bresenham] Рисуем точку ($x0, $y0)");

      if (x0 == x1 && y0 == y1) break;

      int e2 = 2 * err;
      logCallback("[Bresenham] Вычислен e2 = $e2");

      if (e2 >= dy) {
        err += dy;
        x0 += sx;
        logCallback("[Bresenham] Изменение по x: x0 = $x0, err = $err");
      }
      if (e2 <= dx) {
        err += dx;
        y0 += sy;
        logCallback("[Bresenham] Изменение по y: y0 = $y0, err = $err");
      }
    }
    stopwatch.stop();
    logCallback(
        '[Bresenham] Line закончил работу (${stopwatch.elapsedMicroseconds} mcrs)');
    return points;
  }
}
