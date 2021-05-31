import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neo_flutter/base/neo_base_provider_widget.dart';
import 'package:neo_flutter/bean/user_bean.dart';
import 'package:neo_flutter/view_model/count_down_view_model.dart';
import 'package:neo_flutter/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

///https://juejin.cn/post/6844903864852807694#heading-26
///https://juejin.cn/post/6844904033514192909#heading-2
///https://juejin.cn/post/6844904057321046029#heading-0
///https://juejin.cn/post/6844903923501776909
///https://juejin.cn/post/6844904193937932301
class NeoPage extends StatefulWidget {
  const NeoPage({Key key}) : super(key: key);

  @override
  _NeoPageState createState() => _NeoPageState();
}

class _NeoPageState extends State<NeoPage> {
  TextEditingController dealerIdController;
  @override
  void initState() {
    super.initState();
    dealerIdController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    ///并不是所有的widget都需要这个状态
    ///如果还有个页面ViewModel呢
    return ChangeNotifierProvider<CountDownViewModel>(
      create: (_) => CountDownViewModel(),
      builder: (BuildContext context,Widget child){
        print('_NeoPageState 的 build 走了');
        return SafeArea(
            child: Scaffold(
              body: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///登录状态也不要倒计时状态
                    ///Provider.of<LoginViewModel>(context,listen: false)
                    ///listen: false / true 表示是否在值发生比变化时进行通知 调用State.build方法 以及 State.didChangeDependencies方法
                    ///从而造成页面重建
                    Row(
                      children: [
                        Text('现在的登录状态是 ： ${Provider.of<LoginViewModel>(context,listen: false).user == null?'未登录':'已登录'}'),
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Visibility(
                            visible: Provider.of<LoginViewModel>(context).user == null,
                            child: RaisedButton(
                              onPressed: (){
                                ///从上层获取LoginViewModel 并调用login方法
                                Provider.of<LoginViewModel>(context,listen: false).login();
                              },
                              color: Colors.blue,
                              child: Text('去登录',style: TextStyle(
                                color: Colors.white
                              )),
                            )
                        )
                      ],
                    ),
                    ///需要登录状态 登录后才显示的widget
                    Visibility(
                        visible: Provider.of<LoginViewModel>(context).user != null,
                        child: UserWidget(user: Provider.of<LoginViewModel>(context).user)
                    ),
                    ///倒计时输入框 如果既要倒计时状态 防止重复点击倒计时（只要知道开始于结束 不要每秒都回调）
                    ///有要登录状态 获取接口返回的倒计时时间呢
                    Row(
                      children: [
                        ///输入倒计时时间
                        SizedBox(
                          width: 150 ,
                          child: TextField(
                            controller: dealerIdController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '请输入倒计时秒数',
                              labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        ///开始倒计时按钮
                        Padding(padding: EdgeInsets.only(left: 20)),
                        RaisedButton(
                            onPressed: (){
                              ///获取倒计时是否运行的状态 防止重复倒计时
                              if(Provider.of<CountDownViewModel>(context,listen: false).isAlive){
                                return;
                              }
                              if(dealerIdController.text != null && dealerIdController.text.length > 0){
                                Provider.of<CountDownViewModel>(context,listen: false).startTimer(int.parse(dealerIdController.text));
                              }
                            },
                            child: Text('开始倒计时'))
                      ],
                    ),
                    ///不可变的widget 不需要重新创建 有可能这个widget非常大 重复构造太耗时间了
                    StoneWidget(),
                    ///跳转下一页 需要传递倒计时状态 如果还要求登录后能跳转呢
                    RaisedButton(
                        onPressed: (){

                        },
                        child: Text('带倒计时状态 跳转下一页')),
                    ///写法1 - 直接使用 会造成StoneWidget 每秒都被build一次 其实我们不需要的
                    Text(Provider.of<CountDownViewModel>(context).isAlive?'剩余 ${Provider.of<CountDownViewModel>(context).hour}小时 ${Provider.of<CountDownViewModel>(context).minute}分钟 ${Provider.of<CountDownViewModel>(context).second}秒':'倒计时结束了',style: TextStyle(
                     fontSize: 30
                    )),
                    ///写法2 - 使用Consumer监听
                    Consumer<CountDownViewModel>(
                      builder: (_,CountDownViewModel model,Widget child){
                        print('Consumer builder');
                        return Text(model.isAlive?'剩余 ${model.hour}小时 ${model.minute}分钟 ${model.second}秒':'倒计时结束了',style: TextStyle(fontSize: 30));
                      },
                    ),
                    ///写法3 - 使用Selector
                    Selector<CountDownViewModel,bool>(
                        selector: (_,CountDownViewModel model) => model.isAlive,
                        builder: (_ ,bool isAlive,Widget child ){
                          print('Selector builder');
                          return  Text(isAlive?'剩余 ${Provider.of<CountDownViewModel>(context).hour}小时 ${Provider.of<CountDownViewModel>(context).minute}分钟 ${Provider.of<CountDownViewModel>(context).second}秒':'倒计时结束了',style: TextStyle(
                              fontSize: 30
                          ));
                        },

                    )
                  ],
                ),
              ),
            )
        );
      },
    );
  }
}

class StoneWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.primaries[Random.secure().nextInt(15)],
      child: Center(
        child: Text('不需要监听状态改变的widget,但是我每次build都会有新的背景颜色',style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  ///需要登录后展示的widget
  final User user;
  UserWidget({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('姓名 ： ${user.name}'),
          Text('城市 ： ${user.city}'),
          Text('年龄 :  ${user.age}' )
        ],
      ),
    );
  }
}


class NeoPageNew extends BaseProviderFulWidget<CountDownViewModel>{

  @override
  State<StatefulWidget> initState() => NeoPageNewState();
}

class NeoPageNewState extends BaseProviderFulState<CountDownViewModel,NeoPageNew>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return super.build(context);
  }
}
