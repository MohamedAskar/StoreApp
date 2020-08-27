import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/addresses_provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/Provider/order.dart';
import 'package:store/main_screens/home_screen.dart';
import 'package:store/screens/add_address_screen.dart';
import 'package:store/screens/address_book_screen.dart';
import 'package:store/screens/cart_screen.dart';
import 'package:store/screens/item_details_screen.dart';
import 'package:store/screens/order_completed.dart';
import 'package:store/screens/order_details_screen.dart';
import 'package:store/screens/orders_screen.dart';

void main() {
  runApp(MainStoreHome());
}

class MainStoreHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ItemsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AddressProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'store.',
        themeMode: ThemeMode.system,
        theme: storeTheme,
        home: AddressBookScreen(),
        routes: {
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderPlaced.routeName: (ctx) => OrderPlaced(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          AddAddressScreen.routeName: (ctx) => AddAddressScreen(),
          ItemDetailsScreen.routeName: (ctx) => ItemDetailsScreen(),
          AddressBookScreen.routeName: (ctx) => AddressBookScreen(),
          OrderDetailsScreen.routeName: (ctx) => OrderDetailsScreen(),
        },
      ),
    );
  }
}

final ThemeData storeTheme = ThemeData(
  brightness: Brightness.light,
  iconTheme: IconThemeData(color: Colors.black),
  primaryColor: Colors.black,
  accentColor: Colors.black,
  cardColor: Color(0xFFF6F6F6),
  textSelectionHandleColor: Colors.black,
  cursorColor: Colors.grey,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      elevation: 0,
      centerTitle: true,
      color: Colors.white),
  fontFamily: 'Wavehaus',
  textTheme: TextTheme(
    headline1: TextStyle(
        fontFamily: 'Wavehaus',
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: Colors.black),
    headline2: TextStyle(
        fontFamily: 'Wavehaus',
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.black),
    headline3: TextStyle(
        fontFamily: 'Wavehaus',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black),
    bodyText1: TextStyle(
        fontFamily: 'Wavehaus',
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black),
  ),
);
