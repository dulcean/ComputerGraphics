import 'dart:ui';

abstract class ColorModel {
  void updateFrom(ColorModel model);
  Color getColor();
}
