import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:store/screens/add_address_screen.dart';

class AddressBookScreen extends StatelessWidget {
  static const routeName = '/address-book-screen';
  @override
  Widget build(BuildContext context) {
    //final address = Provider.of<AddressProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.maybePop(context);
                      },
                      child: Icon(
                        Icons.clear_outlined,
                        size: 25,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Address Book',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        InkWell(
                          child: Icon(Icons.add),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AddAddressScreen.routeName);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            AnimationLimiter(
              child: ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Card(
                            margin: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.home_work_outlined),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            'Home',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )
                                        ],
                                      ),
                                      InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete_outline),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Name'),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text('Address'),
                                          SizedBox(
                                            height: 48,
                                          ),
                                          Text('Mobile Number')
                                        ],
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Mohamed Askar'),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                              'Amer St. - Tanta Qism 1 - Tanta'),
                                          Text(
                                            'Gharbia Governorate, 31511',
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text('+20 106 929 2154')
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
