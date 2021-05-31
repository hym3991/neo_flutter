import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///ChangeNotifier 状态存储
///ChangeNotifierProvider 状态提供
///Consumer Selector Provider.of() 状态消费者
///
/// 元素：
/// 1.view 视图
/// 2.viewModel 视图模型 管理状态
/// 3.service 一些api的封装
///
/// 原则
/// 1.视图尽量没有任何逻辑。如果只是ui上的逻辑，那么也要做到最少。并将其他逻辑让视图模型来做
/// 2.视图模型的状态与视图绑定，2者同时出现，不能只有视图而没有模型
/// 3.视图可以重复多个地方使用
/// 4.视图模型不能操作其他视图模型
/// 5.视图不能直接操作service
///
enum ViewState{ BUSY,ERROR,IDLE }
abstract class BaseViewModel extends ChangeNotifier{
  ViewState _viewState;
  ViewState get viewState => _viewState;
  set viewState(ViewState value){
    _viewState = value;
    notifyListeners();
  }
}

class BaseProviderWidget<M extends BaseViewModel> extends StatelessWidget{
  final M viewModel;
  final Widget Function(BuildContext, M, Widget) builder;
  final Widget staticChild;
  BaseProviderWidget({Key key,this.viewModel,this.staticChild, this.builder}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => viewModel,
        builder: (context,child) => builder(context,viewModel,child),
        child: staticChild,
    );
  }
}
class BaseProviderFulWidget<M extends BaseViewModel> extends StatefulWidget {

  final M Function() viewModelBuild;
  final Widget Function(BuildContext, M, Widget) builder;
  final Widget staticChild;
  BaseProviderFulWidget({Key key,this.viewModelBuild,this.staticChild, this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BaseProviderFulState<M>();
  }
}
class BaseProviderFulState<M extends BaseViewModel> extends State<BaseProviderFulWidget> {

  M _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModelBuild();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context,child) => widget.builder(context,_viewModel,child),
      child: widget.staticChild,
    );
  }
}

enum ViewModelBuilderType { NoReactive, Reactive }
class BaseViewModelWidget<M extends BaseViewModel> extends StatelessWidget{
  final ViewModelBuilderType _modelBuilderType;
  final Widget Function(BuildContext, M, Widget) builder;
  final Widget staticChild;
  BaseViewModelWidget.noReactive({
    Key key,
    this.builder,
    this.staticChild
  }) : _modelBuilderType = ViewModelBuilderType.NoReactive,
      super(key: key);
  BaseViewModelWidget.reactive({
    Key key,
    this.builder,
    this.staticChild
  }) : _modelBuilderType = ViewModelBuilderType.Reactive,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if(_modelBuilderType == ViewModelBuilderType.Reactive){
      return Consumer<M>(
        builder: builder,
        child: staticChild,
      );
    }else{
      return builder(context,Provider.of<M>(context,listen: false),staticChild);
    }
  }
}
class BaseViewModelSelectorWidget<M extends BaseViewModel,T> extends StatelessWidget{
  final T Function(BuildContext, M) selector;
  final Widget Function(BuildContext,M,T,Widget) buildWidget;
  final bool Function(T oldV,T newV) shouldRebuild;
  BaseViewModelSelectorWidget({Key key,this.selector,this.buildWidget,this.shouldRebuild}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Selector<M,T>(
        builder: (context,value,child) => buildWidget(context,Provider.of<M>(context,listen: false),value,child),
        selector: selector,
        shouldRebuild: shouldRebuild,
    );
  }
}
class BaseViewModelStateWidget<M extends BaseViewModel> extends BaseViewModelSelectorWidget<M,ViewState>{
  @override
  ViewState Function(BuildContext p1, M p2) get selector => (p1,p2) => p2.viewState;
  @override
  bool Function(ViewState oldV, ViewState newV) get shouldRebuild => (oldV,newV) => oldV != newV;
}
