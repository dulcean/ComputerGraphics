import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:labw1/presentation/manager/color_observer.dart';

import '../../../data/cmyk_color.dart';
import '../../../data/hsv_color.dart' as custom_hsv;
import '../../../data/rgb_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late ColorObserver colorObserver;
  late TextEditingController rController, gController, bController;
  late TextEditingController cController, mController, yController, kController;
  late TextEditingController hController, sController, vController;

  @override
  void initState() {
    super.initState();
    colorObserver = ColorObserver(rgb: RGBColor(255, 0, 0));
    _initializeControllers();
  }

  void _initializeControllers() {
    rController = TextEditingController(text: colorObserver.rgb.r.toString());
    gController = TextEditingController(text: colorObserver.rgb.g.toString());
    bController = TextEditingController(text: colorObserver.rgb.b.toString());
    cController = TextEditingController(text: colorObserver.cmyk.c.toString());
    mController = TextEditingController(text: colorObserver.cmyk.m.toString());
    yController = TextEditingController(text: colorObserver.cmyk.y.toString());
    kController = TextEditingController(text: colorObserver.cmyk.k.toString());
    hController = TextEditingController(text: colorObserver.hsv.h.toString());
    sController = TextEditingController(text: colorObserver.hsv.s.toString());
    vController = TextEditingController(text: colorObserver.hsv.v.toString());
  }

  @override
  void dispose() {
    rController.dispose();
    gController.dispose();
    bController.dispose();
    cController.dispose();
    mController.dispose();
    yController.dispose();
    kController.dispose();
    hController.dispose();
    sController.dispose();
    vController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Color Manager',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildColorPicker(),
                  const SizedBox(height: 20),
                  _buildColorInput(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Выберите цвет'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: Color.fromRGBO(
                    colorObserver.rgb.r.toInt(),
                    colorObserver.rgb.g.toInt(),
                    colorObserver.rgb.b.toInt(),
                    1,
                  ),
                  onColorChanged: (color) {
                    setState(() {
                      colorObserver.updateFromRGB(
                        RGBColor(
                          color.red.toDouble(),
                          color.green.toDouble(),
                          color.blue.toDouble(),
                        ),
                      );
                      _updateControllersFromObserver();
                    });
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Готово'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(
            colorObserver.rgb.r.toInt(),
            colorObserver.rgb.g.toInt(),
            colorObserver.rgb.b.toInt(),
            1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRgbColumn(),
            _buildCmykColumn(),
            _buildHsvColumn(),
          ],
        ),
      ],
    );
  }

  Widget _buildRgbColumn() {
    return Column(
      children: [
        const Text('RGB', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTextField('R', rController, (value) {
          if (value.isNotEmpty && int.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromRGB(
                RGBColor(
                  double.parse(value),
                  colorObserver.rgb.g,
                  colorObserver.rgb.b,
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
        _buildTextField('G', gController, (value) {
          if (value.isNotEmpty && int.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromRGB(
                RGBColor(
                  colorObserver.rgb.r,
                  double.parse(value),
                  colorObserver.rgb.b,
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
        _buildTextField('B', bController, (value) {
          if (value.isNotEmpty && int.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromRGB(
                RGBColor(
                  colorObserver.rgb.r,
                  colorObserver.rgb.g,
                  double.parse(value),
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
      ],
    );
  }

  Widget _buildCmykColumn() {
    return Column(
      children: [
        const Text('CMYK', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTextField('C', cController, (value) {
          if (value.isNotEmpty && double.tryParse(value) != null) {
            setState(() {
              // Allow CMYK updates to reflect RGB automatically
              colorObserver.updateFromCMYK(
                CMYKColor(
                  double.parse(value),
                  colorObserver.cmyk.m,
                  colorObserver.cmyk.y,
                  colorObserver.cmyk.k,
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
        _buildTextField('M', mController, (value) {
          if (value.isNotEmpty && double.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromCMYK(
                CMYKColor(
                  colorObserver.cmyk.c,
                  double.parse(value),
                  colorObserver.cmyk.y,
                  colorObserver.cmyk.k,
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
        _buildTextField('Y', yController, (value) {
          if (value.isNotEmpty && double.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromCMYK(
                CMYKColor(
                  colorObserver.cmyk.c,
                  colorObserver.cmyk.m,
                  double.parse(value),
                  colorObserver.cmyk.k,
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
        _buildTextField('K', kController, (value) {
          if (value.isNotEmpty && double.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromCMYK(
                CMYKColor(
                  colorObserver.cmyk.c,
                  colorObserver.cmyk.m,
                  colorObserver.cmyk.y,
                  double.parse(value),
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
      ],
    );
  }

  Widget _buildHsvColumn() {
    return Column(
      children: [
        const Text('HSV', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTextField('H', hController, (value) {
          if (value.isNotEmpty && double.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromHSV(
                custom_hsv.HSVColor(
                  double.parse(value),
                  colorObserver.hsv.s,
                  colorObserver.hsv.v,
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
        _buildTextField('S', sController, (value) {
          if (value.isNotEmpty && double.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromHSV(
                custom_hsv.HSVColor(
                  colorObserver.hsv.h,
                  double.parse(value),
                  colorObserver.hsv.v,
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
        _buildTextField('V', vController, (value) {
          if (value.isNotEmpty && double.tryParse(value) != null) {
            setState(() {
              colorObserver.updateFromHSV(
                custom_hsv.HSVColor(
                  colorObserver.hsv.h,
                  colorObserver.hsv.s,
                  double.parse(value),
                ),
              );
              _updateControllersFromObserver();
            });
          }
        }),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, Function(String) onChanged) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }

  void _updateControllersFromObserver() {
    rController.text = colorObserver.rgb.r.toString();
    gController.text = colorObserver.rgb.g.toString();
    bController.text = colorObserver.rgb.b.toString();
    cController.text = colorObserver.cmyk.c.toString();
    mController.text = colorObserver.cmyk.m.toString();
    yController.text = colorObserver.cmyk.y.toString();
    kController.text = colorObserver.cmyk.k.toString();
    hController.text = colorObserver.hsv.h.toString();
    sController.text = colorObserver.hsv.s.toString();
    vController.text = colorObserver.hsv.v.toString();
  }
}
