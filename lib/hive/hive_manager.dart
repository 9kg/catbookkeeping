import 'dart:convert';
import 'dart:io';

import 'package:bookkeeping/bill/model/category_model.dart';
import 'package:bookkeeping/common/log.dart';
import 'package:bookkeeping/hive/hive_expenses_box.dart';
import 'package:bookkeeping/hive/hive_revenue_box.dart';
import 'package:bookkeeping/hive/hive_sp_box.dart';
import 'package:bookkeeping/hive/hive_sp_key.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  static List<int> encryptionKey = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    111,
    112,
    113,
    114,
    115,
    116,
    117,
    118,
    119,
    1,
    2,
    3,
    4,
    5
  ];

  static final HiveManager _instance = HiveManager._internal();

  factory HiveManager() => _instance;

  HiveManager._internal();

  HiveSpBox spBox = HiveSpBox();
  HiveExpensesBox expensesBox = HiveExpensesBox();
  HiveRevenueBox revenueBox = HiveRevenueBox();

  Future init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "hiveCat");

    await Hive.initFlutter(path);

    await spBox.open();
    await expensesBox.open();
    await revenueBox.open();
    _initLocalJson();

    Log.out(Log.tagHive, "HiveCatManager init");
  }

  void _initLocalJson() {
    if (spBox.getBool(HiveSpKey.isLoadLocalJson)) {
      return;
    }
    // 初始化支出类别表数据
    rootBundle.loadString('assets/expenses_category.json').then((value) {
      List list = jsonDecode(value);
      List<CategoryItem> models = list.map((i) => CategoryItem.fromJson(i)).toList();
      models.forEach((item) async {
        expensesBox.putObject(item.name, item.toJson());
      });
    });

    // 初始化收入类别表数据
    rootBundle.loadString('assets/revenue_category.json').then((value) {
      List list = jsonDecode(value);
      List<CategoryItem> models = list.map((i) => CategoryItem.fromJson(i)).toList();
      models.forEach((item) async {
        revenueBox.putObject(item.name, item.toJson());
      });
    });
    spBox.putBool(HiveSpKey.isLoadLocalJson, true);
  }
}
