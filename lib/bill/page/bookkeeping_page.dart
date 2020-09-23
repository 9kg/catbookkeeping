import 'package:bookkeeping/bill/model/bill_record_response.dart';
import 'package:bookkeeping/bill/model/category_model.dart';
import 'package:bookkeeping/common/app_def/strings.dart';
import 'package:bookkeeping/common/eventBus.dart';
import 'package:bookkeeping/db/db_helper.dart';
import 'package:bookkeeping/common/app_def//colours.dart';
import 'package:bookkeeping/common/app_def//styles.dart';
import 'package:bookkeeping/routers/fluro_navigator.dart';
import 'package:bookkeeping/common/util/utils.dart';
import 'package:bookkeeping/widgets/app_bar.dart';
import 'package:bookkeeping/widgets/highlight_well.dart';
import 'package:bookkeeping/widgets/input_textview_dialog.dart';
import 'package:bookkeeping/widgets/number_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bookkeeping extends StatefulWidget {
  const Bookkeeping({Key key, this.recordModel}) : super(key: key);
  final BillRecordModel recordModel;

  @override
  State<StatefulWidget> createState() => _BookkeepingState();
}

class _BookkeepingState extends State<Bookkeeping> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _tapItemController;
  String _remark = '';
  DateTime _time;
  String _dateString = '';
  String _numberString = '';
  bool _isAdd = false;

  List<CategoryItem> _expensesObjects = List();

  List<CategoryItem> _revenueObjects = List();

  TabController _tabController;

  final List<Tab> tabs = <Tab>[Tab(text: Strings.expenses), Tab(text: Strings.revenue)];

  Future<void> _loadExpensesData() async {
    dbHelp.getInitialExpenCategory().then((list) {
      List<CategoryItem> models = list.map((i) => CategoryItem.fromJson(i)).toList();
      if (_expensesObjects.length > 0) {
        _expensesObjects.removeRange(0, _expensesObjects.length);
      }
      _expensesObjects.addAll(models);

      if (widget.recordModel != null && widget.recordModel.type == 1) {
        _selectedIndexLeft = _expensesObjects.indexWhere((item) => item.name == widget.recordModel.categoryName);
      }

      setState(() {});
    });
  }

  Future<void> _loadRevenueData() async {
    dbHelp.getInitialIncomeCategory().then((list) {
      List<CategoryItem> models = list.map((i) => CategoryItem.fromJson(i)).toList();
      if (_revenueObjects.length > 0) {
        _revenueObjects.removeRange(0, _revenueObjects.length);
      }
      _revenueObjects.addAll(models);

      if (widget.recordModel != null && widget.recordModel.type == 2) {
        _selectedIndexRight = _revenueObjects.indexWhere((item) => item.name == widget.recordModel.categoryName);
      }

      setState(() {});
    });
  }

  void _updateInitData() {
    if (widget.recordModel != null) {
      _time = DateTime.fromMillisecondsSinceEpoch(widget.recordModel.updateTimestamp);
      DateTime now = DateTime.now();
      if (_time.year == now.year && _time.month == now.month && _time.day == now.day) {
        _dateString = '${Strings.today} ${_time.hour}:${_time.minute}';
      } else if (_time.year != now.year) {
        _dateString =
            '${_time.year}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
      } else {
        _dateString =
            '${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
      }

      if (widget.recordModel.remark.isNotEmpty) {
        _remark = widget.recordModel.remark;
      }

      if (widget.recordModel.money != null) {
        _numberString = Utils.formatDouble(double.parse(_numberString = widget.recordModel.money.toStringAsFixed(2)));
      }

      if (widget.recordModel.type == 2) {
        _tabController.index = 1;
      }
    } else {
      _time = DateTime.now();
      _dateString = '${Strings.today} ${_time.hour}:${_time.minute}';
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();

    _tapItemController = AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _tapItemController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _tapItemController.stop();
        }
      });

    _updateInitData();
    _loadExpensesData();
    _loadRevenueData();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    _tapItemController.stop();
    _tapItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        // centerTitle: true,
        titleWidget: TabBar(
          controller: _tabController,
          tabs: tabs,
          indicatorColor: Colours.app_main,
          unselectedLabelColor: Colours.app_main.withOpacity(0.8),
          labelColor: Colours.app_main,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          indicatorWeight: 1,
          isScrollable: true, // 是否可以滑动
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
          child: Icon(Icons.close, color: Colours.app_main),
          onPressed: () {
            NavigatorUtils.goBack(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false, // 默认true键盘弹起不遮挡
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildExpendCategory(),
                _buildIncomeCategory(),
              ],
            ),
          ),
          HighLightWell(
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return TextViewDialog(
                      confirm: (text) {
                        setState(() {
                          _remark = text;
                        });
                      },
                    );
                  });
            },
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  alignment: Alignment.center,
                  height: 44,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _remark.isEmpty ? Strings.remarksHint : _remark,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(28),
                              color: _remark.isEmpty ? Colours.gray : Colours.black),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Gaps.vGap(3),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: HighLightWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        theme: DatePickerTheme(
                            doneStyle: TextStyle(fontSize: 16, color: Colours.app_main),
                            cancelStyle: TextStyle(fontSize: 16, color: Colours.gray)),
                        locale: LocaleType.zh, onConfirm: (date) {
                      _time = date;
                      DateTime now = DateTime.now();
                      if (_time.year == now.year && _time.month == now.month && _time.day == now.day) {
                        _dateString = '${Strings.today} ${_time.hour}:${_time.minute}';
                      } else if (_time.year != now.year) {
                        _dateString =
                            '${_time.year}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
                      } else {
                        _dateString =
                            '${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
                      }
                      setState(() {});
                    });
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15), border: Border.all(color: Colours.gray, width: 0.6)),
                    child: Text(_dateString),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _numberString.isEmpty ? '0.0' : _numberString,
                    style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(48),
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget child) {
                  return Container(
                    margin: const EdgeInsets.only(right: 14),
                    width: 2,
                    height: ScreenUtil.getInstance().setSp(40),
                    decoration: BoxDecoration(color: Colours.app_main.withOpacity(0.8 * _animationController.value)),
                  );
                },
              ),
            ],
          ),
          Gaps.vGap(10),
          Gaps.vGapLine(gap: 0.3),
          MyKeyBoard(
            isAdd: _isAdd,
            numberCallback: (number) => inputVerifyNumber(number),
            deleteCallback: () {
              if (_numberString.length > 0) {
                setState(() {
                  _numberString = _numberString.substring(0, _numberString.length - 1);
                });
              }
            },
            clearZeroCallback: () {
              _clearZero();
            },
            equalCallback: () {
              setState(() {
                _addNumber();
              });
            },
            nextCallback: () {
              if (_isAdd == true) {
                _addNumber();
              }
              _record();
              _clearZero();
              setState(() {});
            },
            saveCallback: () {
              _record();
              NavigatorUtils.goBack(context);
            },
          ),
          MediaQuery.of(context).padding.bottom > 0 ? Gaps.vGapLine(gap: 0.3) : Gaps.empty,
        ],
      ),
    );
  }

  void _addNumber() {
    _isAdd = false;
    List<String> numbers = _numberString.split('+');
    double number = 0.0;
    for (String item in numbers) {
      if (item.isEmpty == false) {
        number += double.parse(item);
      }
    }
    String numberString = number.toString();
    if (numberString.split('.').last == '0') {
      numberString = numberString.substring(0, numberString.length - 2);
    }
    _numberString = numberString;
  }

  void _record() {
    if (_numberString.isEmpty || _numberString == '0.') {
      return;
    }

    _isAdd = false;
    CategoryItem item;
    if (_tabController.index == 0) {
      item = _expensesObjects[_selectedIndexLeft];
    } else {
      item = _revenueObjects[_selectedIndexRight];
    }

    BillRecordModel model = BillRecordModel(
        widget.recordModel != null ? widget.recordModel.id : null,
        double.parse(_numberString),
        _remark,
        _tabController.index + 1,
        item.name,
        item.image,
        DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch).toString(),
        _time.millisecondsSinceEpoch,
        DateTime.fromMillisecondsSinceEpoch(_time.millisecondsSinceEpoch).toString(),
        _time.millisecondsSinceEpoch);

    dbHelp.insertBillRecord(model).then((value) {
      bus.trigger(bus.bookkeepingEventName);
    });
  }

  void _clearZero() {
    setState(() {
      _isAdd = false;
      _numberString = '';
    });
  }

  int _selectedIndexLeft = 0;

  Widget _buildExpendCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GridView.builder(
        key: PageStorageKey<String>("0"),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, childAspectRatio: 1, mainAxisSpacing: 0, crossAxisSpacing: 8),
        itemCount: _expensesObjects.length,
        itemBuilder: (context, index) {
          return _getCategoryItem(_expensesObjects[index], index, _selectedIndexLeft);
        },
      ),
    );
  }

  int _selectedIndexRight = 0;

  _buildIncomeCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GridView.builder(
        key: PageStorageKey<String>("1"),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, childAspectRatio: 1, mainAxisSpacing: 0, crossAxisSpacing: 8),
        itemCount: _revenueObjects.length,
        itemBuilder: (context, index) {
          return _getCategoryItem(_revenueObjects[index], index, _selectedIndexRight);
        },
      ),
    );
  }

  Widget _getCategoryItem(CategoryItem item, int index, selectedIndex) {
    return GestureDetector(
      onTap: () {
        if (_tabController.index == 0) {
          //左边支出类别
          if (_selectedIndexLeft != index) {
            _selectedIndexLeft = index;
            _tapItemController.forward();
            setState(() {});
          }
        } else {
          //右边收入类别
          if (_selectedIndexRight != index) {
            _selectedIndexRight = index;
            _tapItemController.forward();
            setState(() {});
          }
        }
      },
      child: AnimatedBuilder(
        animation: _tapItemController,
        builder: (BuildContext context, Widget child) {
          return ClipOval(
            child: Container(
              color: selectedIndex == index ? Colours.app_main : Colors.white,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Utils.getImagePath('${item.image}'),
                    width: selectedIndex == index
                        ? ScreenUtil.getInstance().setWidth(60 + _tapItemController.value * 6)
                        : ScreenUtil.getInstance().setWidth(50),
                    color: selectedIndex == index ? Colors.white : Colors.black,
                  ),
                  Gaps.vGap(3),
                  Text(
                    item.name,
                    style: TextStyle(
                        color: selectedIndex == index ? Colors.white : Colours.black,
                        fontSize: selectedIndex == index
                            ? ScreenUtil.getInstance().setSp(25 + 3 * _tapItemController.value)
                            : ScreenUtil.getInstance().setSp(25)),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 键盘输入验证
  void inputVerifyNumber(String number) {
    //小数点精确分，否则不能输入
    //加法
    if (_numberString.isEmpty) {
      //没输入的时候，不能输入+或者.
      if (number == '+') {
        return;
      }

      if (number == '.') {
        setState(() {
          _numberString += '0.';
        });
        return;
      }

      setState(() {
        _numberString += number;
      });
    } else {
      List<String> numbers = _numberString.split('');
      if (numbers.length == 1) {
        // 当只有一个数字
        if (numbers.first == '0') {
          //如果第一个数字是0，那么输入其他数字和+不生效
          if (number == '.') {
            setState(() {
              _numberString += number;
            });
          } else if (number != '+') {
            setState(() {
              _numberString = number;
            });
          }
        } else {
          //第一个数字不是0 为1-9
          setState(() {
            if (number == '+') {
              _isAdd = true;
            }
            _numberString += number;
          });
        }
      } else {
        List<String> temps = _numberString.split('+');
        if (temps.last.isEmpty && number == '+') {
          //加号
          return;
        }

        //拿到最后一个数字
        String lastNumber = temps.last;
        List<String> lastNumbers = lastNumber.split('.');
        if (lastNumbers.last.isEmpty && number == '.') {
          return;
        }
        if (lastNumbers.length > 1 && lastNumbers.last.length >= 2 && number != '+') {
          return;
        }

        setState(() {
          if (number == '+') {
            _isAdd = true;
          }
          _numberString += number;
        });
      }
    }
  }
}
