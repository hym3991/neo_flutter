import 'package:flutter/cupertino.dart';
import 'package:neo_flutter/bean/user_bean.dart';

class LoginViewModel extends ChangeNotifier{
  User _user;
  User get user => _user;
  set user(User value){
    _user = value;
    notifyListeners();
  }

  LoginViewModel(){
    ///构造时进行请求登录
    //login();
  }

  void login(){
    ///模拟请求登录接口
    Future.delayed(Duration(milliseconds: 500),(){
      ///登录完成后创建User对象并通知
      user = User()..age = 12..city = '上海'..name = '洪亚明';
    });
  }
}