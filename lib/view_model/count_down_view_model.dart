import 'dart:async';

import 'package:flutter/cupertino.dart';

class CountDownViewModel extends ChangeNotifier{

  bool _isAlive;
  bool get isAlive => _isAlive;
  set isAlive(bool value){
    isAlive = value;
    notifyListeners();
  }

  int hour;
  int minutes;
  int second;

  int awayEnd;
  CountDownViewModel({this.awayEnd}){
    ///开始倒计时 awayEnd 单位秒 并每秒进行通知
    Timer.periodic(Duration(seconds: 1), (timer) {
      awayEnd--;
      if(awayEnd == 0){
        isAlive = false;
        timer.cancel();
      }else{
        isAlive = true;
      }
    });
  }
}