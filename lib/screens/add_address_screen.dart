import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddAddressScreen extends StatelessWidget {
  static const routeName = '/add-address-screen';
  //final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            color: Colors.black,
          ),
          title: Image.asset(
            'assets/images/logo.png',
            height: 70,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, bottom: 12),
                  child: Text(
                    'Personal information',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(0),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  color: Colors.white,

                  // child: Column(
                  //   children: [
                  //     Form(
                  //       key: _form,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(16.0),
                  //         child: Column(
                  //           children: [
                  //             TextFormField(
                  //               keyboardType: TextInputType.emailAddress,
                  //               style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.w600),
                  //               decoration: InputDecoration(
                  //                 prefixIcon: Icon(
                  //                   Icons.person_outline,
                  //                   color: Colors.black,
                  //                 ),
                  //                 fillColor: Colors.black,
                  //                 labelText: 'Full Name*',
                  //                 labelStyle: TextStyle(
                  //                     color: Colors.black54,
                  //                     fontWeight: FontWeight.w600),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 16,
                  //             ),
                  //             TextFormField(
                  //               keyboardType: TextInputType.emailAddress,
                  //               style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.w600),
                  //               decoration: InputDecoration(
                  //                 prefixIcon: Icon(
                  //                   Icons.call_outlined,
                  //                   color: Colors.black,
                  //                 ),
                  //                 fillColor: Colors.black,
                  //                 labelText: 'Mobile Number*',
                  //                 labelStyle: TextStyle(
                  //                     color: Colors.black54,
                  //                     fontWeight: FontWeight.w600),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  color: Colors.black,
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Text(
                        'Add new Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
