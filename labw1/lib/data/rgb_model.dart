import 'dart:math';

import 'cmyk_color.dart';
import 'hsv_color.dart';


class RGBColor {
  double r, g, b;

  RGBColor(this.r, this.g, this.b);

  // Method to convert RGB to CMYK
  CMYKColor toCMYK() {
    double c = 1 - (r / 255);
    double m = 1 - (g / 255);
    double y = 1 - (b / 255);
    double k = 1.0;

    if (c < 1) k = min(k, c);
    if (m < 1) k = min(k, m);
    if (y < 1) k = min(k, y);

    if (k == 1) {
      c = 0;
      m = 0;
      y = 0;
    } else {
      c = (c - k) / (1 - k);
      m = (m - k) / (1 - k);
      y = (y - k) / (1 - k);
    }

    return CMYKColor(c, m, y, k);
  }

  // Method to convert RGB to HSV
  HSVColor toHSV() {
    double max = max(r, max(g, b));
    double min = min(r, min(g, b));
    double h, s, v = max / 255;

    double d = max - min;
    s = max == 0 ? 0 : d / max;

    if (max == min) {
      h = 0; // achromatic
    } else {
      if (max == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (max == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }
      h /= 6;
    }

    return HSVColor(h * 360, s, v);
  }
}
