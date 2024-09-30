import 'rgb_model.dart';

class HSVColor {
  double h, s, v;

  HSVColor(this.h, this.s, this.v);

  // Method to convert HSV to RGB
  RGBColor toRGB() {
    double r, g, b;
    int i = (h / 60).floor();
    double f = h / 60 - i;
    double p = v * (1 - s);
    double q = v * (1 - f * s);
    double t = v * (1 - (1 - f) * s);
    v *= 255;

    switch (i % 6) {
      case 0:
        r = v; g = t; b = p;
        break;
      case 1:
        r = q; g = v; b = p;
        break;
      case 2:
        r = p; g = v; b = t;
        break;
      case 3:
        r = p; g = q; b = v;
        break;
      case 4:
        r = t; g = p; b = v;
        break;
      case 5:
        r = v; g = p; b = q;
        break;
      default:
        r = 0; g = 0; b = 0;
    }

    return RGBColor(r, g, b);
  }
}
