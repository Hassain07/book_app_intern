import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookModel {
  String id;
  String bookName;
  double price;

  BookModel({this.bookName, this.price});

  BookModel.fromJson(String key, Map<String, dynamic> json) {
    id = key;
    bookName = json['name'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.bookName;
    data['price'] = this.price;
    return data;
  }
}

class OrderModel {
  String id;
  List<String> books;
  double orderTotal;

  OrderModel({this.books, this.orderTotal=0});

  OrderModel.fromJson(String key, Map<String, dynamic> json) {
    id = key;
    books = json['books'].cast<String>();
    orderTotal = json['order_total'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['books'] = this.books;
    data['order_total'] = this.orderTotal;
    return data;
  }
}

class BookDatabase {
  final ref = Firestore.instance.collection('Books').reference();
  Stream<List<BookModel>> getStream() {
    return Stream.fromFuture(getBooks());
  }

  Future<List<BookModel>> getBooks() async {
    final snap = await ref.getDocuments();
    if (snap.documents.isNotEmpty) {
      final bookList = snap.documents
          .map((f) => BookModel.fromJson(f.documentID, f.data))
          .toList();
      return bookList;
    } else
      return null;
  }
}

class OrderDatabase {
  final ref = Firestore.instance.collection("Orders").reference();
  Future<List<OrderModel>> getOrders() async {
    final snap = await ref.getDocuments();
    if (snap.documents.isNotEmpty) {
      final orderList = snap.documents
          .map((f) => OrderModel.fromJson(f.documentID, f.data))
          .toList();
      return orderList;
    } else
      return null;
  }

  Future<void> createOrder(OrderModel orderModel) async {
    orderModel.id = DateTime.now().millisecondsSinceEpoch.toString();
    await ref.document(orderModel.id).setData(orderModel.toJson());
    Fluttertoast.showToast(msg: "Order Placed Successfully");
  }
}

class CartModel {
  List<BookModel> cartItems;
  double totalPrice;

  CartModel({
    this.cartItems,
    this.totalPrice = 0,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      // cartItems = json['cart_items'].cast<String>();
      final List t=json['cart_items'];
    cartItems=t.map((f)=>BookModel.fromJson(null, f)).toList();
      totalPrice = double.parse(json['total_price']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_items'] = cartItems;

    data['total_price'] = this.totalPrice.toString();

    return data;
  }
}

class MyCartDatabase {
  SharedPreferences preferences;
  final cartKey = 'Cart';

  Future<CartModel> getCart() async {
    preferences = await SharedPreferences.getInstance();
    var cart = preferences.get(cartKey);

    if (cart != null) {
      CartModel cartModel = CartModel.fromJson(json.decode(cart));
      return cartModel;
    }

    return null;
  }

  Future<bool> deleteCart() async {
    preferences = await SharedPreferences.getInstance();
    return await preferences.remove(cartKey);
  }

  Future<void> createCart(user, CartModel cartModel) async {
    preferences = await SharedPreferences.getInstance();

    await preferences.setString(cartKey, json.encode(cartModel.toJson()));
  }

  Future updateCart(CartModel cartModel) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setString(cartKey, json.encode(cartModel.toJson()));
  }
}
