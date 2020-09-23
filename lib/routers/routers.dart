import 'package:bookkeeping/bill/page/bill_router.dart';
import 'package:bookkeeping/routers/router_init.dart';
import 'package:bookkeeping/widgets/404.dart';
import 'package:bookkeeping/widgets/webview_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static String webViewPage = '/webView';
  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return WidgetNotFound();
    });

    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
      String title = params['title']?.first;
      String url = params['url']?.first;
      return WebViewPage(title: title, url: url);
    }));

    _listRouter.clear();
    _listRouter.add(BillRouter());

    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}
