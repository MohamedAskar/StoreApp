import 'package:flutter/material.dart';

class OrdersPageView extends StatefulWidget {
  @override
  _OrdersPageViewState createState() => _OrdersPageViewState();
}

class _OrdersPageViewState extends State<OrdersPageView> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 3,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 10),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              child: Center(child: Image.asset('assets/images/box.png')),
            ),
          );
        },
      ),
    );
  }
}
