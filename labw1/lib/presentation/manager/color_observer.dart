import '../../data/cmyk_color.dart';
import '../../data/hsv_color.dart';
import '../../data/rgb_model.dart';

class ColorObserver {
  RGBColor _rgb;
  CMYKColor _cmyk;
  HSVColor _hsv;

  ColorObserver({required RGBColor rgb})
      : _rgb = rgb,
        _cmyk = rgb.toCMYK(),
        _hsv = rgb.toHSV();

  RGBColor get rgb => _rgb;
  CMYKColor get cmyk => _cmyk;
  HSVColor get hsv => _hsv;

  void updateFromRGB(RGBColor newRgb) {
    _rgb = newRgb;
    _cmyk = _rgb.toCMYK();
    _hsv = _rgb.toHSV();
  }

  void updateFromCMYK(CMYKColor newCmyk) {
    _cmyk = newCmyk;
    _rgb = _cmyk.toRGB();
    _hsv = _rgb.toHSV();
  }

  void updateFromHSV(HSVColor newHsv) {
    _hsv = newHsv;
    if (_hsv.v == 0 && _hsv.s == 0) {
      _rgb = RGBColor(0, 0, 0);
      _cmyk = CMYKColor(0, 0, 0, 1);
    } else {
      _rgb = _hsv.toRGB();
      _cmyk = _rgb.toCMYK();
    }
  }
}
