import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:store/screens/account/address_book_screen.dart';
import 'package:store/screens/account/orders_screen.dart';
import 'package:store/screens/account/payment_screen.dart';
import 'package:store/screens/chat/chat_screen.dart';
import 'package:store/screens/store/about_us.dart';
import 'package:store/screens/store/store_locators.dart';
import 'package:store/settings_ui/settings_list.dart';
import 'package:store/settings_ui/settings_section.dart';
import 'package:store/settings_ui/settings_tile.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _toggleNotifications = false;
  Future<String> token;

  isNotification() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('Users').document(user.email).get();
    setState(() {
      _toggleNotifications = userData.data['notification'] == null
          ? false
          : userData.data['notification'];
    });
  }

  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging();
    token = fcm.getToken();
    isNotification();
    if (_toggleNotifications) {
      fcm.subscribeToTopic('Deals');
    } else {
      fcm.unsubscribeFromTopic('Deals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'My Account',
          tiles: [
            SettingsTile(
              enabled: true,
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 150),
                    opaque: false,
                    pageBuilder: (_, animation1, __) {
                      return SlideTransition(
                          position: Tween(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation1),
                          child: OrdersScreen());
                    }));
              },
              title: 'My Orders',
              leading: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black87,
              ),
            ),
            SettingsTile(
              title: 'Addresses',
              enabled: true,
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 150),
                    opaque: false,
                    pageBuilder: (_, animation1, __) {
                      return SlideTransition(
                          position: Tween(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation1),
                          child: AddressBookScreen());
                    }));
              },
              leading: Icon(
                Icons.location_history_outlined,
                color: Colors.black87,
              ),
            ),
            SettingsTile(
              title: 'Payment',
              enabled: true,
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 150),
                    opaque: false,
                    pageBuilder: (_, animation1, __) {
                      return SlideTransition(
                          position: Tween(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation1),
                          child: PaymentScreen());
                    }));
              },
              leading: Icon(
                Icons.payment_outlined,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: 'Settings',
          tiles: [
            SettingsTile(
              title: 'Country',
              leading: Icon(
                Icons.location_city_outlined,
                color: Colors.black87,
              ),
              trailing: Text('EG'),
            ),
            SettingsTile(
              title: 'Language',
              leading: Icon(
                Icons.language_outlined,
                color: Colors.black87,
              ),
              trailing: Text('English'),
            ),
            SettingsTile.switchTile(
              leading: Icon(
                Icons.notifications_active_outlined,
                color: Colors.black87,
              ),
              title: 'Notification',
              switchValue: _toggleNotifications,
              onToggle: (value) async {
                final user = await FirebaseAuth.instance.currentUser();
                setState(() {
                  _toggleNotifications = value;
                });
                Firestore.instance
                    .collection('Users')
                    .document(user.email)
                    .updateData({'notification': value});
              },
            )
          ],
        ),
        SettingsSection(
          title: 'Reach out to us',
          tiles: [
            SettingsTile(
              title: 'Store Locations',
              enabled: true,
              leading: Icon(
                Icons.storefront_outlined,
                color: Colors.black87,
              ),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 150),
                    opaque: false,
                    pageBuilder: (_, animation1, __) {
                      return SlideTransition(
                        position: Tween(
                                begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                            .animate(animation1),
                        child: StoreLocators(),
                      );
                    }));
              },
            ),
            SettingsTile(
              title: 'Feedback',
              enabled: true,
              leading: Icon(
                Icons.feedback_outlined,
                color: Colors.black87,
              ),
            ),
            SettingsTile(
              onTap: () async {
                final user = await FirebaseAuth.instance.currentUser();
                final chatRef = Firestore.instance
                    .collection('Chats')
                    .document('Admin. ${user.email}');
                var chat = await chatRef.get();
                if (!chat.exists) {
                  chatRef.setData({
                    'chatStarted': false,
                    'chatRequested': false,
                    'requestedUser': user.email
                  });
                }
                Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 150),
                    opaque: false,
                    pageBuilder: (_, animation1, __) {
                      return SlideTransition(
                        position: Tween(
                                begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                            .animate(animation1),
                        child: ChatScreen(),
                      );
                    }));
              },
              title: 'Help',
              enabled: true,
              leading: Icon(
                Icons.live_help_outlined,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SettingsSection(
          title: 'About',
          tiles: [
            SettingsTile(
              title: 'About us',
              enabled: true,
              leading: Icon(
                Icons.info_outline,
                color: Colors.black87,
              ),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 150),
                    opaque: false,
                    pageBuilder: (_, animation1, __) {
                      return SlideTransition(
                        position: Tween(
                                begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                            .animate(animation1),
                        child: AboutUsScreen(),
                      );
                    }));
              },
            )
          ],
        )
      ],
    );
  }
}
