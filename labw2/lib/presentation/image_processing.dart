import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageProcessingPage extends StatefulWidget {
  const ImageProcessingPage({super.key});

  @override
  _ImageProcessingPageState createState() => _ImageProcessingPageState();
}

class _ImageProcessingPageState extends State<ImageProcessingPage> {
  Uint8List? _processedImageDataGlobal;
  Uint8List? _processedImageDataBernsen;
  Uint8List? _processedImageDataNiblack;

  final _urlController = TextEditingController();
  final String apiUrlGlobal = 'http://127.0.0.1:5000/threshold/global';
  final String apiUrlBernsen = 'http://127.0.0.1:5000/threshold/bernsen';
  final String apiUrlNiblack = 'http://127.0.0.1:5000/threshold/niblack';
  final String apiUrlStatistical =
      'http://127.0.0.1:5000/threshold/statistical';

  double _thresholdValueGlobal = 127;
  double _thresholdValueBernsen = 127;
  double _thresholdValueNiblack = 127;
  double _windowSizeBernsen = 15;
  double _contrastThresholdBernsen = 15;
  double _windowSizeNiblack = 15;
  double _kNiblack = -0.2;

  bool _isLoadingGlobal = false;
  bool _isLoadingBernsen = false;
  bool _isLoadingNiblack = false;

  Uint8List? _processedImageDataStatistical;
  double _windowSizeStatistical = 3;
  bool _isLoadingStatistical = false;

