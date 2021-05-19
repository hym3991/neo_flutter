import 'package:flutter/material.dart';
import 'package:neo_flutter/page/page_1.dart';
import 'package:neo_flutter/page/page_2.dart';
import 'package:neo_flutter/page/page_other.dart';
import 'package:neo_flutter/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///在最外层共享登录这个状态
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      builder:(_,Widget child) => MaterialApp(
        title: 'Provider Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: <String, WidgetBuilder>{
          'page1' : (BuildContext context) => NeoPage(),
          'page2' : (BuildContext context) => NeoPage2(),
        },
        home: MyPage()
      ),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: InkWell(
            child: Text('开始吧'),
            onTap: (){
              Navigator.pushNamed(context, 'page2');
            },
          ),
        ),
      ),
    );
  }
}

