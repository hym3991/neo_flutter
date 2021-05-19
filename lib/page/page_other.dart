import 'package:flutter/material.dart';
import 'package:neo_flutter/page/page_1.dart';
import 'package:neo_flutter/view_model/count_down_view_model.dart';
import 'package:neo_flutter/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

class PageOther extends StatefulWidget {

  final int awayFromEnd;
  PageOther({this.awayFromEnd});

  @override
  _PageOtherState createState() => _PageOtherState();
}

class _PageOtherState extends State<PageOther> {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<CountDownViewModel>(
      create: (_) => CountDownViewModel(awayFromEnd: widget.awayFromEnd),
      builder: (_,Widget child){
        return SafeArea(
            child: Scaffold(
              body: Container(
                child: Column(
                  children: [
                    Consumer<LoginViewModel>(
                      builder: (BuildContext context,LoginViewModel model,Widget child){
                        print('登录Consumer builder');
                        ///已经登录后显示的用户widget
                        return UserWidget(user: model.user);
                      },
                    ),
                    Consumer<CountDownViewModel>(
                      builder: (_,CountDownViewModel model,Widget child){
                        print('Consumer builder');
                        return Text(model.isAlive?'剩余 ${model.hour}小时 ${model.minute}分钟 ${model.second}秒':'倒计时结束了',style: TextStyle(fontSize: 30));
                      },
                    ),
                  ],
                ),
              ),
            )
        );
      },
    );
  }
}
