import 'package:book_app/services.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  OrderDatabase _orderDatabase = OrderDatabase();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderModel>>(
      stream: Stream.fromFuture(_orderDatabase.getOrders()),
      builder:
          (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          final orders = snapshot.data;
          return ListView.separated(
              itemBuilder: (c, i) => Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20,bottom: 0,top: 10),
                      child: Text("Book List:"),
                    ),
                    for (int j = 0; j < orders[i].books.length; j++)
                    ...[
                      ListTile(
                       
                        title: Text('${j+1}:     ${orders[i].books[j]}'),
                      )],
                    ListTile(
                      title: Text('Total amount:'),
                      trailing: Text("\u20b9 ${orders[i].orderTotal}"),
                    ),
                  ])),
              separatorBuilder: (c, i) => Divider(),
              itemCount: orders.length);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text("NO ORDERS FOUND!"),
          );
        }
      },
    );
  }
}
