import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/admin.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/screens/admin/admin_orders_screen.dart';
import 'package:store/screens/admin/admin_user_screen.dart';
import 'package:store/screens/admin/manage_items_screen.dart';
import 'package:store/screens/auth/sign_in_screen.dart';

class AdminScreen extends StatefulWidget {
  static const routeName = '/admin-screen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging();
    fcm.subscribeToTopic('Orders');
    fcm.subscribeToTopic('Chat');
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);

    // ignore: unused_local_variable
    Future items = Provider.of<ItemsProvider>(context).getItems();
    final _auth = FirebaseAuth.instance;
    final size = MediaQuery.of(context).size.width;
    final kContainerSize = size / 2.5;
    var admin = Provider.of<Admin>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          height: 35,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                _auth.signOut();

                Provider.of<Admin>(context, listen: false).clear();

                Navigator.of(context).pushReplacement(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 150),
                    opaque: false,
                    pageBuilder: (_, animation1, __) {
                      return SlideTransition(
                          position: Tween(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation1),
                          child: SignInScreen());
                    }));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  'Admin panel',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      padding: const EdgeInsets.all(20),
                      height: kContainerSize,
                      width: kContainerSize,
                      decoration: BoxDecoration(
                        color: Color(0xFFE63946),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            'Products',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                          Text(
                            '${Provider.of<ItemsProvider>(context).items.length} item',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
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
                                        child: ManageItemsScreen());
                                  }));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Manage',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                      height: kContainerSize,
                      width: kContainerSize,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF0a2239),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            'Users',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                          FutureBuilder<int>(
                              future: admin.getUsers(),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                );
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
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
                                        child: AdminUsersScreen());
                                  }));
                            },
                            child: Text(
                              'Show details',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                child: Container(
                    height: kContainerSize,
                    width: kContainerSize * 2.15,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF5fa8d3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.redeem_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              'Orders',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            FutureBuilder<int>(
                                future: admin.getOrders(),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  );
                                }),
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
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
                                          child: AdminOrdersScreen());
                                    }));
                              },
                              child: Text(
                                'Show details',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )
                          ],
                        ),
                        Text(
                          '+1',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
