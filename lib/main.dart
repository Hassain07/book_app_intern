import 'package:book_app/cart_page.dart';
import 'package:book_app/listing_page.dart';
import 'package:book_app/order_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int curIndex = 0;

  String getTitle(int i) {
    switch (i) {
      case 0:
        return "Home Store";
        break;
      case 1:
        return "Cart";
        break;
      case 2:
        return "Orders";
        break;
      default:
        return 'Home Store';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      BookListingPage(),
      CartPage(),
      OrderPage()
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle(curIndex),),
        centerTitle: true,
      ),
      body: screens[curIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("Cart")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket), title: Text("Orders")),
        ],
        currentIndex: curIndex,
        onTap: (i) {
          setState(() {
            curIndex = i;
          });
        },
      ),
    );
  }
}
