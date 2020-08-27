import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/cart.dart';
import 'package:store/models/item.dart';

const _buttonSizeWidth = 170.0;
const _buttonSizeHeight = 65.0;
const _buttonCircularSize = 65.0;
const _finalImageSize = 25.0;
const _imageSize = 100.0;

class StoreBottomSheetCart extends StatefulWidget {
  static const routeName = '/bottom-sheet-cart';
  final Item storeItem;

  const StoreBottomSheetCart({Key key, @required this.storeItem})
      : super(key: key);

  @override
  _StoreBottomSheetCartState createState() => _StoreBottomSheetCartState();
}

class _StoreBottomSheetCartState extends State<StoreBottomSheetCart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animationResize;
  Animation _animationMovementIn;
  Animation _animationMovementOut;
  int quantity = 1;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _animationResize = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.2,
        ),
      ),
    );
    _animationMovementIn = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.3,
          0.6,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );
    _animationMovementOut = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.6,
          1.0,
          curve: Curves.elasticIn,
        ),
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop(true);
      }
    });
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentImageSize = (_imageSize * _animationResize.value)
        .clamp(_finalImageSize, _imageSize);
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            0.0,
            value * size.height * 0.6,
          ),
          child: child,
        );
      },
      child: Container(
        height: (size.height * 0.5 * _animationResize.value).clamp(
          _buttonCircularSize,
          size.height * 0.5,
        ),
        width: (size.width * 0.65 * _animationResize.value).clamp(
          _buttonCircularSize,
          size.width * 0.65,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: _animationResize.value == 1
                ? Radius.circular(0)
                : Radius.circular(30.0),
            bottomRight: _animationResize.value == 1
                ? Radius.circular(0)
                : Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: (_animationResize.value == 1)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    widget.storeItem.images.first,
                    height: currentImageSize,
                  ),
                  if (_animationResize.value == 1) ...[
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      children: [
                        Text(widget.storeItem.name,
                            style: TextStyle(
                              fontFamily: 'Wavehaus',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            )),
                        Text('\$${widget.storeItem.price.toString()}',
                            style: TextStyle(
                              fontFamily: 'Wavehaus',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ]
                ],
              ),
            ),
            (_animationResize.value != 1)
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20.0, bottom: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Quantity:',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                    });
                                  } else {
                                    return;
                                  }
                                },
                                icon: Icon(
                                  Icons.remove_circle,
                                  size: 20,
                                )),
                            Text(
                              '$quantity',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            IconButton(
                                onPressed: () {
                                  if (quantity < 10) {
                                    setState(() {
                                      quantity++;
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.add_circle,
                                  size: 20,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20.0, bottom: 10.0),
                        child: Text(
                          'Choose your size:',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                StoreItemSize(
                                  size: 'EU 44',
                                ),
                                StoreItemSize(
                                  size: 'EU 44',
                                ),
                                StoreItemSize(
                                  size: 'EU 44',
                                ),
                                StoreItemSize(
                                  size: 'EU 44',
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StoreItemSize(
                                  size: 'EU 44',
                                ),
                                StoreItemSize(
                                  size: 'EU 44',
                                ),
                                StoreItemSize(
                                  size: 'EU 44',
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context);

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final buttonSizeWidth =
                (_buttonSizeWidth * _animationResize.value).clamp(
              _buttonCircularSize,
              _buttonSizeWidth,
            );
            final panelSizeWidth = (size.width * _animationResize.value)
                .clamp(_buttonCircularSize, size.width);
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.black87,
                    ),
                  ),
                ),
                Positioned.fill(
                    child: Stack(
                  children: [
                    if (_animationMovementIn.value != 1)
                      Positioned(
                        top: size.height * 0.5 +
                            (_animationMovementIn.value * size.height * 0.3875),
                        left: size.width / 2 - panelSizeWidth / 2,
                        width: panelSizeWidth,
                        child: _buildBottomSheet(context),
                      ),
                    Positioned(
                      bottom: 40 - (_animationMovementOut.value * 120),
                      left: size.width / 2 - buttonSizeWidth / 2,
                      child: TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                        tween: Tween(begin: 1.0, end: 0.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(
                              0.0,
                              value * size.height * 0.6,
                            ),
                            child: child,
                          );
                        },
                        child: InkWell(
                          onTap: () {
                            _controller.forward();
                            cart.addItem(
                                id: widget.storeItem.id,
                                name: widget.storeItem.name,
                                price: widget.storeItem.price,
                                image: widget.storeItem.images.first,
                                quantityWanted: quantity,
                                size: '45');
                          },
                          child: Container(
                            width: buttonSizeWidth,
                            height: (_buttonSizeHeight * _animationResize.value)
                                .clamp(
                              _buttonCircularSize,
                              _buttonSizeHeight,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      (_animationMovementIn.value == 1)
                                          ? Icons.shopping_bag
                                          : Icons.shopping_bag_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (_animationResize.value == 1) ...[
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'ADD TO CART',
                                      style: TextStyle(
                                        fontFamily: 'Wavehaus',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
              ],
            );
          }),
    );
  }
}

class StoreItemSize extends StatefulWidget {
  final String size;

  const StoreItemSize({Key key, this.size}) : super(key: key);

  @override
  _StoreItemSizeState createState() => _StoreItemSizeState();
}

class _StoreItemSizeState extends State<StoreItemSize> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8.0),
      margin: const EdgeInsets.only(right: 2, left: 8),
      child: FlatButton(
        onPressed: () {
          setState(() {
            _isButtonPressed = !_isButtonPressed;
          });
        },
        color: _isButtonPressed ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black, width: 1.5)),
        child: Text(
          '${widget.size.toString()}',
          style: TextStyle(
              fontFamily: 'Wavehaus',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: _isButtonPressed ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
