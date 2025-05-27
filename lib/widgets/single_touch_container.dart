import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// ref: https://stackoverflow.com/a/56037327/5669278
class SingleTouchContainer extends StatelessWidget {
  const SingleTouchContainer({
    super.key,
    required this.child,
    this.isEnabled = true,
  });

  final Widget child;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) {
      return child;
    }
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        _SingleTouchRecognizer: GestureRecognizerFactoryWithHandlers<_SingleTouchRecognizer>(
          _SingleTouchRecognizer.new,
          (_) {},
        ),
      },
      child: child,
    );
  }
}

class _SingleTouchRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'single touch recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}
