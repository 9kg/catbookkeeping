import 'package:bookkeeping/bill/page/bill_list_page.dart';
import 'package:bookkeeping/bill/page/bookkeeping_page.dart';
import 'package:bookkeeping/routers/router_init.dart';
import 'package:fluro/fluro.dart';

class BillRouter implements IRouterProvider {
  static String billPage = '/billPage';
  static String bookkeepingPage = '/bill/bookkeep';

  @override
  void initRouter(Router router) {
    router.define(billPage, handler: Handler(handlerFunc: (_,params) => BillListPage()));
    router.define(bookkeepingPage, handler: Handler(handlerFunc: (_,params) => Bookkeeping()));
  }
}
