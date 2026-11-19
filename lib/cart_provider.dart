import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<String> _orders = [];

  List<String> get orders => _orders;

  void addOrder(String order) {
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(int index) {
    _orders.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _orders.clear();
    notifyListeners();
  }
}