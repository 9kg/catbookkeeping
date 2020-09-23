import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Toast {
  static final int LENGTH_SHORT = 1;
  static final int LENGTH_LONG = 2;
  static final int BOTTOM = 0;
  static final int CENTER = 1;
  static final int TOP = 2;

  static void show(String msg, BuildContext context,
      {int duration = 1,
        int gravity = 0,
        Color backgroundColor = const Color(0xAA000000),
        Color textColor = Colors.white,
        double backgroundRadius = 20,
        Border border}) {
    ToastView().dismiss();
    ToastView().createView(msg, context, duration, gravity, backgroundColor, textColor, backgroundRadius, border);
  }
}

class ToastView {
  static final ToastView _singleton = ToastView._internal();

  factory ToastView() {
    return _singleton;
  }

  ToastView._internal();

  static OverlayState overlayState;
  static OverlayEntry _overlayEntry;

  bool _isShowing = false;

  void createView(String msg, BuildContext context, int duration, int gravity, Color background, Color textColor,
      double backgroundRadius, Border border) {
    overlayState = Overlay.of(context);

    _isShowing = true;

    Paint paint = Paint();
    paint.strokeCap = StrokeCap.square;
    paint.color = background;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
          widget: Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(backgroundRadius),
                    border: border,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Text(msg,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400)),
                )),
          ),
          gravity: gravity),
    );
    overlayState.insert(_overlayEntry);
    Future.delayed(Duration(seconds: duration == null ? Toast.LENGTH_SHORT : duration)).then((v) {
      dismiss();
    });
  }

  void dismiss() {
    if (!_isShowing) return;

    _isShowing = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class ToastWidget extends StatelessWidget {
  ToastWidget({
    Key key,
    @required this.widget,
    @required this.gravity,
  }) : super(key: key);

  final Widget widget;
  final int gravity;

  @override
  Widget build(BuildContext context) {
    return Positioned(top: gravity == 2 ? 50 : null, bottom: gravity == 0 ? 50 : null, child: widget);
  }
}
