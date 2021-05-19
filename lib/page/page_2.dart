
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_flutter/page/page_1.dart';
import 'package:neo_flutter/view_model/count_down_view_model.dart';
import 'package:neo_flutter/view_model/login_view_model.dart';
import 'package:neo_flutter/view_model/page_view_model.dart';
import 'package:provider/provider.dart';

class NeoPage2 extends StatefulWidget {
  @override
  _NeoPage2State createState() => _NeoPage2State();
}

class _NeoPage2State extends State<NeoPage2> {
  @override
  Widget build(BuildContext context) {
    print('_NeoPage2State build');
    ///需要使用PageViewModel的状态获取页面里的数据
    return ChangeNotifierProvider(
        create: (_) => PageViewModel(),
        builder: (BuildContext context,Widget child){
          print('_NeoPage2State ChangeNotifierProvider build');
          return SafeArea(
              ///区分是否有页面数据
              child: Scaffold(
                  body: Provider.of<PageViewModel>(context).bean == null?
                  EmptyWidget():
                  NeoPage2MainWidget())
          );
        },
    );
  }
}

class NeoPage2MainWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    print('NeoPage2MainWidget build');
    return ChangeNotifierProvider(
      create: (_) => CountDownViewModel(awayFromEnd: Provider.of<PageViewModel>(context).bean.awayFromEnd),
      builder: (_,Widget child){
        print('NeoPage2MainWidget ChangeNotifierProvider build');
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///只监听LoginViewModel 变化的widget 不会影响其他widget
              Consumer<LoginViewModel>(
                builder: (BuildContext context,LoginViewModel model,Widget child){
                  print('登录Consumer builder');
                  return model.user == null?
                  ///未登录时显示的 去登录widget
                  Row(
                    children: [
                      Text('现在的登录状态是 ： 未登录'),
                      Padding(padding: EdgeInsets.only(left: 20)),
                      RaisedButton(
                        onPressed: (){
                          ///直接使用model 并调用login方法
                          model.login();
                        },
                        color: Colors.blue,
                        child: Text('去登录',style: TextStyle(
                            color: Colors.white
                        )),
                      )
                    ],
                  ):
                  ///已经登录后显示的用户widget
                  UserWidget(user: model.user);
                },
              ),
              ///不再需要输入倒计时时间了 但是可以显示下
              Padding(padding: EdgeInsets.only(left: 20)),
              Text('倒计时时间是 ： ${Provider.of<PageViewModel>(context).bean.awayFromEnd}秒'),
              ///不可变的widget 不需要重新创建 有可能这个widget非常大 重复构造太耗时间了
              StoneWidget(),
              ///跳转下一页 需要传递倒计时状态 登录后能跳转 这里要传递倒计时状态
              Consumer<CountDownViewModel>(
                builder: (_,CountDownViewModel model,Widget child){
                  return RaisedButton(
                      onPressed: (){
                        if(Provider.of<LoginViewModel>(context,listen: false).user != null){
                          Navigator.pushNamed(context, 'page_other',arguments: <String,dynamic>{'model' : model});
                        }else{
                          Fluttertoast.showToast(msg: '请先登录');
                        }
                      },
                      child: Text('带倒计时状态 跳转下一页')
                  );
                }
              ),
              ///倒计时状态需要在PageViewModel 获取数据后 再启动倒计时 （多状态的相互依赖）
              Consumer<CountDownViewModel>(
                builder: (_,CountDownViewModel model,Widget child){
                  print('倒计时Consumer builder');
                  return Text(model.isAlive?'剩余 ${model.hour}小时 ${model.minute}分钟 ${model.second}秒':'倒计时结束了',style: TextStyle(fontSize: 30));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text('请求数据中...',style: TextStyle(fontSize: 35))
      ),
    );
  }
}

