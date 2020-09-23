import 'package:bookkeeping/routers/routers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'application.dart';

class NavigatorUtils {
  // 普通跳转
  static push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false, TransitionType transitionType = TransitionType.native}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Application.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: transitionType);
  }

  // 跳转带返回结果
  static pushResult(BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Application.router
        .navigateTo(context, path, replace: replace, clearStack: clearStack, transition: TransitionType.native)
        .then((result) {
      if (result == null) return;
      function(result);
    }).catchError((error) {
      print('$error');
    });
  }

  static void goBack(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context);
  }

  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context, result);
  }

  static goWebViewPage(BuildContext context, String title, String url) {
    push(context, '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  }
}
