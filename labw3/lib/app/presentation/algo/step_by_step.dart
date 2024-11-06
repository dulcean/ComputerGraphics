import 'dart:math';

class StepByStepLine {
  static List<Point<int>> stepByStepLine(
    int x0,
    int y0,
    int x1,
    int y1,
    Function(String) logCallback,
  ) {
    List<Point<int>> points = [];
    final stopwatch = Stopwatch()..start();

    logCallback('[StepByStep] Пошаговый алгоритм начал работу.');
    logCallback('[StepByStep] Рисуем линию от ($x0, $y0) до ($x1, $y1)');

    int dx = x1 - x0;
    int dy = y1 - y0;

    logCallback('[StepByStep] Вычисленный dx = $dx');
    logCallback('[StepByStep] Вычисленный dy = $dy');

    bool isSteep = dy.abs() > dx.abs();

    if (isSteep) {
      logCallback('[StepByStep] |dy| >= |dx| => линия крутая, меняем x и y местами');

      int temp;
      temp = x0;
      x0 = y0;
      y0 = temp;
      temp = x1;
      x1 = y1;
      y1 = temp;
    } else {
      logCallback('[StepByStep] |dy| < |dx| => линия не крутая');
    }

    if (x0 > x1) {
      logCallback('[StepByStep] x0 > x1 => меняем начальные и конечные точки местами');

      int temp;
      temp = x0;
      x0 = x1;
      x1 = temp;
      temp = y0;
      y0 = y1;
      y1 = temp;
    }

    dx = x1 - x0;
    dy = y1 - y0;

    logCallback('[StepByStep] Обновленный dx = $dx');
    logCallback('[StepByStep] Обновленный dy = $dy');

    double gradient = dy / dx;
    logCallback('[StepByStep] Вычисленный градиент = $gradient');

    double y = y0.toDouble();

    for (int x = x0; x <= x1; x++) {
      int roundedY = y.round();
      if (isSteep) {
        points.add(Point(roundedY, x));
        logCallback(
            '[StepByStep] Точное значение x для y = $x равно ${y.toStringAsFixed(2)}, рисуем точку ($roundedY, $x)');
      } else {
        points.add(Point(x, roundedY));
        logCallback(
            '[StepByStep] Точное значение y для x = $x равно ${y.toStringAsFixed(2)}, рисуем точку ($x, $roundedY)');
      }
      y += gradient;
    }

    stopwatch.stop();
    logCallback(
        '[StepByStep] Пошаговый алгоритм закончил работу (${stopwatch.elapsedMicroseconds} mcrs)');
    return points;
  }
}
