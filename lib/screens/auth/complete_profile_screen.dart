import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:store/Provider/auth.dart';
import 'package:store/main_screens/home_screen.dart';

class PhoneScreen extends StatefulWidget {
  static const routeName = '/phone-screen';
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _auth = Auth();
  File _image;
  Future<String> token;

  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging();
    token = fcm.getToken();
  }

  pickImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);
    _cropImage(image.path);
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
    );
    if (croppedImage != null) {
      setState(() {
        _image = croppedImage;
      });
    }
  }

  Future<String> uploadImage(File file, String email) async {
    FirebaseStorage firebaseStorage =
        FirebaseStorage(storageBucket: 'gs://store-ef99f.appspot.com');
    StorageReference reference =
        firebaseStorage.ref().child('Users/$email/${path.basename(file.path)}');
    StorageUploadTask storageUploadTask = reference.putFile(file);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user = ModalRoute.of(context).settings.arguments;
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        barrierColor: Colors.transparent,
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).maybePop();
                        },
                        child: Icon(
                          Icons.clear_outlined,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Complete your Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 120,
                          backgroundColor: Colors.black12.withOpacity(0.09),
                          backgroundImage:
                              _image == null ? null : FileImage(_image),
                          child: _image == null
                              ? Icon(
                                  Icons.person_outline,
                                  color: Colors.black,
                                  size: 120,
                                )
                              : null,
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: GestureDetector(
                            onTap: pickImage,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormBuilderPhoneField(
                            validators: [
                              FormBuilderValidators.numeric(),
                              FormBuilderValidators.required()
                            ],
                            defaultSelectedCountryIsoCode: 'EG',
                            maxLength: 10,
                            countryFilterByIsoCode: ['EG'],
                            textInputAction: TextInputAction.next,
                            isSearchable: false,
                            enableInteractiveSelection: true,
                            attribute: 'Mobile Number',
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Colors.black,
                              labelText: 'Mobile Phone*',
                              labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          FormBuilderDateTimePicker(
                            attribute: 'Date',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            format: DateFormat.yMMMMd('en_US'),
                            lastDate: DateTime.now(),
                            inputType: InputType.date,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                              ),
                              labelText: 'Birth Date',
                              fillColor: Colors.black,
                              labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                            ),
                            validator: (val) => null,
                            // locale: Locale('ru'),
                            initialTime: TimeOfDay(hour: 8, minute: 0),
                            // initialValue: DateTime.now(),
                            // readonly: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FormBuilderRadioGroup(
                            orientation: GroupedRadioOrientation.horizontal,
                            separator: SizedBox(
                              width: 100,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                            ),
                            attribute: 'Gender',
                            validators: [FormBuilderValidators.required()],
                            options: [
                              'Male',
                              'Female',
                            ]
                                .map((gender) => FormBuilderFieldOption(
                                      value: gender,
                                      child: Text(
                                        '$gender',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ))
                                .toList(growable: false),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final progress = ProgressHUD.of(context);
                      progress.showWithText('Loading...');
                      if (_formKey.currentState.saveAndValidate()) {
                        final formInputs = _formKey.currentState.value;
                        print(formInputs);
                        try {
                          final pictureUrl =
                              await uploadImage(_image, user['email']);
                          await _auth.signUp(
                              email: user['email'],
                              password: user['password'],
                              name: user['fullName'],
                              profilePicture: pictureUrl,
                              phoneNumber: formInputs['Mobile Number'],
                              birthDate: formInputs['Date'],
                              token: await token,
                              gender: formInputs['Gender']);
                          progress.dismiss();
                          Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 150),
                                  opaque: false,
                                  pageBuilder: (_, animation1, __) {
                                    return SlideTransition(
                                        position: Tween(
                                                begin: Offset(1.0, 0.0),
                                                end: Offset(0.0, 0.0))
                                            .animate(animation1),
                                        child: StoreHome());
                                  }));
                        } on PlatformException catch (e) {
                          progress.dismiss();
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text('An error occurred!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  content: Text(
                                    e.message,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Okay',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      onPressed: () => Navigator.of(ctx).pop(),
                                    ),
                                  ],
                                );
                              });
                        }
                      }
                      progress.dismiss();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
