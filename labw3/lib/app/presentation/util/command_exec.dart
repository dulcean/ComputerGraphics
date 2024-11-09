import 'package:labw3/app/presentation/algo/bresenham_circle.dart';
import 'package:labw3/app/presentation/algo/bresenham_line.dart';
import 'package:labw3/app/presentation/algo/castel.dart';
import 'package:labw3/app/presentation/algo/dda.dart';
import 'package:labw3/app/presentation/algo/step_by_step.dart';
import 'package:labw3/app/presentation/algo/wu.dart';

void executeCommand(String command, List<String> logs, Function setState) {
  switch (command) {
    case 'clear':
      setState(() {
        logs.clear();
      });
      break;

    case 'help':
      setState(() {
        logs.add('Доступные команды:');
        logs.add('clear - очистить логи');
        logs.add('test bresenham - тест алгоритма Брезенхема для линии');
        logs.add('test sbs - тест пошагового алгоритма');
        logs.add('test dda - тест алгоритма ЦДА');
        logs.add('test circle - тест алгоритма окружности Брезенхема');
        logs.add('test line - тест алгоритма линии Брезенхема');
        logs.add('test casteljau - тест алгоритма Кастельжо');
        logs.add('test wu-line - тест алгоритма Ву для линии');
      });
      break;

    case 'test bresenham':
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        BresenhamLine.bresenhamLine(0, 0, 99000, 99000, (logMessage) {});
      }
      stopwatch.stop();
      setState(() {
        logs.add(
            '[BRESENHAM LINE] BRESENHAM-LINE:TEST закончил работу AV_SCORE = ${stopwatch.elapsedMicroseconds / 100} mcs');
      });
      break;

    case 'test sbs':
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        StepByStepLine.stepByStepLine(0, 0, 99000, 99000, (logMessage) {});
      }
      stopwatch.stop();
      setState(() {
        logs.add(
            '[STEPBYSTEP] SBS:TEST закончил работу AV_SCORE = ${stopwatch.elapsedMicroseconds / 100} mcs');
      });
      break;

    case 'test dda':
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        DdaLine.ddaLine(0, 0, 99000, 99000, (logMessage) {});
      }
      stopwatch.stop();
      setState(() {
        logs.add(
            '[DDA] DDA:TEST закончил работу AV_SCORE = ${stopwatch.elapsedMicroseconds / 100} mcs');
      });
      break;

    case 'test circle':
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        BresenhamCircle.bresenhamCircle(0, 0, 99000, (logMessage) {});
      }
      stopwatch.stop();
      setState(() {
        logs.add(
            '[BRESENHAM CIRCLE] CIRCLE:TEST закончил работу AV_SCORE = ${stopwatch.elapsedMicroseconds / 100} mcs');
      });
      break;

    case 'test line':
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        BresenhamLine.bresenhamLine(0, 0, 99000, 50000, (logMessage) {});
      }
      stopwatch.stop();
      setState(() {
        logs.add(
            '[BRESENHAM LINE] LINE:TEST закончил работу AV_SCORE = ${stopwatch.elapsedMicroseconds / 100} mcs');
      });
      break;

    case 'test casteljau':
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        CasteljauAlgorithm.casteljau(0, 0, 99000, 50000, 1000, (logMessage) {});
      }
      stopwatch.stop();
      setState(() {
        logs.add(
            '[CASTELJAU] LINE:TEST закончил работу AV_SCORE = ${stopwatch.elapsedMicroseconds / 100} mcs');
      });
      break;

    case 'test wu-line':
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < 100; i++) {
        WuLine.wuLine(0, 0, 99000, 50000, (logMessage) {});
      }
      stopwatch.stop();
      setState(() {
        logs.add(
            '[WU LINE] LINE:TEST закончил работу AV_SCORE = ${stopwatch.elapsedMicroseconds / 100} mcs');
      });
      break;

    default:
      setState(() {
        logs.add('Неизвестная команда: $command');
      });
      break;
  }
}
