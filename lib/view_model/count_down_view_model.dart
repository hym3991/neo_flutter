import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:neo_flutter/base/neo_base_provider_widget.dart';

class CountDownViewModel extends BaseViewModel{
  Timer _timer;

  bool _isAlive;
  bool get isAlive => _isAlive;
  set isAlive(bool value){
    _isAlive = value;
    isLiveOrEnd = _isAlive;
    notifyListeners();
  }

  bool _isLiveOrEnd;
  bool get isLiveOrEnd => _isLiveOrEnd;
  set isLiveOrEnd(bool value){
    if(_isLiveOrEnd != value){
      _isLiveOrEnd = value;
      notifyListeners();
    }
  }

  ///这样其实没必要notifyListeners
  // String _hour = '0';
  // String get hour => _hour;
  // set hour(String value){
  //   _hour = value;
  //   notifyListeners();
  // }
  String hour = '0';
  ///这样其实没必要notifyListeners
  //String _minute = '0';
  // String get minute => _minute;
  // set minute(String value){
  //   _minute = value;
  //   notifyListeners();
  // }
  String minute = '0';
  ///这样其实没必要notifyListeners
  //String _second = '0';
  // String get second => _second;
  // set second(String value){
  //   _second = value;
  //   notifyListeners();
  // }
  String second = '0';
  int awayFromEnd;

  CountDownViewModel({this.awayFromEnd}){
    _isAlive = false;
    _isLiveOrEnd = false;
    if(awayFromEnd != null && awayFromEnd > 0){
      startTimer(awayFromEnd);
    }
  }

  void startTimer(int awayFromEnd){
    this.awayFromEnd = awayFromEnd;
    ///开始倒计时 awayEnd 单位秒 并每秒进行通知
    if(this.awayFromEnd <= 0){
      isAlive = false;
      return;
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(this.awayFromEnd <= 0){
        isAlive = false;
        timer.cancel();
      }else{
        if(_timer.isActive){
          this.awayFromEnd--;
          updateTimeText();
          isAlive = true;
        }
      }
    });
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer.cancel();
    }
    isAlive = false;
    super.dispose();
  }
  void updateTimeText(){
    final int t = awayFromEnd;
    final int h = t ~/ 3600;
    final int m = t % 3600 ~/ 60;
    final int s = (t % 60).toInt();

    if (h / 10 == 0) {
      hour = '0$h';
    } else {
      hour = '$h';
    }
    if (m / 10 == 0) {
      minute = '0$m';
    } else {
      minute = '$m';
    }
    if (s / 10 == 0) {
      second = '0$s';
    } else {
      second = '$s';
    }
  }
}