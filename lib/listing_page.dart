import 'package:book_app/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookListingPage extends StatelessWidget {
  final BookDatabase _bookDatabase = BookDatabase();
  final MyCartDatabase _cartDatabase = MyCartDatabase();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BookModel>>(
        stream: _bookDatabase.getStream(),
        // initialData: initialData ,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            List<BookModel> books = snapshot.data;
            return ListView.separated(
                itemBuilder: (context, i) => ListTile(
                      title: Text(books[i].bookName),
                      subtitle: Text('\u20b9 ${books[i].price}'),
                      trailing: FlatButton(
                        color: Colors.green,
                          onPressed: () async {
                            CartModel cart;
                            cart = await _cartDatabase.getCart();
                            if (cart != null) {
                              cart.cartItems.add(books[i]);
                              cart.totalPrice =
                                  cart.totalPrice + books[i].price;
                            } else {
                              cart = CartModel(
                                cartItems: [books[i]],
                                totalPrice: books[i].price,
                              );
                              
                            }
                            await _cartDatabase.updateCart(cart);
                            Fluttertoast.showToast(msg: 'Book added to cart');
                          },
                          child: Text("Add to cart")),
                    ),
                separatorBuilder: (context, i) => Divider(),
                itemCount: books.length);
          } else if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
          
              child: CircularProgressIndicator(),
            );
            else return Center(
              child: Text('No Data Found!'),
            );
        },
      );
  }
}
