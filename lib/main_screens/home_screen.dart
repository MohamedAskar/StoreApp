import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/store_controller.dart';
import 'package:store/widgets/badge.dart';

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  List<String> buttons = ['Home', 'Search', 'Deals', 'Cart', 'Profile'];
  var selectedTab = 'Home';

  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    print(selectedTab);
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBody: true,
          backgroundColor: Theme.of(context).backgroundColor,
          bottomNavigationBar: SnakeNavigationBar(
            elevation: 4,
            style: SnakeBarStyle.floating,
            snakeShape: SnakeShape.rectangle,
            snakeColor: Colors.black,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(0),
            showUnselectedLabels: true,
            showSelectedLabels: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            currentIndex: _selectedIndex,
            onPositionChanged: (index) {
              setState(() {
                _selectedIndex = index;
                selectedTab = buttons[_selectedIndex];
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                // ignore: deprecated_member_use
                title: Text('Home',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                // ignore: deprecated_member_use
                title: Text('Search',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.loyalty_outlined),
                // ignore: deprecated_member_use
                title: Text('Deals',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                // ignore: deprecated_member_use
                title: Text('WishList',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                // ignore: deprecated_member_use
                title: Text('Deals',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          // BottomNavyBar(
          //   showElevation: false,
          //   containerHeight: kToolbarHeight,
          //   onItemSelected: (index) {
          //     setState(() {
          //       _selectedIndex = index;
          //       selectedTab = buttons[_selectedIndex];
          //     });
          //   },
          //   selectedIndex: _selectedIndex,
          //   items: [
          //     BottomNavyBarItem(
          //         icon: Icon(
          //           Icons.home_outlined,
          //           size: 30,
          //         ),
          //         title: Text('Home'),
          //         textAlign: TextAlign.center,
          //         inactiveColor: Colors.black,
          //         activeColor: Colors.black),
          //     BottomNavyBarItem(
          //         icon: Icon(
          //           Icons.search,
          //           size: 30,
          //         ),
          //         title: Text('Search'),
          //         textAlign: TextAlign.center,
          //         inactiveColor: Colors.black,
          //         activeColor: Colors.pink[200]),
          //     BottomNavyBarItem(
          //         icon: Icon(
          //           Icons.loyalty_outlined,
          //           size: 30,
          //         ),
          //         title: Text('Deals'),
          //         textAlign: TextAlign.center,
          //         inactiveColor: Colors.black,
          //         activeColor: Colors.teal),
          //     BottomNavyBarItem(
          //         icon: Icon(
          //           Icons.favorite_border,
          //           size: 30,
          //         ),
          //         title: Text('WishList'),
          //         textAlign: TextAlign.center,
          //         inactiveColor: Colors.black,
          //         activeColor: Colors.indigoAccent),
          //     BottomNavyBarItem(
          //         icon: Center(
          //           child: CircleAvatar(
          //             radius: 15,
          //             backgroundImage: AssetImage('assets/images/picture.jpg'),
          //           ),
          //         ),
          //         title: Text('Profile'),
          //         textAlign: TextAlign.center,
          //         inactiveColor: Colors.black,
          //         activeColor: Colors.blue[300]),
          //   ],
          // ),
          appBar: AppBar(
            actions: [
              selectedTab == 'Search'
                  ? SizedBox()
                  : Consumer<Cart>(
                      builder: (_, cart, ch) {
                        return Badge(value: cart.totalQuantity);
                      },
                    )
            ],
            title: Image.asset(
              'assets/images/logo.png',
              height: 70,
            ),
            bottom: selectedTab == 'Home'
                ? TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.black,
                    indicatorPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    tabs: [
                      Tab(
                          child: Text(
                        'New Releases',
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                      Tab(
                          child: Text(
                        'Women',
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                      Tab(
                          child: Text(
                        'Men',
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                      Tab(
                          child: Text(
                        'Kids',
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                      Tab(
                          child: Text(
                        'Collection',
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                    ],
                  )
                : null,
          ),
          body: PageTransitionSwitcher(
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: StoreController(
              selectedTab: selectedTab,
            ),
          )),
    );
  }
}
