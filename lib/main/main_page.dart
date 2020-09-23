import 'package:bookkeeping/bill/page/bill_list_page.dart';
import 'package:bookkeeping/bill/page/bill_router.dart';
import 'package:bookkeeping/charts/charts_page.dart';
import 'package:bookkeeping/common/app_def/colours.dart';
import 'package:bookkeeping/common/app_def/strings.dart';
import 'package:bookkeeping/common/util/utils.dart';
import 'package:bookkeeping/routers/fluro_navigator.dart';
import 'package:bookkeeping/widgets/highlight_well.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final _pageController = PageController();

  final _pages = [BillListPage(), Charts()];

  DateTime _lastTime;

  Future<bool> _isExit() {
    if (_lastTime == null || DateTime.now().difference(_lastTime) > Duration(milliseconds: 2500)) {
      _lastTime = DateTime.now();
      Utils.show(Strings.clickAgainToExitApp);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExit,
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildBottomItem(0, Strings.bill, Icons.description),
                _buildBottomItem(-1, Strings.bookkeeping, null),
                _buildBottomItem(1, Strings.statistics, Icons.pie_chart),
              ],
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _pages,
            physics: defaultTargetPlatform == TargetPlatform.iOS
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(), // 禁止滑动
          ),
        ),
      ),
    );
  }

  void onTap(int index) {
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _buildBottomItem(int index, String title, IconData data) {
    //未选中样式
    TextStyle textStyle = TextStyle(fontSize: 12.0, color: Colours.gray);
    TextStyle selectedTextStyle = TextStyle(fontSize: 12.0, color: Colours.black);
    Color iconColor = Colours.gray;
    Color selectedIconColor = Colours.black;
    double iconSize = 25;

    return data != null
        ? Expanded(
            flex: 1,
            child: HighLightWell(
              isPressingEffect: false,
              onTap: () {
                if (index != _currentIndex) {
                  onTap(index);
                }
              },
              child: Container(
                height: 49,
                padding: const EdgeInsets.only(top: 5.5),
                child: Column(
                  children: <Widget>[
                    Icon(data, size: iconSize, color: _currentIndex == index ? selectedIconColor : iconColor),
                    Text(title, style: _currentIndex == index ? selectedTextStyle : textStyle)
                  ],
                ),
              ),
            ),
          )
        : Expanded(
            flex: 1,
            child: Container(
              height: 49,
              child: OverflowBox(
                minHeight: 49,
                maxHeight: 80,
                child: HighLightWell(
                  onTap: () {
                    NavigatorUtils.push(context, BillRouter.bookkeepingPage,
                        transitionType: TransitionType.cupertinoFullScreenDialog);
                  },
                  isPressingEffect: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48 / 2),
                            border: Border.all(width: 2, color: Colors.white),
                            boxShadow: [
                              BoxShadow(color: Colours.line, blurRadius: 0, offset: Offset(0, -1)),
                            ],
                          ),
                          child: HighLightWell(
                            onTap: () {
                              NavigatorUtils.push(context, BillRouter.bookkeepingPage,
                                  transitionType: TransitionType.cupertinoFullScreenDialog);
                            },
                            isForeground: true,
                            borderRadius: BorderRadius.circular(48 / 2),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: CircleAvatar(
                                backgroundColor: Colours.app_main,
                                child: const Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(bottom: 17, child: Text(title, style: textStyle))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
