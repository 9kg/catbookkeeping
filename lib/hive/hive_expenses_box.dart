import 'package:bookkeeping/hive/hive_box.dart';
import 'package:bookkeeping/hive/hive_manager.dart';
import 'package:hive/hive.dart';

class HiveExpensesBox extends HiveBox {
  @override
  Future open() async {
    box = await Hive.openBox("expenses", encryptionKey: HiveManager.encryptionKey);
  }
}
