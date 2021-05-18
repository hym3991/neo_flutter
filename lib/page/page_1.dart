import 'package:flutter/material.dart';
import 'package:neo_flutter/view_model/count_down_view_model.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CountDownViewModel>(
      create: (_) => CountDownViewModel(),
      builder: (_,Widget child){
        return SafeArea(
            child: Scaffold(
              body: Container(

              ),
            )
        );
      },
    );
  }
}
