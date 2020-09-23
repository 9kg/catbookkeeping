import 'package:bookkeeping/common/app_def/strings.dart';
import 'package:bookkeeping/widgets/state_layout.dart';
import 'package:flutter/material.dart';

class WidgetNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StateLayout(hintText: Strings.pageDoesNotExist),
    );
  }
}
