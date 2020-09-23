import 'package:bookkeeping/hive/hive_box.dart';
import 'package:bookkeeping/hive/hive_manager.dart';
import 'package:hive/hive.dart';

class HiveSpBox extends HiveBox {
  @override
  Future open() async {
    box = await Hive.openBox("prefs", encryptionKey: HiveManager.encryptionKey);
  }
}
