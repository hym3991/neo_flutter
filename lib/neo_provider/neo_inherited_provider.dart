import 'package:flutter/material.dart';

///保存共享数据的NeoInheritedProvider
///使用泛型，定义一个通用的NeoInheritedProvider类，它继承自InheritedWidget
class NeoInheritedProvider<T> extends InheritedWidget {
  //共享状态使用泛型
  final T data;

  NeoInheritedProvider({@required this.data,Widget child}) : super(child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    ///在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

///数据发生变化的通知
class NeoChangeNotifier implements Listenable{
  List listeners=[];
  @override
  void addListener(void Function() listener) {
    ///添加监听器
    listeners.add(listener);
  }

  @override
  void removeListener(void Function() listener) {
    ///移除监听器
    listeners.remove(listener);
  }

  void notifyListeners() {
    ///通知所有监听器，触发监听器回调
    listeners.forEach((item)=>item());
  }
}

///用来重新构建NeoInheritedProvider
///该类继承StatefulWidget，然后定义了一个of()静态方法供子类方便获取Widget树中的InheritedProvider中保存的共享状态(model)
class NeoChangeNotifierProvider<T extends NeoChangeNotifier> extends StatefulWidget {

  final Widget child;
  final T data;
  NeoChangeNotifierProvider({Key key,this.data,this.child});

  static T of<T>(BuildContext context){
    final provider =  context.dependOnInheritedWidgetOfExactType<NeoInheritedProvider<T>>();
    return provider.data;
  }

  @override
  _NeoChangeNotifierProviderState<T> createState() => _NeoChangeNotifierProviderState<T>();
}

///NeoChangeNotifierProviderState类的主要作用就是监听到共享状态（model）改变时重新构建Widget树
class _NeoChangeNotifierProviderState<T extends NeoChangeNotifier> extends State<NeoChangeNotifierProvider<T>>{

  void update() {
    //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() => {});
  }

  @override
  void didUpdateWidget(covariant NeoChangeNotifierProvider<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeoInheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}