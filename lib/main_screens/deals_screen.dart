import 'dart:async';

import 'package:flutter/material.dart';

class DealsScreen extends StatefulWidget {
  static const routeName = '/deals-screen';
  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  int _currentPage = 0;
  final _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_controller.hasClients) {
        _controller.animateToPage(_currentPage,
            duration: Duration(milliseconds: 350), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Stack(
        //       children: [
        //         SizedBox(
        //           height: 360,
        //           child: PageView(
        //             controller: _controller,
        //             children: [
        //               Container(
        //                   decoration: BoxDecoration(
        //                 image: DecorationImage(
        //                   image: AssetImage('assets/images/canvas/canvas1.jpg'),
        //                   fit: BoxFit.fill,
        //                 ),
        //               )),
        //               Container(
        //                   decoration: BoxDecoration(
        //                 image: DecorationImage(
        //                   image: AssetImage('assets/images/canvas/canvas2.jpg'),
        //                   fit: BoxFit.fill,
        //                 ),
        //               )),
        //               Container(
        //                   decoration: BoxDecoration(
        //                 image: DecorationImage(
        //                   image: AssetImage('assets/images/canvas/canvas3.jpg'),
        //                   fit: BoxFit.fill,
        //                 ),
        //               )),
        //               Container(
        //                   decoration: BoxDecoration(
        //                 image: DecorationImage(
        //                   image: AssetImage('assets/images/canvas/canvas4.jpg'),
        //                   fit: BoxFit.fill,
        //                 ),
        //               )),
        //             ],
        //           ),
        //         ),
        //         Positioned(
        //           right: size.width / 2 - 20,
        //           bottom: 10,
        //           child: SmoothPageIndicator(
        //             controller: _controller,
        //             count: 4,
        //             effect: WormEffect(
        //                 activeDotColor: Colors.white,
        //                 dotColor: Colors.grey,
        //                 radius: 8.0,
        //                 dotHeight: 8.0,
        //                 dotWidth: 8.0),
        //           ),
        //         )
        //       ],
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(14.0),
        //       child: Text(
        //         'Hot Deals',
        //         style: Theme.of(context).textTheme.headline2,
        //       ),
        //     ),
        //     StoreGridView()
        //   ],
        // ),
        );
  }
}
