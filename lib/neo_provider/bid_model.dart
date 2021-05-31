import 'package:neo_flutter/neo_provider/neo_inherited_provider.dart';

///保存出价数据
class BidModel extends NeoChangeNotifier{
  int _bidPrice;
  int get bidPrice => _bidPrice;
  set bidPrice(int value){
    _bidPrice = value;
    notifyListeners();
  }

  BidModel(){
    _bidPrice = 0;
  }

  void bid(int price){
    bidPrice = price;
  }
}