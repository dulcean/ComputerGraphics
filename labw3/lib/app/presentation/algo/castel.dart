import 'dart:math';

class CasteljauAlgorithm {
  static List<Point<int>> casteljau(
    int x0,
    int y0,
    int x1,
    int y1,
    int steps,
    Function(String) logCallback,
  ) {
    List<Point<int>> curvePoints = [];
    final stopwatch = Stopwatch()..start();

    logCallback("[Casteljau] Начальные точки: ($x0, $y0) и ($x1, $y1)");

    int xMid = ((x0 + x1) / 2).round();
    int yMid = ((y0 + y1) / 2).round();

    List<Point<int>> controlPoints = [
      Point(x0, y0),
      Point(xMid, yMid),
      Point(x1, y1),
    ];

    for (int i = 0; i <= steps; i++) {
      double t = i / steps;
      Point<int> point = _deCasteljau(controlPoints, t);
      curvePoints.add(point);
      logCallback("[Casteljau] Шаг $i, t = $t, точка: ($point)");
    }

    stopwatch.stop();
    logCallback(
        '[Casteljau] Алгоритм завершен за ${stopwatch.elapsedMicroseconds} мкс');
    return curvePoints;
  }

  static Point<int> _deCasteljau(List<Point<int>> points, double t) {
    List<Point<double>> tempPoints = points
        .map((point) => Point<double>(point.x.toDouble(), point.y.toDouble()))
        .toList();
    int n = tempPoints.length;
    for (int r = 1; r < n; r++) {
      for (int i = 0; i < n - r; i++) {
        double x = (1 - t) * tempPoints[i].x + t * tempPoints[i + 1].x;
        double y = (1 - t) * tempPoints[i].y + t * tempPoints[i + 1].y;
        tempPoints[i] = Point<double>(x, y);
      }
    }

    return Point<int>(tempPoints[0].x.round(), tempPoints[0].y.round());
  }
}
