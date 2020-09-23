import 'dart:convert';

import 'package:bookkeeping/hive/hive_box.dart';
import 'package:bookkeeping/hive/hive_manager.dart';
import 'package:hive/hive.dart';

class HiveSpBox extends HiveBox {
  @override
  Future open() async {
    box = await Hive.openBox("prefs", encryptionKey: HiveManager.encryptionKey);
  }

  /// put object.
  void putObject(String key, Object value) async {
    return box.put(key, value == null ? "" : json.encode(value));
  }

  /// get obj.
  T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  Map getObject(String key) {
    String _data = box.get(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  void putObjectList(String key, List<Object> list) {
    List<String> _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    box.put(key, _dataList);
  }

  /// get obj list.
  List<T> getObjList<T>(String key, T f(Map v), {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList.map((value) {
      return f(value);
    }).toList();
    return list ?? defValue;
  }

  /// get object list.
  List<Map> getObjectList(String key, {List<Map> defValue = const []}) {
    List<String> dataList = getStringList(key);
    return dataList?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  /// get string.
  String getString(String key, {String defValue = ''}) {
    return box.get(key) as String ?? defValue;
  }

  /// put string.
  void putString(String key, String value) {
    box.put(key, value);
  }

  /// get bool.
  bool getBool(String key, {bool defValue = false}) {
    return box.get(key) as bool ?? defValue;
  }

  /// put bool.
  void putBool(String key, bool value) {
    box.put(key, value);
  }

  /// get int.
  int getInt(String key, {int defValue = 0}) {
    return box.get(key) as int ?? defValue;
  }

  /// put int.
  void putInt(String key, int value) {
    box.put(key, value);
  }

  /// get double.
  double getDouble(String key, {double defValue = 0.0}) {
    return box.get(key) as double ?? defValue;
  }

  /// put double.
  void putDouble(String key, double value) {
    box.put(key, value);
  }

  /// get string list.
  List<String> getStringList(String key, {List<String> defValue = const []}) {
    return box.get(key) as List<String> ?? defValue;
  }

  /// put string list.
  void putStringList(String key, List<String> value) {
    box.put(key, value);
  }

  /// get dynamic.
  dynamic getDynamic(String key, {Object defValue}) {
    return box.get(key) ?? defValue;
  }

  /// have key.
  bool haveKey(String key) {
    return getKeys().contains(key);
  }

  /// get keys.
  Set<String> getKeys() {
    return box.keys;
  }

  /// remove.
  void remove(String key) {
    box.delete(key);
  }

  /// clear.
  void clear() {
    box.clear();
  }
}
