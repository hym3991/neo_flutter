import 'package:flutter/cupertino.dart';
import 'package:neo_flutter/bean/page_bean.dart';

class PageViewModel extends ChangeNotifier{
  PageBean _bean;
  PageBean get bean => _bean;
  set bean(PageBean value){
    _bean = value;
    notifyListeners();
  }

  PageViewModel(){
    ///构造时进行网络请求数据
    requestData();
  }

  void requestData(){
    Future.delayed(Duration(seconds: 2),(){
      bean = PageBean()..awayFromEnd = 5000..price = 10000..desc = '宝马汽车';
    });
  }
}