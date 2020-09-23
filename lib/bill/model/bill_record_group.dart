import 'package:flutter/material.dart';

//日记录
class BillRecordGroup {
  BillRecordGroup(this.date, this.totalExpenses, this.totalRevenue) : super();

  String date;

  // 当天总支出金额
  double totalExpenses;

  // 当日总收入
  double totalRevenue;
}

// 月记录
class BillRecordMonth {
  BillRecordMonth(this.totalExpenses, this.totalRevenue, this.recordList, {Key key, this.isBudget: 0, this.budget: 0.0})
      : super();

  // 当月总支出金额
  double totalExpenses;

  // 当月总收入
  double totalRevenue;

  // 是否有预算
  int isBudget;

  // 预算金额
  double budget;

  // 账单记录
  List recordList;
}
