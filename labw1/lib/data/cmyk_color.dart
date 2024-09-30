import 'rgb_model.dart';

class CMYKColor {
  double c, m, y, k;

  CMYKColor(this.c, this.m, this.y, this.k);

  // Method to convert CMYK to RGB
  RGBColor toRGB() {
    double r = 255 * (1 - c) * (1 - k);
    double g = 255 * (1 - m) * (1 - k);
    double b = 255 * (1 - y) * (1 - k);
    return RGBColor(r, g, b);
  }
}
