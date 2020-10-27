import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/addresses_provider.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/Provider/order.dart';
import 'package:store/Provider/payment_provider.dart';
import 'package:store/screens/account/user_profile.dart';
import 'package:store/screens/auth/sign_in_screen.dart';
import 'package:store/widgets/store/settings.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile-screen';
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<FirebaseUser>(
                stream: _auth.onAuthStateChanged,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Hero(
                              tag: 'profile',
                              child: CircleAvatar(
                                backgroundColor:
                                    Colors.black12.withOpacity(0.09),
                                backgroundImage: snapshot.data.photoUrl == null
                                    ? null
                                    : NetworkImage(snapshot.data.photoUrl),
                                child: snapshot.data.photoUrl == null
                                    ? Icon(
                                        Icons.person_outline,
                                        color: Colors.black,
                                        size: 120,
                                      )
                                    : null,
                                radius: 75.0,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          snapshot.data.displayName,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          snapshot.data.email,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton.icon(
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
                                            child: UserProfile());
                                      }));
                                },
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                )),
                            FlatButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Logout',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                        content: Text(
                                          'Do you want to logout?',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        actions: [
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'No',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              )),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();

                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        PageRouteBuilder(
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        150),
                                                            opaque: false,
                                                            pageBuilder: (_,
                                                                animation1,
                                                                __) {
                                                              return SlideTransition(
                                                                  position: Tween(
                                                                          begin: Offset(
                                                                              1.0,
                                                                              0.0),
                                                                          end: Offset(
                                                                              0.0,
                                                                              0.0))
                                                                      .animate(
                                                                          animation1),
                                                                  child:
                                                                      SignInScreen());
                                                            }));
                                                _auth.signOut();
                                                Provider.of<ItemsProvider>(
                                                        context,
                                                        listen: false)
                                                    .clear();
                                                Provider.of<AddressProvider>(
                                                        context,
                                                        listen: false)
                                                    .clearAddressBook();

                                                Provider.of<PaymentProvider>(
                                                        context,
                                                        listen: false)
                                                    .clearPayments();
                                                Provider.of<Order>(context,
                                                        listen: false)
                                                    .clear();
                                              },
                                              child: Text(
                                                'Yes',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              )),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Logout',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                )),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Divider(),
            Settings()
          ],
        ),
      ),
    );
  }
}
