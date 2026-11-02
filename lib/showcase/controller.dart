import 'dart:async';

import 'package:flutter/foundation.dart';

import 'model.dart';

/// Step-driven playback state for the presentation.
///
/// Everything is derived from (demoIndex, stepIndex) so the presenter can scrub
/// to any beat and the live UI is always consistent with the notes panel.
class PresentationController extends ChangeNotifier {
  PresentationController({required this.demos, TimerFactory? timerFactory})
      : _timerFactory = timerFactory ?? _wallClock {
    _schedule();
  }

  static Timer _wallClock(int ms, void Function() cb) =>
      Timer(Duration(milliseconds: ms), cb);

  final List<DemoSpec> demos;
  final TimerFactory _timerFactory;

  Timer? _timer;
  int _demoIndex = 0;
  int _stepIndex = 0;
  bool _playing = false;
  double _speed = 1;
  bool _showNotes = true;
  bool _showAnnotations = true;

  int get demoIndex => _demoIndex;
  int get stepIndex => _stepIndex;
  bool get playing => _playing;
  double get speed => _speed;
  bool get showNotes => _showNotes;
  bool get showAnnotations => _showAnnotations;

  DemoSpec get demo => demos[_demoIndex];
  DemoStep get step => demo.steps[_stepIndex];
  bool get isFirstDemo => _demoIndex == 0;
  bool get isLastDemo => _demoIndex == demos.length - 1;
  bool get isLastStep => _stepIndex == demo.steps.length - 1;

  /// Progress through the current demo, 0..1, used by the HUD rail.
  double get demoProgress => (_stepIndex + 1) / demo.steps.length;

  void play() {
    if (_playing) return;
    _playing = true;
    _schedule();
    notifyListeners();
  }

  void pause() {
    if (!_playing) return;
    _playing = false;
    _cancel();
    notifyListeners();
  }

  void togglePlay() => _playing ? pause() : play();

  void setSpeed(double value) {
    _speed = value.clamp(0.5, 3.0).toDouble();
    _schedule();
    notifyListeners();
  }

  void cycleSpeed() {
    const stops = [0.5, 1.0, 1.5, 2.0];
    final index = stops.indexOf(_speed);
    setSpeed(stops[(index + 1) % stops.length]);
  }

  void toggleNotes() {
    _showNotes = !_showNotes;
    notifyListeners();
  }

  void toggleAnnotations() {
    _showAnnotations = !_showAnnotations;
    notifyListeners();
  }

  void next() {
    if (isLastStep) {
      if (isLastDemo) {
        pause();
        return;
      }
      _demoIndex += 1;
      _stepIndex = 0;
    } else {
      _stepIndex += 1;
    }
    _schedule();
    notifyListeners();
  }

  void prev() {
    if (_stepIndex > 0) {
      _stepIndex -= 1;
    } else if (_demoIndex > 0) {
      _demoIndex -= 1;
      _stepIndex = demos[_demoIndex].steps.length - 1;
    }
    _schedule();
    notifyListeners();
  }

  void goToDemo(int index, {int step = 0}) {
    _demoIndex = index.clamp(0, demos.length - 1);
    _stepIndex = step.clamp(0, demos[_demoIndex].steps.length - 1);
    _schedule();
    notifyListeners();
  }

  void nextDemo() {
    if (isLastDemo) {
      goToDemo(0);
      return;
    }
    goToDemo(_demoIndex + 1);
  }

  void prevDemo() {
    if (isFirstDemo) {
      goToDemo(demos.length - 1);
      return;
    }
    goToDemo(_demoIndex - 1);
  }

  void restart() {
    _demoIndex = 0;
    _stepIndex = 0;
    _schedule();
    notifyListeners();
  }

  Duration get remainingHold => Duration(
        milliseconds: (step.hold.inMilliseconds / _speed).round(),
      );

  void _schedule() {
    _cancel();
    if (!_playing) return;
    final ms = remainingHold.inMilliseconds;
    _timer = _timerFactory(ms, _onTick);
  }

  void _onTick() {
    if (!_playing) return;
    next();
  }

  void _cancel() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }
}

/// Injectable so tests can drive the clock without waiting real seconds.
typedef TimerFactory = Timer Function(int ms, void Function() callback);
