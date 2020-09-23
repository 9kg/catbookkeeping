import 'dart:io';
import 'package:bookkeeping/common/app_def/strings.dart';
import 'package:bookkeeping/hive/hive_manager.dart';
import 'package:bookkeeping/main/main_model.dart';
import 'package:bookkeeping/main/main_page.dart';
import 'package:bookkeeping/common/app_def/colours.dart';
import 'package:bookkeeping/routers/application.dart';
import 'package:bookkeeping/routers/routers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{
  // await HiveManager().init();
  //透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  GlobalKey<MyAppState> appKey = GlobalKey();
  gMainModel.mainKey = appKey;
  runApp(MyApp(appKey));
}

class MyApp extends StatefulWidget {
  MyApp(Key key) : super(key: key) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colours.app_main,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(),
          cupertinoOverrideTheme: CupertinoThemeData(
            brightness: Brightness.dark,
            primaryContrastingColor: Colors.white,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            barBackgroundColor: Colours.app_main,
          )),
      home: MainPage(),
    );
  }
}
