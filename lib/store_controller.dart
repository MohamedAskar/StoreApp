import 'package:flutter/material.dart';
import 'package:store/main_screens/deals_screen.dart';
import 'package:store/main_screens/Home/home_collection.dart';
import 'package:store/main_screens/Home/home_kids.dart';
import 'package:store/main_screens/Home/home_men.dart';
import 'package:store/main_screens/Home/home_new.dart';
import 'package:store/main_screens/Home/home_women.dart';
import 'package:store/main_screens/profile_screen.dart';
import 'package:store/main_screens/search_screen.dart';
import 'package:store/main_screens/wishlist_screen.dart';

// ignore: must_be_immutable
class StoreController extends StatelessWidget {
  String selectedTab;
  StoreController({@required this.selectedTab});
  @override
  Widget build(BuildContext context) {
    return (selectedTab == 'Home')
        ? TabBarView(
            children: [NewRelease(), Women(), Men(), Kids(), Collection()],
          )
        : (selectedTab == 'Search')
            ? SearchScreen()
            : (selectedTab == 'Deals')
                ? FavScreen()
                : (selectedTab == 'Cart') ? WishListScreen() : ProfileScreen();
  }
}
