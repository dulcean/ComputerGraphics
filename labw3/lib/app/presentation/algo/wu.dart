class WuLine {
  static List<Map<String, dynamic>> wuLine(
    int x0,
    int y0,
    int x1,
    int y1,
    Function(String) logCallback,
  ) {
    List<Map<String, dynamic>> points = [];
    final stopwatch = Stopwatch()..start();
    logCallback(
        "[WuLine] Начальные значения: x0 = $x0, y0 = $y0, x1 = $x1, y1 = $y1");

    bool steep = (y1 - y0).abs() > (x1 - x0).abs();
    if (steep) {
      int temp;
      temp = x0;
      x0 = y0;
      y0 = temp;
      temp = x1;
      x1 = y1;
      y1 = temp;
    }
    if (x0 > x1) {
      int temp;
      temp = x0;
      x0 = x1;
      x1 = temp;
      temp = y0;
      y0 = y1;
      y1 = temp;
    }
    int dx = x1 - x0;
    int dy = y1 - y0;
    double gradient = dy / dx;

    // Начальная точка
    double y = y0 + gradient * (x0 + 0.5 - x0);
    for (int x = x0; x <= x1; x++) {
      int baseY = y.floor();
      double intensityAbove = y - baseY;
      double intensityBelow = 1 - intensityAbove;

      if (steep) {
        points.add({'x': baseY, 'y': x, 'alpha': intensityBelow});
        points.add({'x': baseY + 1, 'y': x, 'alpha': intensityAbove});
      } else {
        points.add({'x': x, 'y': baseY, 'alpha': intensityBelow});
        points.add({'x': x, 'y': baseY + 1, 'alpha': intensityAbove});
      }
      y += gradient;
    }
    stopwatch.stop();
    logCallback(
        '[WuLine] Алгоритм завершен (${stopwatch.elapsedMicroseconds} мкс)');
    return points;
  }
}
