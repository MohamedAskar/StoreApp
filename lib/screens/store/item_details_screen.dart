import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/models/item.dart';
import 'package:store/screens/store/store_bottomsheet_cart.dart';

// ignore: must_be_immutable
class ItemDetailsScreen extends StatefulWidget {
  static const routeName = '/Item-Details-Screen';

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final ValueNotifier<bool> notifierFloatingButton = ValueNotifier(false);
  final _controller = PageController(initialPage: 0);
  List<dynamic> itemSizes = [];
  String sizes = '';

  Future<void> openShoppingCart(BuildContext context, Item storeItem) async {
    notifierFloatingButton.value = false;
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, animation1, __) {
          return FadeTransition(
            opacity: animation1,
            child: StoreBottomSheetCart(
              storeItem: storeItem,
            ),
          );
        }));
    notifierFloatingButton.value = true;
  }

  Widget _buildCursor(BuildContext context, Item storeItem) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.42,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Hero(
              tag: 'background_${storeItem.name}',
              child: Container(
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            top: 10,
            child: Hero(
              tag: 'model_${storeItem.name}',
              child: Material(
                color: Colors.transparent,
                child: FittedBox(
                  child: Text(
                    storeItem.category,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.08),
                        fontFamily: 'Wavehaus',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          PageView.builder(
              itemCount: storeItem.images.length,
              controller: _controller,
              itemBuilder: (context, index) {
                final tag = index == 0
                    ? 'image_${storeItem.name}'
                    : 'image_${storeItem.name}_$index';
                return Container(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: tag,
                    child: CachedNetworkImage(
                      imageUrl: storeItem.images[index],
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              }),
          Positioned(
            right: size.width / 2 - 19,
            bottom: 10,
            child: SmoothPageIndicator(
              count: storeItem.images.length,
              controller: _controller,
              effect: WormEffect(
                  activeDotColor: Colors.black,
                  dotColor: Colors.grey,
                  radius: 8.0,
                  dotHeight: 8.0,
                  dotWidth: 8.0),
            ),
          )
        ],
      ),
    );
  }

  void toggleFavorite(Item item) async {
    final user = await FirebaseAuth.instance.currentUser();
    final favRef = Firestore.instance
        .collection('Users')
        .document(user.email)
        .collection('Favorites')
        .document(item.id);
    var favItem = await favRef.get();
    if (favItem.exists) {
      favRef.delete();
      setState(() {
        item.isFavorite = false;
      });
    } else {
      favRef.setData({
        'name': item.name,
        'price': item.price,
        'category': item.category,
        'images': item.images.first,
      });
      setState(() {
        item.isFavorite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Theme.of(context).cardColor);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifierFloatingButton.value = true;
    });
    final itemId = ModalRoute.of(context).settings.arguments;
    final storeItem = Provider.of<ItemsProvider>(
      context,
      listen: false,
    ).findById(itemId);

    itemSizes = storeItem.sizes;
    var concatenate = StringBuffer();
    itemSizes.forEach((element) {
      concatenate.write('EU ' + element + '      ');
    });
    sizes = concatenate.toString();

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: [
                _buildCursor(context, storeItem),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 6.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ShakeTransition(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(storeItem.name,
                                    style:
                                        Theme.of(context).textTheme.headline1),
                                const Spacer(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Price',
                                          style: TextStyle(
                                            fontFamily: 'Wavehaus',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black54,
                                          )),
                                      Text('\$${storeItem.price.toString()}',
                                          style: TextStyle(
                                            fontFamily: 'Wavehaus',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ShakeTransition(
                          duration: const Duration(milliseconds: 1100),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 8, 8, 8),
                            child: Text(
                              'AVAILABLE SIZES',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ShakeTransition(
                            duration: const Duration(milliseconds: 1100),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 8, 20),
                              child: Text(
                                sizes,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                            )),
                        ShakeTransition(
                          duration: const Duration(milliseconds: 1100),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 8, 8, 8),
                            child: Text(
                              'DESCRIPTION',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Text(
                            storeItem.description,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: notifierFloatingButton,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: 'button 1',
                      backgroundColor: Colors.white,
                      onPressed: () {
                        toggleFavorite(storeItem);
                      },
                      child: Icon(
                        storeItem.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: storeItem.isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                    Spacer(),
                    FloatingActionButton(
                      heroTag: 'button 2',
                      backgroundColor: Colors.black,
                      onPressed: () {
                        openShoppingCart(context, storeItem);
                      },
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              builder: (context, value, child) {
                return AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    left: 0,
                    right: 0,
                    bottom: value ? 0.0 : -kToolbarHeight * 1.5,
                    child: child);
              }),
        ],
      ),
    );
  }
}

class ShakeTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final Axis axis;

  const ShakeTransition({
    Key key,
    this.duration = const Duration(milliseconds: 1400),
    this.offset = 140.0,
    @required this.child,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      child: child,
      duration: duration,
      curve: Curves.elasticOut,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: axis == Axis.horizontal
              ? Offset(
                  value * offset,
                  0.0,
                )
              : Offset(
                  0.0,
                  value * offset,
                ),
          child: child,
        );
      },
    );
  }
}
