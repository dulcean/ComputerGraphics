import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final int gridSizeX;
  final int gridSizeY;
  final double cellSize;
  final List<List<Color>> grid;

  GridPainter(this.gridSizeX, this.gridSizeY, this.cellSize, this.grid);

  @override
  void paint(Canvas canvas, Size size) {
    Paint gridPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke;

    Paint cellPaint = Paint()..style = PaintingStyle.fill;

    for (int y = 0; y < gridSizeY; y++) {
      for (int x = 0; x < gridSizeX; x++) {
        Rect cellRect =
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize);
        cellPaint.color = grid[y][x];
        canvas.drawRect(cellRect, cellPaint);
        canvas.drawRect(cellRect, gridPaint);
      }
    }

    Paint axisPaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2;

    double centerX = gridSizeX / 2 * cellSize;
    double centerY = gridSizeY / 2 * cellSize;

    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), axisPaint);

    canvas.drawLine(
        Offset(centerX, 0), Offset(centerX, size.height), axisPaint);

    _drawAxisLabels(canvas, size, centerX, centerY);
  }

  void _drawAxisLabels(
      Canvas canvas, Size size, double centerX, double centerY) {
    TextStyle textStyle = const TextStyle(
        color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.w600);

    for (int i = 0; i <= gridSizeX; i++) {
      double x = i * cellSize;
      int label = i - gridSizeX ~/ 2;
      TextSpan span = TextSpan(style: textStyle, text: label.toString());
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, centerY + 2));
    }

    for (int i = 0; i <= gridSizeY; i++) {
      double y = i * cellSize;
      int label = gridSizeY ~/ 2 - i;
      TextSpan span = TextSpan(style: textStyle, text: label.toString());
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(centerX + 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
