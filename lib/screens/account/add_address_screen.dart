import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/addresses_provider.dart';
import 'package:store/models/address.dart';

class AddAddressScreen extends StatefulWidget {
  static const routeName = '/add-address-screen';

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _typeAheadController = TextEditingController();

  Address _editedAddress = Address(
    id: null,
    city: '',
    floor: '',
    street: '',
    type: null,
    fullName: '',
    building: '',
    landmark: '',
    governorate: '',
    mobileNumber: '',
  );

  var _isInit = true;
  var edit = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final addressId = ModalRoute.of(context).settings.arguments as String;
      if (addressId != null) {
        _editedAddress =
            Provider.of<AddressProvider>(context).findById(addressId);
        setState(() {
          edit = true;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    final address = Provider.of<AddressProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
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
            'Add Address',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: ProgressHUD(
          barrierColor: Colors.transparent,
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, bottom: 12),
                      child: Text(
                        'Address information',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      color: Colors.white,
                      child: FormBuilder(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              FormBuilderTextField(
                                initialValue: _editedAddress.fullName,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                validators: [
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(8),
                                ],
                                attribute: 'Full Name',
                                keyboardType: TextInputType.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.black,
                                  ),
                                  fillColor: Colors.black,
                                  labelText: 'Full Name*',
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 16),
                              FormBuilderPhoneField(
                                initialValue: _editedAddress.mobileNumber,
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
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.black,
                                  ),
                                  fillColor: Colors.black,
                                  labelText: 'Mobile Phone*',
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 16),
                              FormBuilderTypeAhead(
                                initialValue: _editedAddress.governorate,
                                validators: [
                                  FormBuilderValidators.required(),
                                  (governorate) {
                                    if (GovernorateService.cities
                                        .contains(governorate)) {
                                      return null;
                                    } else {
                                      return 'Choose a valid governorate.';
                                    }
                                  }
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.black,
                                  labelText: 'Governorate*',
                                  prefixIcon: Icon(
                                    Icons.location_city_outlined,
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
                                textFieldConfiguration: TextFieldConfiguration(
                                  textInputAction: TextInputAction.next,
                                  controller: this._typeAheadController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                attribute: 'Governorate',
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
                                  return GovernorateService.getSuggestions(
                                      pattern);
                                },
                                onSuggestionSelected: (suggestion) {
                                  this._typeAheadController.text = suggestion;
                                },
                              ),
                              SizedBox(height: 16),
                              FormBuilderTextField(
                                initialValue: _editedAddress.city,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                                attribute: 'City',
                                keyboardType: TextInputType.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.black,
                                  labelText: 'City*',
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              FormBuilderTextField(
                                initialValue: _editedAddress.street,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                                attribute: 'Street',
                                keyboardType: TextInputType.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.black,
                                  labelText: 'Street*',
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: FormBuilderTextField(
                                      initialValue: _editedAddress.building,
                                      textInputAction: TextInputAction.next,
                                      validators: [
                                        FormBuilderValidators.numeric(),
                                      ],
                                      attribute: 'Building',
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Colors.black,
                                        labelText: 'Building',
                                        labelStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: FormBuilderTextField(
                                      initialValue: _editedAddress.floor,
                                      textInputAction: TextInputAction.next,
                                      validators: [
                                        FormBuilderValidators.numeric(),
                                      ],
                                      attribute: 'Floor',
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        fillColor: Colors.black,
                                        labelText: 'Floor',
                                        labelStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              FormBuilderTextField(
                                initialValue: _editedAddress.landmark,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.done,
                                attribute: 'Landmark',
                                keyboardType: TextInputType.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.black,
                                  labelText: 'Landmark (Optional)',
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              FormBuilderChoiceChip(
                                initialValue: _editedAddress.type,
                                attribute: 'Type',
                                alignment: WrapAlignment.center,
                                spacing: 20,
                                backgroundColor: Colors.white,
                                selectedColor: Colors.black12,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.black,
                                  labelText: 'Location Type',
                                  labelStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                                options: [
                                  FormBuilderFieldOption(
                                    child: SizedBox(
                                      width: 70,
                                      child: Row(
                                        children: [
                                          Icon(Icons.home_outlined),
                                          Text('Home'),
                                        ],
                                      ),
                                    ),
                                    value: AddressType.Home,
                                  ),
                                  FormBuilderFieldOption(
                                    child: SizedBox(
                                      width: 70,
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_city_outlined),
                                          Text('Office'),
                                        ],
                                      ),
                                    ),
                                    value: AddressType.Office,
                                  )
                                ],
                              )
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
                            print(formInputs);
                            try {
                              await Future.delayed(Duration(seconds: 3),
                                  () async {
                                if (edit) {
                                  await address.updateAddress(
                                      _editedAddress.id,
                                      Address(
                                        id: '',
                                        type: formInputs['Type'],
                                        city: formInputs['City'],
                                        floor: formInputs['Floor'],
                                        street: formInputs['Street'],
                                        building: formInputs['Building'],
                                        landmark: formInputs['Landmark'],
                                        fullName: formInputs['Full Name'],
                                        governorate: formInputs['Governorate'],
                                        mobileNumber:
                                            formInputs['Mobile Number'],
                                      ));
                                } else {
                                  address.storeAddress(
                                    isHome:
                                        (formInputs['Type'] == AddressType.Home)
                                            ? true
                                            : false,
                                    city: formInputs['City'],
                                    floor: formInputs['Floor'],
                                    street: formInputs['Street'],
                                    building: formInputs['Building'],
                                    landmark: formInputs['Landmark'],
                                    fullName: formInputs['Full Name'],
                                    governorate: formInputs['Governorate'],
                                    mobileNumber: formInputs['Mobile Number'],
                                  );
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
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              edit ? 'Save Address' : 'Add new Address',
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
        ));
  }
}

class GovernorateService {
  static final List<String> cities = [
    'Alexandria',
    'Aswan',
    'Asyut',
    'Beheira',
    'Beni Suef',
    'Cairo',
    'Damietta',
    'Faiyum',
    'Gharbia',
    'Giza',
    'Ismailia',
    'Kafr El Sheikh',
    'Luxor',
    'Matruh',
    'Minya',
    'Monufia',
    'New Valley',
    'North Sinai',
    'Port Said',
    'Qalyubia',
    'Qena',
    'Red Sea',
    'Sharqia',
    'Sohag',
    'South Sinai',
    'Suez',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
