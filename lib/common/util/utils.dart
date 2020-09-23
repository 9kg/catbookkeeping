import 'package:bookkeeping/common/app_def/strings.dart';
import 'package:bookkeeping/common/util/toast.dart';
import 'package:bookkeeping/main/main_model.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class Utils {
  static String getImagePath(String name, {String format: 'png'}) {
    return 'images/$name.$format';
  }

  static KeyboardActionsConfig getKeyboardActionsConfig(List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: List.generate(
          list.length,
          (i) => KeyboardAction(
                focusNode: list[i],
                closeWidget: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(Strings.close),
                ),
              )),
    );
  }

  static String formatDouble(double toFormat) {
    return (toFormat * 10) % 10 != 0 ? "$toFormat" : "${toFormat.toInt()}";
  }

  static show(String msg, [BuildContext context, int duration = 2]) {
    Toast.show(msg, context ?? gMainModel.curBuildContext, duration: duration, gravity: 1);
  }

  static int getDaysNum(int year, int month) {
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
      return 31;
    } else if (month == 2) {
      if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
        //闰年 2月29
        return 29;
      } else {
        //平年 2月28
        return 28;
      }
    } else {
      return 30;
    }
  }
}
