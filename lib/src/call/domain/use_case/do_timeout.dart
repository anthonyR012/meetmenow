import 'dart:async';


class DoTimeOut {
  StreamController<double>? _controller;
  Timer? _timer;
  double _timeLeft = 600;

  Stream<double> call({required bool isRunning}) {
  
    if (isRunning) {
      _startTimer();
    } else {
      _stopTimer();
    }
    if(_controller == null) return Stream.value(_timeLeft);
    return _controller!.stream;
  }

  void _startTimer() {
    _controller ??= StreamController<double>.broadcast();
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft <= 0) {
        _controller?.add(0);
        _stopTimer();
      } else {
        _timeLeft -= 1;
        _controller?.add(_timeLeft);
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timeLeft = 600;
    _controller?.close();
    _controller = null;
  }
}