import 'dart:ui';

import 'package:labw1/data/color_model.dart';

class RGB extends ColorModel {
  int r, g, b;

  RGB({this.r = 0, this.g = 0, this.b = 0});
  factory RGB.fromColor(Color color) {
    return RGB(
      r: color.red,
      g: color.green,
      b: color.blue,
    );
  }
  @override
  void updateFrom(ColorModel model) {
    if (model is CMYK) {
      r = ((1 - model.c) * (1 - model.k) * 255).round();
      g = ((1 - model.m) * (1 - model.k) * 255).round();
      b = ((1 - model.y) * (1 - model.k) * 255).round();
    } else if (model is HSV) {
      double h = model.h / 360;
      double s = model.s / 100;
      double v = model.v / 100;

      int hi = (h * 6).floor() % 6;
      double f = (h * 6) - hi.toDouble();
      double p = (v * (1 - s));
      double q = (v * (1 - f * s));
      double t = (v * (1 - (1 - f) * s));
      v = (v * 255);

      switch (hi) {
        case 0: r = v.toInt(); g = t.toInt(); b = p.toInt(); break;
        case 1: r = q.toInt(); g = v.toInt(); b = p.toInt(); break;
        case 2: r = p.toInt(); g = v.toInt(); b = t.toInt(); break;
        case 3: r = p.toInt(); g = q.toInt(); b = v.toInt(); break;
        case 4: r = t.toInt(); g = p.toInt(); b = v.toInt(); break;
        case 5: r = v.toInt(); g = p.toInt(); b = q.toInt(); break;
      }
    }
  }

  @override
  Color getColor() {
    return Color.fromARGB(255, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
  }
}

class CMYK extends ColorModel {
  double c, m, y, k;

  CMYK({this.c = 0, this.m = 0, this.y = 0, this.k = 0});

  @override
void updateFrom(ColorModel model) {
  if (model is RGB) {
    double rPrime = model.r / 255;
    double gPrime = model.g / 255;
    double bPrime = model.b / 255;
    double k = 1 - [rPrime, gPrime, bPrime].reduce((a, b) => a > b ? a : b);
    
    c = (1 - rPrime - k) / (1 - k);
    m = (1 - gPrime - k) / (1 - k);
    y = (1 - bPrime - k) / (1 - k);
    
    c = c.isNaN ? 0 : c;
    m = m.isNaN ? 0 : m;
    y = y.isNaN ? 0 : y;
    this.k = k;
  } else if (model is HSV) {
    RGB rgb = RGB();
    rgb.updateFrom(model);
    updateFrom(rgb);
  }
}


  @override
  Color getColor() {
    RGB rgb = RGB();
    rgb.updateFrom(this);
    return rgb.getColor();
  }
}

class HSV extends ColorModel {
  double h, s, v;

  HSV({this.h = 0, this.s = 100, this.v = 100});

  @override
  void updateFrom(ColorModel model) {
    if (model is RGB) {
      double r = model.r / 255;
      double g = model.g / 255;
      double b = model.b / 255;
      double max = [r, g, b].reduce((a, b) => a > b ? a : b);
      double min = [r, g, b].reduce((a, b) => a < b ? a : b);
      v = max;
      double delta = max - min;

      if (max == 0) {
        s = 0;
      } else {
        s = delta / max;
      }

      if (delta == 0) {
        h = 0;
      } else {
        if (max == r) {
          h = (g - b) / delta;
        } else if (max == g) {
          h = 2 + (b - r) / delta;
        } else {
          h = 4 + (r - g) / delta;
        }
        h *= 60;
        if (h < 0) h += 360;
      }
    } else if (model is CMYK) {
      RGB rgb = RGB();
      rgb.updateFrom(model);
      updateFrom(rgb);
    }
  }

  @override
  Color getColor() {
    RGB rgb = RGB();
    rgb.updateFrom(this);
    return rgb.getColor();
  }
}

