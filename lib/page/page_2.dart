
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neo_flutter/neo_provider/bid_model.dart';
import 'package:neo_flutter/neo_provider/neo_inherited_provider.dart';
import 'package:neo_flutter/page/page_1.dart';
import 'package:neo_flutter/page/page_other.dart';
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
  void initState() {
    super.initState();
  }
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
    ///还有没有更好的办法 结合2个ChangeNotifierProvider但是还存在依赖关系ProxyProvider
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
              ///不再需要输入倒计时时间了 但是可以显示
              Padding(padding: EdgeInsets.only(left: 20)),
              Text('倒计时时间是 ： ${Provider.of<PageViewModel>(context).bean.awayFromEnd}秒'),
              ///不可变的widget 不需要重新创建 有可能这个widget非常大 重复构造太耗时间了
              StoneWidget(),
              ///如果我需要倒计时是否开始以及结束这2个状态呢
              Selector<CountDownViewModel,bool>(
                  selector: (_,CountDownViewModel model) => model.isLiveOrEnd,
                  builder: (_,bool isLiveOrEnd,Widget child){
                    print('TimerStatusWidget Selector builder');
                    return TimerStatusWidget(isLiveOrEnd: isLiveOrEnd);
                  },
              ),
              ///跳转下一页 需要传递倒计时状态 登录后能跳转 这里要传递倒计时状态
              Consumer<CountDownViewModel>(
                builder: (_,CountDownViewModel model,Widget child){
                  return RaisedButton(
                      onPressed: (){
                        if(Provider.of<LoginViewModel>(context,listen: false).user != null){
                          ///跳转传递倒计时状态 问题是会造成在PageOther退出时关闭倒计时
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PageOther(awayFromEnd: model.awayFromEnd)));
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

              BidWidget()

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

class TimerStatusWidget extends StatelessWidget{
  final bool isLiveOrEnd;
  TimerStatusWidget({this.isLiveOrEnd});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: this.isLiveOrEnd?Colors.green:Colors.grey,
      child: Center(
        child: Text(this.isLiveOrEnd?'倒计时还在继续':'倒计时已经结束了',style: TextStyle(
          fontSize: 30,
          color: Colors.white
        )),
      ),
    );
  }
}

class BidWidget extends StatelessWidget{
  final TextEditingController bidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NeoChangeNotifierProvider<BidModel>(
      data: BidModel(),
      child: Builder(builder: (context){
        return Container(
            color: NeoChangeNotifierProvider.of<BidModel>(context).bidPrice==0?Colors.blue:Colors.grey,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30),
            child: GestureDetector(
              onTap: (){
                if(NeoChangeNotifierProvider.of<BidModel>(context).bidPrice == 0){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context1){
                        return AlertDialog(
                          title: Text('我要出价'),
                          content: Container(
                            child:  SizedBox(
                              width: 150 ,
                              child: TextField(
                                controller: bidController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: '请输入出价金额',
                                  labelStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            FlatButton(onPressed: (){
                              if(bidController.text != null && int.parse(bidController.text) > 0){
                                Navigator.of(context).pop();
                                NeoChangeNotifierProvider.of<BidModel>(context).bidPrice = int.parse(bidController.text);
                              }
                            }, child: Text('确定')),
                            FlatButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text('取消')),
                          ],
                        );
                      }
                  );
                }
              },
              child: Center(
                child: Text(
                    NeoChangeNotifierProvider.of<BidModel>(context).bidPrice==0?
                    '我要出价':
                    '我的出价 ： ￥${NeoChangeNotifierProvider.of<BidModel>(context).bidPrice}元',
                    style: TextStyle(color: Colors.white)
                ),
              ),
            )
        );
      }),
    );
  }

}

