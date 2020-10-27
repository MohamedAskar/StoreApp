import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:age/age.dart';
import 'package:store/Provider/admin.dart';
import 'package:store/models/user.dart';
import 'package:store/screens/chat/admin_chat_screen.dart';
import 'package:store/widgets/store/store_appBar.dart';

class AdminUsersScreen extends StatefulWidget {
  static const routeName = 'admin-users-screen';

  @override
  _AdminUsersScreenState createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Admin>(context).users;

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StoreAppBar('Users'),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height - 135,
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: Provider.of<Admin>(context).fetchUsers(),
                    builder: (context, snapshot) {
                      return AnimationLimiter(
                          child: ListView.builder(
                        itemCount: users.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 8),
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 600),
                            position: index,
                            child: SlideAnimation(
                                child: FadeInAnimation(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.black12.withOpacity(0.09),
                                  radius: 35,
                                  backgroundImage:
                                      NetworkImage(users[index].picture),
                                ),
                                title: Text(
                                  users[index].fullName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  users[index].email,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                tileColor: Colors.white,
                                onTap: () {
                                  showUserDialog(users[index]);
                                },
                              ),
                            )),
                          );
                        },
                      ));
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showUserDialog(User user) async {
    final chatRoomRef =
        Firestore.instance.collection('Chats').document('Admin. ${user.email}');
    final chatRoom = await chatRoomRef.get();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          var size = MediaQuery.of(context).size;
          var age = Age.dateDifference(
              fromDate: user.birthDate, toDate: DateTime.now());

          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              height: size.width * 0.9,
              width: size.width * 0.7,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80.0,
                    backgroundColor: Colors.black12.withOpacity(0.09),
                    backgroundImage: NetworkImage(user.picture),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    '${user.gender} | Age: ${age.years}',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Account created on ${DateFormat('MMM dd, yyyy').format(user.createdDate)}',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Orders',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          FutureBuilder<int>(
                              future: Provider.of<Admin>(context)
                                  .getUserOrders(user.email),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                );
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'Active',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (chatRoom.exists)
                    FlatButton.icon(
                        onPressed: () async {
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
                                  child: AdminChatScreen(
                                    user: user,
                                    token: user.token,
                                  ),
                                );
                              }));
                        },
                        icon: Icon(Icons.chat_outlined),
                        label: Text(
                          'Chat with ${user.fullName.split(' ')[0]}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ))
                ],
              ),
            ),
          );
        });
  }
}
