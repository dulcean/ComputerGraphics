import 'dart:async';

import 'package:flutter/material.dart';
import 'package:labw3/app/presentation/algo/bresenham_circle.dart';
import 'package:labw3/app/presentation/algo/bresenham_line.dart';
import 'package:labw3/app/presentation/algo/castel.dart';
import 'package:labw3/app/presentation/algo/dda.dart';
import 'package:labw3/app/presentation/algo/step_by_step.dart';
import 'package:labw3/app/presentation/algo/wu.dart';
import 'package:labw3/app/presentation/components/grid_painter.dart';
import 'package:labw3/app/presentation/components/row_switch.dart';
import 'package:labw3/app/presentation/util/command_exec.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<List<Color>> grid;
  Timer? _timer;
  double cellSize = 20.0;
  int gridSizeX = 10;
  int gridSizeY = 10;
  List<String> logs = [];
  TextEditingController commandController = TextEditingController();
  ScrollController logScrollController = ScrollController();
  int startX = 2;
  int startY = 2;
  int endX = 7;
  int endY = 7;
  int radius = 4;
  int iter = 10;
  double offsetX = 0;
  double offsetY = 0;

  void _updateStartX(int value) {
    setState(() {
      startX = value;
    });
  }

  void _updateStartY(int value) {
    setState(() {
      startY = value;
    });
  }

  void _updateEndX(int value) {
    setState(() {
      endX = value;
    });
  }

  void _updateEndY(int value) {
    setState(() {
      endY = value;
    });
  }

  void _updateRadius(int value) {
    setState(() {
      radius = value;
    });
  }

  void _updateIter(int value) {
    setState(() {
      iter = value;
    });
  }

  final List<String> algorithms = [
    'Bresenham Line',
    'Step By Step',
    'DDA',
    'Bresenham Circle',
    'Casteljau',
    'Wu'
  ];
  String selectedAlgorithm = 'Bresenham Line';

  @override
  void initState() {
    super.initState();
    _resetGrid();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void initConsole(String logMessage) {
    setState(() {
      logs.add(logMessage);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logScrollController.animateTo(
        logScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void lineAnimation(int x0, int y0, int x1, int y1, int radius, int iters) {
    dynamic points;
    bool hasAlpha = false;

    switch (selectedAlgorithm) {
      case 'Step By Step':
        points = StepByStepLine.stepByStepLine(x0, y0, x1, y1, (logMessage) {
          initConsole(logMessage);
        });
        break;
      case 'DDA':
        points = DdaLine.ddaLine(x0, y0, x1, y1, (logMessage) {
          initConsole(logMessage);
        });
        break;
      case 'Bresenham Circle':
        points = BresenhamCircle.bresenhamCircle(x0, y0, radius, (logMessage) {
          initConsole(logMessage);
        });
        break;
      case 'Casteljau':
        points =
            CasteljauAlgorithm.casteljau(x0, y0, x1, y1, iters, (logMessage) {
          initConsole(logMessage);
        });
        break;
      case 'Wu':
        points = WuLine.wuLine(x0, y0, x1, y1, (logMessage) {
          initConsole(logMessage);
        });
        hasAlpha = true;
        break;
      case 'Bresenham Line':
      default:
        points = BresenhamLine.bresenhamLine(x0, y0, x1, y1, (logMessage) {
          initConsole(logMessage);
        });
    }

    int index = 0;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (index < points.length) {
        setState(() {
          int x, y;
          double alpha = 1.0;

          if (hasAlpha) {
            x = points[index]['x'] + offsetX.toInt();
            y = -points[index]['y'] + offsetY.toInt() - 1;
            alpha = points[index]['alpha'];
          } else {
            x = points[index].x + offsetX.toInt();
            y = -points[index].y + offsetY.toInt() - 1;
          }

          if (x >= 0 && x < gridSizeX && y >= 0 && y < gridSizeY) {
            grid[y][x] = Color.fromRGBO(0, 0, 255, alpha);
          }
        });
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  void _resetGrid() {
    setState(() {
      grid = List.generate(
          gridSizeY, (_) => List.generate(gridSizeX, (_) => Colors.white));
    });
    offsetX = gridSizeX / 2;
    offsetY = gridSizeY / 2;
  }

  void _executeCommand(String command) {
    executeCommand(command, logs, setState);
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth = gridSizeX * cellSize;
    double gridHeight = gridSizeY * cellSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Labw :3'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: buildCoords(
                        selectedAlgorithm,
                        startX,
                        startY,
                        endX,
                        endY,
                        radius,
                        iter,
                        _updateStartX,
                        _updateStartY,
                        _updateEndX,
                        _updateEndY,
                        _updateRadius,
                        _updateIter,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Cell Size",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Slider(
                      value: cellSize,
                      min: 10,
                      max: 40,
                      divisions: 6,
                      label: cellSize.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          cellSize = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Grid Size X",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Slider(
                      value: gridSizeX.toDouble(),
                      min: 10,
                      max: 30,
                      divisions: 10,
                      label: gridSizeX.toString(),
                      onChanged: (value) {
                        setState(() {
                          gridSizeX = value.toInt();
                          _resetGrid();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Grid Size Y",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Slider(
                      value: gridSizeY.toDouble(),
                      min: 10,
                      max: 30,
                      divisions: 10,
                      label: gridSizeY.toString(),
                      onChanged: (value) {
                        setState(() {
                          gridSizeY = value.toInt();
                          _resetGrid();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _resetGrid();
                        lineAnimation(
                          startX,
                          startY,
                          endX,
                          endY,
                          radius,
                          iter,
                        );
                      },
                      child: const Text("Start Animation"),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        width: 250,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: commandController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Введите команду...',
                                hintStyle: TextStyle(color: Colors.purple),
                                filled: true,
                                fillColor: Colors.black45,
                              ),
                              onSubmitted: (command) {
                                _executeCommand(command);
                                commandController.clear();
                              },
                            ),
                            Flexible(
                              child: ListView.builder(
                                controller: logScrollController,
                                itemCount: logs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      logs[index],
                                      style: const TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Center(
                  child: CustomPaint(
                    size: Size(gridWidth, gridHeight),
                    painter: GridPainter(
                      gridSizeX,
                      gridSizeY,
                      cellSize,
                      grid,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              DropdownButton<String>(
                value: selectedAlgorithm,
                focusColor: Colors.black,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.w600),
                dropdownColor: Colors.black,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAlgorithm = newValue!;
                  });
                },
                items: algorithms.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
