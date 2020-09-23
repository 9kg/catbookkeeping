import 'package:bookkeeping/common/app_def/colours.dart';
import 'package:bookkeeping/common/app_def/font.dart';
import 'package:bookkeeping/common/app_def/images.dart';
import 'package:bookkeeping/common/app_def/strings.dart';
import 'package:bookkeeping/common/app_def/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StateLayout extends StatefulWidget {
  const StateLayout({Key key, this.image: Images.emptyIcon, this.hintText: Strings.noData, this.isLoading: false})
      : super(key: key);
  final String image;
  final String hintText;
  final bool isLoading;

  @override
  _StateLayoutState createState() => _StateLayoutState();
}

class _StateLayoutState extends State<StateLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.isLoading
              ? SpinKitPouringHourglass(color: Color(0xFF333333))
              : (widget.image.isEmpty ? Gaps.empty : Image.asset(widget.image, width: 120)),
          Gaps.vGap(16),
          widget.hintText.isEmpty
              ? Gaps.empty
              : Text(
                  widget.hintText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Font.font_sp14, color: Colours.gray),
                  maxLines: 5,
                ),
          Gaps.vGap(30),
        ],
      ),
    );
  }
}
