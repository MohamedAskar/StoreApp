import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/addresses_provider.dart';
import 'package:store/models/address.dart';
import 'package:store/screens/account/add_address_screen.dart';
import 'package:store/screens/account/payment_screen.dart';

class AddressItem extends StatelessWidget {
  const AddressItem({
    this.select,
  });

  final bool select;

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<Address>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon((address.type == AddressType.Home)
                          ? Icons.home_work_outlined
                          : Icons.location_city),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        (address.type == AddressType.Home) ? 'Home' : 'Office',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: select,
                        child: InkWell(
                            onTap: () {
                              Provider.of<AddressProvider>(context,
                                      listen: false)
                                  .sortAddresses(address.id);
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
                                        child: PaymentScreen(
                                          isCart: true,
                                        ));
                                  }));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.person_pin_outlined),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Select',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AddAddressScreen.routeName,
                                arguments: address.id);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                            Provider.of<AddressProvider>(context, listen: false)
                                .removeAddress(address.id);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name'),
                      SizedBox(
                        height: 12,
                      ),
                      Text('Address'),
                      SizedBox(
                        height: (address.landmark.isNotEmpty) ? 65 : 46,
                      ),
                      Text('Mobile Number')
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.fullName),
                      SizedBox(
                        height: 12,
                      ),
                      Text('${address.street}, '
                          ' ${address.building}, '
                          ' ${address.floor}.'),
                      Text(
                        '${address.city}, '
                        '${address.governorate} Governorate',
                      ),
                      (address.landmark.isNotEmpty)
                          ? Text(address.landmark)
                          : SizedBox(),
                      SizedBox(
                        height: 25,
                      ),
                      Text(address.mobileNumber)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
