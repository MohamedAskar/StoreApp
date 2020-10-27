import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:store/models/store_location.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreLocators extends StatefulWidget {
  @override
  _StoreLocatorsState createState() => _StoreLocatorsState();
}

class _StoreLocatorsState extends State<StoreLocators> {
  List<Marker> branches = [];
  GoogleMapController mapController;
  LatLng _currentPosition;
  BitmapDescriptor customIcon;
  final _controller = PageController(initialPage: 0, viewportFraction: 0.8);

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void _getCurrentPosition() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      print(position);
      print('current Position: $_currentPosition');
    });
  }

  _initializeLocations() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/marker.png', 100);
    stores.forEach((branch) {
      branches.add(Marker(
          markerId: MarkerId(branch.name),
          draggable: false,
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
              title: branch.name,
              snippet: '${branch.address}\n${branch.branchPhoneNumber}'),
          position: branch.locationCoords));
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    _initializeLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Store Locations',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: _currentPosition == null
          ? Container(
              color: Colors.white,
              child: Center(
                child: JumpingDotsProgressIndicator(
                  fontSize: 40,
                ),
              ),
            )
          : Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_currentPosition.latitude,
                              _currentPosition.longitude),
                          zoom: 13.0,
                        ),
                        compassEnabled: true,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 30),
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        markers: Set.from(branches),
                        onMapCreated: mapCreated,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Container(
                            height: 5.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: stores.length,
                          onPageChanged: (value) {
                            _controller.animateToPage(value,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () => moveCamera(),
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                padding: const EdgeInsets.all(14),
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Image.asset(
                                        stores[index].thumbnail,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.7 -
                                                125,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              stores[index].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            SizedBox(height: 8),
                                            AutoSizeText(
                                              stores[index].address,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 120,
                                              child: MaterialButton(
                                                onPressed: () {
                                                  final Uri _phoneUri = Uri(
                                                      scheme: 'tel',
                                                      path: stores[index]
                                                          .branchPhoneNumber);
                                                  launch(_phoneUri.toString());
                                                },
                                                color: Colors.black,
                                                elevation: 1,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 4),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.call,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      'Call branch',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 15),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void mapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  moveCamera() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: stores[_controller.page.toInt()].locationCoords,
        zoom: 18,
        bearing: 45,
        tilt: 45)));
  }
}
