import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/addresses_provider.dart';

import 'package:store/screens/account/add_address_screen.dart';
import 'package:store/widgets/account/address_item.dart';

class AddressBookScreen extends StatelessWidget {
  final bool isCart;
  AddressBookScreen({this.isCart = false});
  static const routeName = '/address-book-screen';
  @override
  Widget build(BuildContext context) {
    final addressBook = Provider.of<AddressProvider>(context).addressBook;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
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
                      IconButton(
                        icon: Icon(Icons.add),
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
                                    child: AddAddressScreen());
                              }));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 142,
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: Provider.of<AddressProvider>(context).fetchAddress(),
                  builder: (context, snapshot) {
                    return AnimationLimiter(
                      child: ListView.builder(
                          itemCount: addressBook.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: ChangeNotifierProvider.value(
                                  value: addressBook[index],
                                  child: AddressItem(
                                    select: isCart,
                                  ),
                                )),
                              ),
                            );
                          }),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
