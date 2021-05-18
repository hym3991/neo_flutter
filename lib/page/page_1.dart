import 'package:flutter/material.dart';
import 'package:neo_flutter/view_model/count_down_view_model.dart';
import 'package:provider/provider.dart';

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
