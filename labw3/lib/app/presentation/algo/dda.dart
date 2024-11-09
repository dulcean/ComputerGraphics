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
    final stopwatch = Stopwatch()..start();
    int dx = x1 - x0;
    int dy = y1 - y0;
    int steps = dx.abs() > dy.abs() ? dx.abs() : dy.abs();

    logCallback('[DDA] Начальные точки: ($x0, $y0) до ($x1, $y1)');
    logCallback('[DDA] dx = $dx, dy = $dy');
    logCallback('[DDA] Шагов: $steps');

    double xIncrement = dx / steps;
    double yIncrement = dy / steps;
    double x = x0.toDouble();
    double y = y0.toDouble();

    logCallback('[DDA] xIncrement = $xIncrement, yIncrement = $yIncrement');

    for (int i = 0; i <= steps; i++) {
      points.add(Point(x.round(), y.round()));
      logCallback('[DDA] Шаг $i: рисуем точку (${x.round()}, ${y.round()})');

      x += xIncrement;
      y += yIncrement;
    }

    stopwatch.stop();
    logCallback(
        '[DDA] DDA закончил работу (${stopwatch.elapsedMicroseconds} mcrs)');
    return points;
  }
}
