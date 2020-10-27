import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/addresses_provider.dart';
import 'package:store/Provider/admin.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/Provider/order.dart';
import 'package:store/Provider/payment_provider.dart';
import 'package:store/screens/account/user_profile.dart';
import 'package:store/main_screens/deals_screen.dart';
import 'package:store/main_screens/home_screen.dart';
import 'package:store/main_screens/profile_screen.dart';
import 'package:store/main_screens/search_screen.dart';
import 'package:store/main_screens/wishlist_screen.dart';
import 'package:store/screens/account/add_address_screen.dart';
import 'package:store/screens/account/add_payment_screen.dart';
import 'package:store/screens/account/order_details_screen.dart';
import 'package:store/screens/account/address_book_screen.dart';
import 'package:store/screens/admin/Edit_item_screen.dart';
import 'package:store/screens/admin/manage_items_screen.dart';
import 'package:store/screens/admin/admin_screen.dart';
import 'package:store/screens/auth/onboard_screen.dart';
import 'package:store/screens/store/Splash_screen.dart';
import 'package:store/screens/store/item_details_screen.dart';
import 'package:store/screens/store/order_completed.dart';
import 'package:store/screens/auth/complete_profile_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(MainStoreHome());
}

class MainStoreHome extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
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
        ),
        ChangeNotifierProvider(
          create: (ctx) => PaymentProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Admin(),
        ),
      ],
      child: MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, child),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        debugShowCheckedModeBanner: false,
        title: 'store.',
        themeMode: ThemeMode.system,
        theme: storeTheme,
        home: StreamBuilder<FirebaseUser>(
          stream: _auth.onAuthStateChanged,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (snapshot.hasData) {
              if (snapshot.data.email.contains('@store.com')) {
                return AdminScreen();
              } else {
                return StoreHome();
              }
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return OnboardScreen();
            }
            return null;
          },
        ),
        routes: {
          DealsScreen.routeName: (ctx) => DealsScreen(),
          OrderPlaced.routeName: (ctx) => OrderPlaced(),
          StoreHome.routeName: (ctx) => StoreHome(),
          AdminScreen.routeName: (ctx) => AdminScreen(),
          UserProfile.routeName: (ctx) => UserProfile(),
          PhoneScreen.routeName: (ctx) => PhoneScreen(),
          SearchScreen.routeName: (ctx) => SearchScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          WishListScreen.routeName: (ctx) => WishListScreen(),
          EditItemScreen.routeName: (ctx) => EditItemScreen(),
          AddPaymentScreen.routeName: (ctx) => AddPaymentScreen(),
          AddAddressScreen.routeName: (ctx) => AddAddressScreen(),
          ItemDetailsScreen.routeName: (ctx) => ItemDetailsScreen(),
          ManageItemsScreen.routeName: (ctx) => ManageItemsScreen(),
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
        fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
    headline2: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
    headline3: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
    bodyText1: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
  ),
);
