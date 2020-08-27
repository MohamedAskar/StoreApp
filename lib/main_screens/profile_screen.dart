import 'package:flutter/material.dart';
import 'package:store/widgets/info_widget.dart';
import 'package:store/main_screens/Profile/settings.dart';
import 'package:store/screens/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  void _onButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
        PageRouteBuilder(pageBuilder: (context, animation1, animation2) {
      return FadeTransition(opacity: animation1, child: AuthScreen());
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                    onPressed: () {},
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
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            content: Text(
                              'Do you want to logout?',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )),
                              FlatButton(
                                  onPressed: () => _onButtonPressed(context),
                                  child: Text(
                                    'Yes',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
            // Divider(),
            // Text(
            //   'Recent Orders',
            //   style: Theme.of(context).textTheme.headline2,
            // ),
            // OrdersPageView(),
            Divider(),
            Settings()
          ],
        ),
      ),
    );
  }
}
