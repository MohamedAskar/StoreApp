import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/models/item.dart';
import 'package:path/path.dart' as path;

class EditItemScreen extends StatefulWidget {
  static const routeName = '/edit-item-screen';

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _categoryController = TextEditingController();

  Future<String> uploadImage(File file, String folderName) async {
    FirebaseStorage firebaseStorage =
        FirebaseStorage(storageBucket: 'gs://store-ef99f.appspot.com');
    StorageReference reference = firebaseStorage
        .ref()
        .child('shoes/$folderName/${path.basename(file.path)}');
    StorageUploadTask storageUploadTask = reference.putFile(file);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  final List<String> sizes = [
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47'
  ];

  Item _editedItem = Item(
      id: null,
      name: '',
      price: 0.0,
      images: [],
      category: '',
      sizes: [],
      description: '');

  var _isInit = true;

  var edit = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final itemId = ModalRoute.of(context).settings.arguments as String;
      if (itemId != null) {
        _editedItem = Provider.of<ItemsProvider>(context).findById(itemId);
        setState(() {
          edit = true;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          height: 35,
        ),
      ),
      body: ProgressHUD(
        barrierColor: Colors.transparent,
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, bottom: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add new item',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        edit
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Provider.of<ItemsProvider>(context,
                                          listen: false)
                                      .deleteItem(_editedItem.id);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.red[400],
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red[400],
                                      ),
                                    ),
                                  ],
                                ))
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(0),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    color: Colors.white,
                    child: FormBuilder(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormBuilderTextField(
                              initialValue: !edit ? null : _editedItem.name,
                              attribute: 'Name',
                              validators: [
                                FormBuilderValidators.minLength(6),
                                FormBuilderValidators.required(),
                              ],
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.title,
                                  color: Colors.black54,
                                ),
                                fillColor: Colors.black,
                                hintText: 'Please enter item name',
                                hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                labelText: 'Name*',
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: FormBuilderTextField(
                                    initialValue: !edit
                                        ? null
                                        : _editedItem.price.toString(),
                                    attribute: 'Price',
                                    validators: [
                                      FormBuilderValidators.required(),
                                    ],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.attach_money_outlined,
                                        color: Colors.black54,
                                      ),
                                      fillColor: Colors.black,
                                      hintText: 'Please enter item price',
                                      hintStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      labelText: 'Price',
                                      labelStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Flexible(
                                  child: FormBuilderTypeAhead(
                                    initialValue:
                                        !edit ? null : _editedItem.category,
                                    validators: [
                                      FormBuilderValidators.required(),
                                      (category) {
                                        if (CategoryService.category
                                            .contains(category)) {
                                          return null;
                                        } else {
                                          return 'Choose a valid category';
                                        }
                                      }
                                    ],
                                    attribute: 'Category',
                                    decoration: InputDecoration(
                                      fillColor: Colors.black,
                                      labelText: 'Category',
                                      hintText: 'Enter item Category',
                                      hintStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      prefixIcon: Icon(
                                        Icons.category_outlined,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    suggestionsBoxDecoration:
                                        SuggestionsBoxDecoration(
                                            hasScrollbar: true),
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      textInputAction: TextInputAction.next,
                                      controller: this._categoryController,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(
                                          suggestion,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      );
                                    },
                                    suggestionsCallback: (pattern) {
                                      return CategoryService.getSuggestions(
                                          pattern);
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      this._categoryController.text =
                                          suggestion;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            FormBuilderImagePicker(
                              attribute: 'pick',
                              initialValue: [
                                edit
                                    ? CachedNetworkImage(
                                        imageUrl: _editedItem.images[0],
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                    : null,
                                edit
                                    ? CachedNetworkImage(
                                        imageUrl: _editedItem.images[1],
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                    : null,
                                edit
                                    ? CachedNetworkImage(
                                        imageUrl: _editedItem.images[2],
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                    : null,
                              ],
                              cameraIcon: Icon(Icons.add_a_photo_outlined),
                              galleryIcon: Icon(Icons.image_outlined),
                              imageMargin: const EdgeInsets.only(right: 10),
                              decoration: const InputDecoration(
                                labelText: 'Images',
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              ),

                              maxImages: 3,

                              iconColor: Colors.black,
                              // readOnly: true,
                              validators: [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(3),
                                (images) {
                                  if (images.length < 2) {
                                    return 'Two or more images required.';
                                  }
                                  return null;
                                }
                              ],
                            ),
                            FormBuilderTextField(
                              initialValue:
                                  !edit ? null : _editedItem.description,
                              attribute: 'Description',
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                              minLines: 5,
                              maxLines: 6,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.description_outlined,
                                  color: Colors.black54,
                                ),
                                fillColor: Colors.black,
                                hintText: 'Enter item Description',
                                hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            FormBuilderFilterChip(
                              initialValue: !edit ? null : _editedItem.sizes,
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                              alignment: WrapAlignment.start,
                              spacing: 20,
                              backgroundColor: Colors.white,
                              selectedColor: Colors.black12,
                              decoration: InputDecoration(
                                fillColor: Colors.black,
                                labelText: 'Available Sizes',
                                labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              ),
                              attribute: 'Size',
                              options: [
                                ...sizes.map(
                                  (e) => FormBuilderFieldOption(
                                    value: e,
                                    child: Text('EU ' + e),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final progress = ProgressHUD.of(context);
                        progress.showWithText('Loading...');
                        if (_formKey.currentState.saveAndValidate()) {
                          final formInputs = _formKey.currentState.value;
                          List<String> chosenSizes = [];
                          List<dynamic> files = formInputs['pick'];
                          List<String> pickedImages = [];
                          Future<String> _url;
                          for (var i in formInputs['Size']) {
                            chosenSizes.add(i);
                          }
                          chosenSizes.sort(
                              (a, b) => int.parse(a).compareTo(int.parse(b)));

                          //print(formInputs);

                          try {
                            for (var i = 0; i < files.length; i++) {
                              if (files[i] is File) {
                                _url =
                                    uploadImage(files[i], formInputs['Name']);
                                await _url.then((value) {
                                  pickedImages.add(value);

                                  //print(_image);
                                });
                              } else {
                                pickedImages.add(_editedItem.images[i]);
                              }
                            }
                            print(pickedImages.length);

                            await Future.delayed(Duration(seconds: 6),
                                () async {
                              if (edit) {
                                await Provider.of<ItemsProvider>(context,
                                        listen: false)
                                    .updateItem(
                                  id: _editedItem.id,
                                  updatedItem: Item(
                                      id: '',
                                      name: formInputs['Name'],
                                      price: double.parse(formInputs['Price']),
                                      images: pickedImages,
                                      category: formInputs['Category'],
                                      sizes: chosenSizes,
                                      description: formInputs['Description'],
                                      isFavorite: false),
                                );
                              } else {
                                Provider.of<ItemsProvider>(context,
                                        listen: false)
                                    .addItem(Item(
                                        id: '',
                                        name: formInputs['Name'],
                                        price:
                                            double.parse(formInputs['Price']),
                                        images: pickedImages,
                                        category: formInputs['Category'],
                                        sizes: chosenSizes,
                                        description: formInputs['Description'],
                                        isFavorite: false));
                              }
                              progress.dismiss();
                              Navigator.of(context).pop();
                            });
                          } on PlatformException catch (e) {
                            progress.dismiss();
                            print(e.message);
                          }
                        }
                        progress.dismiss();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        padding: const EdgeInsets.all(16),
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            edit ? 'Update item' : 'Add item',
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
      ),
    );
  }
}

class CategoryService {
  static final List<String> category = ['Men', 'Women', 'Kids'];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(category);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
