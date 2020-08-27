import 'package:flutter/material.dart';
import 'package:store/screens/address_book_screen.dart';
import 'package:store/screens/orders_screen.dart';
import 'package:store/settings_ui/settings_list.dart';
import 'package:store/settings_ui/settings_section.dart';
import 'package:store/settings_ui/settings_tile.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _toggleNotifications = false;
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
                Navigator.of(context).pushNamed(OrdersScreen.routeName);
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
                Navigator.of(context).pushNamed(AddressBookScreen.routeName);
              },
              leading: Icon(
                Icons.location_history_outlined,
                color: Colors.black87,
              ),
            ),
            SettingsTile(
              title: 'Payment',
              enabled: true,
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
              onToggle: (value) {
                setState(() {
                  _toggleNotifications = value;
                });
              },
            )
          ],
        ),
        SettingsSection(
          title: 'Reach out to us',
          tiles: [
            SettingsTile(
              title: 'Store Locators',
              enabled: true,
              leading: Icon(
                Icons.storefront_outlined,
                color: Colors.black87,
              ),
            ),
            SettingsTile(
              title: 'Help',
              enabled: true,
              leading: Icon(
                Icons.live_help_outlined,
                color: Colors.black87,
              ),
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
              title: 'Chat with us',
              enabled: true,
              leading: Icon(
                Icons.chat_outlined,
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
            )
          ],
        )
      ],
    );
  }
}
