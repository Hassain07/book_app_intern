import 'package:book_app/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartModel cartModel;
  final MyCartDatabase _cartDatabase = MyCartDatabase();
  final _orderDatabase = OrderDatabase();
  bool loading;
  @override
  void initState() {
    loading = true;
    _cartDatabase.getCart().then((cart) {
     
        setState(() {
          cartModel = cart;
          loading = false;
        });
        
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        :cartModel!=null&&cartModel.cartItems.isNotEmpty? ListView.separated(
            itemBuilder: (c, i) {
              if (cartModel.cartItems.length == i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical:15,horizontal:10),
                    color: Colors.green,
                      onPressed: () async {
                        setState(() {
                          loading=true;
                        });
                        final order = OrderModel();
                        order.books=[];
                        cartModel.cartItems.forEach((f) {
                          order.books.add(f.bookName);
                          order.orderTotal = order.orderTotal + f.price;
                        });
                        await _orderDatabase.createOrder(order);
                        await _cartDatabase.deleteCart();
                        setState(() {
                          cartModel=null;
                          loading=false;
                        });
                      },
                      child: Text('Place order',style: TextStyle(fontSize: 24),)),
                );
              }
              return ListTile(
                title: Text(cartModel.cartItems[i].bookName),
                subtitle: Text('\u20b9 ${cartModel.cartItems[i].price}'),
                trailing: FlatButton(
                    onPressed: () async {
                      cartModel.cartItems.removeAt(i);
                      await _cartDatabase.updateCart(cartModel);
                      setState(() {});
                      Fluttertoast.showToast(msg: 'Book removed successfully');
                    },
                    child: Text('Remove')),
              );
            },
            separatorBuilder: (c, i) => Divider(),
            itemCount: cartModel.cartItems.length + 1):Center(child: Text("CART IS EMPTY!"));
  }
}
