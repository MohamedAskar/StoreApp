import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/screens/store/cart_screen.dart';
import 'package:store/widgets/store/store_controller.dart';

class StoreHome extends StatefulWidget {
  static const routeName = '/store-home';
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  List<String> buttons = ['Home', 'Search', 'Deals', 'Cart', 'Profile'];
  var selectedTab = 'Home';

  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // ignore: unused_local_variable
    final cartItem = Provider.of<Cart>(context).fetchCartItems();
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
                icon: Badge(
                  child: Icon(Icons.favorite_border),
                  showBadge: true,
                  animationType: BadgeAnimationType.slide,
                  toAnimate: true,
                ),
                // ignore: deprecated_member_use
                title: Text('WishList',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                // ignore: deprecated_member_use
                title: Text('Account',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          appBar: AppBar(
            actions: [
              Visibility(
                visible: (selectedTab != 'Search'),
                child: Consumer<Cart>(
                  builder: (_, cart, ch) {
                    return Badge(
                      position: BadgePosition.topRight(top: 8, right: 6),
                      badgeContent: Text(
                        '${Provider.of<Cart>(context).totalQuantity}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      badgeColor: Colors.black,
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.black,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 150),
                              opaque: false,
                              pageBuilder: (_, animation1, __) {
                                return SlideTransition(
                                    position: Tween(
                                            begin: Offset(1.0, 0.0),
                                            end: Offset(0.0, 0.0))
                                        .animate(animation1),
                                    child: CartScreen());
                              }));
                        },
                      ),
                    );
                  },
                ),
              )
            ],
            title: Image.asset(
              'assets/images/logo.png',
              height: 35,
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
