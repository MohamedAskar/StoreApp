import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:store/Provider/auth.dart';

class UserProfile extends StatefulWidget {
  static const routeName = '/user-profile';
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _auth = FirebaseAuth.instance;
  final _authentication = Auth();

  File _image;
  Future<String> token;

  pickImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);
    _cropImage(image.path);
  }

  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      androidUiSettings: AndroidUiSettings(
          hideBottomControls: true,
          showCropGrid: true,
          lockAspectRatio: false,
          toolbarColor: Colors.black,
          toolbarTitle: 'Edit Image',
          toolbarWidgetColor: Colors.white,
          statusBarColor: Colors.black),
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

  Future<String> uploadImage(File file, String folderName) async {
    final user = await _auth.currentUser();
    FirebaseStorage firebaseStorage =
        FirebaseStorage(storageBucket: 'gs://store-ef99f.appspot.com');
    StorageReference reference = firebaseStorage
        .ref()
        .child('Users/${user.email}/${path.basename(file.path)}');
    StorageUploadTask storageUploadTask = reference.putFile(file);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging();
    token = fcm.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: BackButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          'Update your Profile',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: StreamBuilder<FirebaseUser>(
          stream: _auth.onAuthStateChanged,
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return StreamBuilder(
                stream: Firestore.instance
                    .collection('Users')
                    .document(userSnapshot.data.email)
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  setbackground() {
                    if (userSnapshot.data.photoUrl.isNotEmpty &&
                        _image == null) {
                      return NetworkImage(userSnapshot.data.photoUrl);
                    }
                    if (_image != null) {
                      return FileImage(_image);
                    }
                    if (userSnapshot.data.photoUrl.isEmpty && _image == null) {
                      return null;
                    }
                  }

                  return ProgressHUD(
                    barrierColor: Colors.transparent,
                    child: Builder(builder: (context) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, bottom: 12, right: 12),
                                child: Text(
                                  'Personal Inforamtion',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Center(
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: 'profile',
                                            child: CircleAvatar(
                                              radius: 120,
                                              backgroundColor: Colors.black12
                                                  .withOpacity(0.09),
                                              backgroundImage: setbackground(),
                                              child: (_image == null &&
                                                      userSnapshot.data.photoUrl
                                                          .isEmpty)
                                                  ? Icon(
                                                      Icons.person_outline,
                                                      color: Colors.black,
                                                      size: 120,
                                                    )
                                                  : null,
                                            ),
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
                                                  Icons
                                                      .add_photo_alternate_outlined,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: FormBuilder(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            FormBuilderTextField(
                                              initialValue:
                                                  userSnapshot.data.email,
                                              attribute: 'Email',
                                              validators: [
                                                FormBuilderValidators.email(),
                                                FormBuilderValidators
                                                    .required(),
                                              ],
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              readOnly: true,
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              autocorrect: false,
                                              enableSuggestions: false,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons
                                                      .alternate_email_outlined,
                                                  color: Colors.black54,
                                                ),
                                                border: OutlineInputBorder(),
                                                fillColor: Colors.black,
                                                hintText: 'Enter your email',
                                                hintStyle: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                labelText: 'E-Mail',
                                                labelStyle: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(height: 14),
                                            FormBuilderTextField(
                                              attribute: 'Full Name',
                                              initialValue:
                                                  userSnapshot.data.displayName,
                                              validators: [
                                                FormBuilderValidators.minLength(
                                                    6),
                                                FormBuilderValidators
                                                    .required(),
                                              ],
                                              keyboardType: TextInputType.name,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                prefixIcon: Icon(
                                                  Icons.person_outline,
                                                  color: Colors.black54,
                                                ),
                                                fillColor: Colors.black,
                                                hintText:
                                                    'Enter your full name',
                                                hintStyle: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                labelText: 'Full name',
                                                labelStyle: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(height: 14),
                                            FormBuilderDateTimePicker(
                                              initialValue: dataSnapshot
                                                  .data['birthDate']
                                                  .toDate(),
                                              attribute: 'Date',

                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                              format:
                                                  DateFormat.yMMMMd('en_US'),
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              validator: (val) => null,
                                              // locale: Locale('ru'),
                                              initialTime:
                                                  TimeOfDay(hour: 8, minute: 0),
                                              // initialValue: DateTime.now(),
                                              // readonly: true,
                                            ),
                                            SizedBox(height: 14),
                                            FormBuilderPhoneField(
                                              initialValue: dataSnapshot
                                                  .data['phoneNumber'],
                                              validators: [
                                                FormBuilderValidators
                                                    .required(),
                                              ],
                                              defaultSelectedCountryIsoCode:
                                                  'EG',
                                              countryFilterByIsoCode: ['EG'],
                                              textInputAction:
                                                  TextInputAction.next,
                                              isSearchable: false,
                                              maxLength: 10,
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: MaterialButton(
                                  onPressed: () async {
                                    final progress = ProgressHUD.of(context);
                                    progress.showWithText('Loading...');
                                    if (_formKey.currentState
                                        .saveAndValidate()) {
                                      final formInputs =
                                          _formKey.currentState.value;

                                      print(formInputs);
                                      final pictureUrl = await uploadImage(
                                          _image, userSnapshot.data.email);
                                      print(pictureUrl);
                                      _authentication.updateUserProfile(
                                          profilePicture: pictureUrl,
                                          name: formInputs['Full Name'],
                                          birthDate: formInputs['Date'],
                                          phoneNumber:
                                              formInputs['Mobile Number'],
                                          token: await token);
                                      Future.delayed(Duration(seconds: 6), () {
                                        progress.dismiss();
                                        Navigator.of(context).maybePop();
                                      });
                                    }
                                    progress.dismiss();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    padding: const EdgeInsets.all(16),
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        'Update Profile',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                });
          }),
    );
  }
}