  Future<void> _loadImageFromUrl(String method, String url, double threshold,
      {double? windowSize, double? contrastThreshold, double? k}) async {
    setState(() {
      if (method == 'global') _isLoadingGlobal = true;
      if (method == 'bernsen') _isLoadingBernsen = true;
      if (method == 'niblack') _isLoadingNiblack = true;
    });

    try {
      log('Отправка запроса: метод: $method, URL: $url, порог: $threshold, window_size: $windowSize, contrast_threshold: $contrastThreshold, k: $k');
      String apiUrl;
      if (method == 'global') {
        apiUrl = apiUrlGlobal;
      } else if (method == 'bernsen') {
        apiUrl = apiUrlBernsen;
      } else {
        apiUrl = apiUrlNiblack;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'url': url,
          'threshold': threshold,
          'window_size': windowSize,
          'contrast_threshold': contrastThreshold,
          'k': k
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          if (method == 'global')
            _processedImageDataGlobal = response.bodyBytes;
          if (method == 'bernsen')
            _processedImageDataBernsen = response.bodyBytes;
          if (method == 'niblack')
            _processedImageDataNiblack = response.bodyBytes;
        });
      } else {
        log('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка при отправке запроса: $e');
    } finally {
      setState(() {
        if (method == 'global') _isLoadingGlobal = false;
        if (method == 'bernsen') _isLoadingBernsen = false;
        if (method == 'niblack') _isLoadingNiblack = false;
      });
    }
  }

  Future<void> _loadImageFromUrlStatistical(
      String url, double windowSize) async {
    setState(() {
      _isLoadingStatistical = true;
    });

    try {
      log('Отправка запроса на статистический фильтр: URL: $url, window_size: $windowSize');
      final response = await http.post(
        Uri.parse(apiUrlStatistical),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'url': url,
          'window_size': windowSize,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _processedImageDataStatistical = response.bodyBytes;
        });
      } else {
        log('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка при отправке запроса: $e');
    } finally {
      setState(() {
        _isLoadingStatistical = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Processing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Введите URL изображения',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Глобальная пороговая обработка'),
              Slider(
                value: _thresholdValueGlobal,
                min: 0,
                max: 255,
                divisions: 255,
                label: _thresholdValueGlobal.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _thresholdValueGlobal = value;
                  });
                },
                onChangeEnd: (double value) {
                  _loadImageFromUrl('global', _urlController.text, value);
                },
              ),
              ElevatedButton(
                onPressed: () => _loadImageFromUrl(
                    'global', _urlController.text, _thresholdValueGlobal),
                child: const Text('Обработать изображение (Глобальный метод)'),
              ),
              if (_isLoadingGlobal) const CircularProgressIndicator(),
              if (_processedImageDataGlobal != null && !_isLoadingGlobal)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.memory(_processedImageDataGlobal!),
                ),
              const Divider(),
              const Text('Метод Бернсена'),
              Slider(
                value: _windowSizeBernsen,
                min: 3,
                max: 50,
                divisions: 47,
                label: _windowSizeBernsen.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _windowSizeBernsen = value;
                  });
                },
              ),
              Slider(
                value: _contrastThresholdBernsen,
                min: 0,
                max: 255,
                divisions: 255,
                label: _contrastThresholdBernsen.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _contrastThresholdBernsen = value;
                  });
                },
              ),
              Slider(
                value: _thresholdValueBernsen,
                min: 0,
                max: 255,
                divisions: 255,
                label: _thresholdValueBernsen.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _thresholdValueBernsen = value;
                  });
                },
                onChangeEnd: (double value) {
                  _loadImageFromUrl('bernsen', _urlController.text, value,
                      windowSize: _windowSizeBernsen,
                      contrastThreshold: _contrastThresholdBernsen);
                },
              ),
              ElevatedButton(
                onPressed: () => _loadImageFromUrl(
                    'bernsen', _urlController.text, _thresholdValueBernsen,
                    windowSize: _windowSizeBernsen,
                    contrastThreshold: _contrastThresholdBernsen),
                child: const Text('Обработать изображение (Метод Бернсена)'),
              ),
              if (_isLoadingBernsen) const CircularProgressIndicator(),
              if (_processedImageDataBernsen != null && !_isLoadingBernsen)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.memory(_processedImageDataBernsen!),
                ),
              const Divider(),
              const Text('Метод Ниблака'),
              Slider(
                value: _windowSizeNiblack,
                min: 3,
                max: 50,
                divisions: 47,
                label: _windowSizeNiblack.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _windowSizeNiblack = value;
                  });
                },
              ),
              Slider(
                value: _kNiblack,
                min: -1.0,
                max: 1.0,
                divisions: 20,
                label: _kNiblack.toString(),
                onChanged: (double value) {
                  setState(() {
                    _kNiblack = value;
                  });
                },
              ),
              Slider(
                value: _thresholdValueNiblack,
                min: 0,
                max: 255,
                divisions: 255,
                label: _thresholdValueNiblack.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _thresholdValueNiblack = value;
                  });
                },
                onChangeEnd: (double value) {
                  _loadImageFromUrl('niblack', _urlController.text, value,
                      windowSize: _windowSizeNiblack, k: _kNiblack);
                },
              ),
              ElevatedButton(
                onPressed: () => _loadImageFromUrl(
                    'niblack', _urlController.text, _thresholdValueNiblack,
                    windowSize: _windowSizeNiblack, k: _kNiblack),
                child: const Text('Обработать изображение (Метод Ниблака)'),
              ),
              if (_isLoadingNiblack) const CircularProgressIndicator(),
              if (_processedImageDataNiblack != null && !_isLoadingNiblack)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.memory(_processedImageDataNiblack!),
                ),
              const Text('Статистический фильтр'),
              Slider(
                value: _windowSizeStatistical,
                min: 3,
                max: 50,
                divisions: 47,
                label: _windowSizeStatistical.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _windowSizeStatistical = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () => _loadImageFromUrlStatistical(
                    _urlController.text, _windowSizeStatistical),
                child: const Text(
                    'Обработать изображение (Статистический фильтр)'),
              ),
              if (_isLoadingStatistical) const CircularProgressIndicator(),
              if (_processedImageDataStatistical != null &&
                  !_isLoadingStatistical)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.memory(_processedImageDataStatistical!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
