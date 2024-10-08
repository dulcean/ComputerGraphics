import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Color color = Color(0xFF000000);

class ColorPickerApp extends StatefulWidget {
  @override
  _ColorPickerAppState createState() => _ColorPickerAppState();
}

class _ColorPickerAppState extends State<ColorPickerApp> {
  RgbColor rgb = RgbColor.fromColor(color);
  CmykColor cmyk = CmykColor.fromColor(color);
  HSVColor hsv = HSVColor.fromColor(color);

  Color currentColor = Colors.black;

  @override
  void initState() {
    super.initState();
    updateColor();
  }

  void updateColor() {
    setState(() {
      rgb = RgbColor.fromColor(currentColor);
      cmyk = CmykColor.fromColor(currentColor);
      hsv = HSVColor.fromColor(currentColor);
    });
  }

  void selectColor(Color color) {
    setState(() {
      currentColor = color;
      updateColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Color Picker'),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: buildColorSection(
                      'RGB',
                      ['R', 'G', 'B'],
                      [255.0, 255.0, 255.0],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildColorSection(
                      'CMYK',
                      ['C', 'M', 'Y', 'K'],
                      [100.0, 100.0, 100.0, 100.0],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildColorSection(
                      'HSV',
                      ['H', 'S', 'V'],
                      [360.0, 1.0, 1.0],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Current Color',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: currentColor,
                          onColorChanged: selectColor,
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Done'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            updateColor();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Open Color Picker'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorSection(
      String title, List<String> labels, List<double> maxValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        const SizedBox(height: 8),
        buildColorSliderColumn(labels, maxValues),
      ],
    );
  }

  Widget buildColorSliderColumn(List<String> labels, List<double> maxValues) {
    return Column(
      children: List.generate(labels.length, (index) {
        double currentValue = getValueForLabel(labels[index]);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${labels[index]}: ${currentValue.toStringAsFixed(2)}'),
              Slider(
                value: currentValue,
                min: 0.0,
                max: maxValues[index],
                divisions: labels[index] == 'H'
                    ? 360
                    : (maxValues[index] == 1.0
                        ? 100
                        : maxValues[index].toInt()),
                onChanged: (value) {
                  setState(() {
                    setValueForLabel(labels[index], value);
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  double getValueForLabel(String label) {
    switch (label) {
      case 'R':
        return rgb.red.toDouble();
      case 'G':
        return rgb.green.toDouble();
      case 'B':
        return rgb.blue.toDouble();
      case 'C':
        return cmyk.cyan.toDouble();
      case 'M':
        return cmyk.magenta.toDouble();
      case 'Y':
        return cmyk.yellow.toDouble();
      case 'K':
        return cmyk.black.toDouble();
      case 'H':
        return hsv.hue;
      case 'S':
        return hsv.saturation;
      case 'V':
        return hsv.value;
      default:
        return 0.0;
    }
  }

  void setValueForLabel(String label, double value) {
    switch (label) {
      case 'R':
        rgb = rgb.copyWith(red: value.toInt());
        currentColor = rgb.toColor();
        break;
      case 'G':
        rgb = rgb.copyWith(green: value.toInt());
        currentColor = rgb.toColor();
        break;
      case 'B':
        rgb = rgb.copyWith(blue: value.toInt());
        currentColor = rgb.toColor();
        break;
      case 'C':
        cmyk = cmyk.copyWith(cyan: value);
        currentColor = cmyk.toRgbColor().toColor();
        break;
      case 'M':
        cmyk = cmyk.copyWith(magenta: value);
        currentColor = cmyk.toRgbColor().toColor();
        break;
      case 'Y':
        cmyk = cmyk.copyWith(yellow: value);
        currentColor = cmyk.toRgbColor().toColor();
        break;
      case 'K':
        cmyk = cmyk.copyWith(black: value);
        currentColor = cmyk.toRgbColor().toColor();
        break;
      case 'H':
        hsv = hsv.withHue(value);
        currentColor = hsv.toColor();
        break;
      case 'S':
        hsv = hsv.withSaturation(value);
        currentColor = hsv.toColor();
        break;
      case 'V':
        hsv = hsv.withValue(value);
        currentColor = hsv.toColor();
        break;
    }
    updateColor();
  }
}
