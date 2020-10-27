import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/widgets/store/store_grid.dart';

class NewRelease extends StatefulWidget {
  @override
  _NewReleaseState createState() => _NewReleaseState();
}

class _NewReleaseState extends State<NewRelease> {
  List<String> canvas = [
    'https://firebasestorage.googleapis.com/v0/b/store-ef99f.appspot.com/o/carousel%2Fcanvas1.jpg?alt=media&token=f453cc22-302b-4e1a-8cbf-5637913bbf92',
    'https://firebasestorage.googleapis.com/v0/b/store-ef99f.appspot.com/o/carousel%2Fcanvas2.jpg?alt=media&token=273a57bd-0529-4a18-b45d-a79f1a3a6293',
    'https://firebasestorage.googleapis.com/v0/b/store-ef99f.appspot.com/o/carousel%2Fcanvas5.jpg?alt=media&token=fb4d2f11-778f-4148-a231-9f9807881af8',
    'https://firebasestorage.googleapis.com/v0/b/store-ef99f.appspot.com/o/carousel%2Fcanvas3.jpg?alt=media&token=c06815b4-7388-46ec-b810-cd7ae568816f',
    'https://firebasestorage.googleapis.com/v0/b/store-ef99f.appspot.com/o/carousel%2Fcanvas4.jpg?alt=media&token=92ca7785-5482-4622-aa82-00065bda97af',
  ];
  int _currentPage = 0;
  final _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 4) {
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
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 350,
                child: PageView.builder(
                  itemCount: canvas.length,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: canvas[index],
                      fit: BoxFit.fill,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Container(
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.progress,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  },
                ),
              ),
              Positioned(
                right: size.width / 2 - 32,
                bottom: 10,
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 5,
                  effect: WormEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey,
                      radius: 8.0,
                      dotHeight: 8.0,
                      dotWidth: 8.0),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              'Top Picks',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          FutureBuilder(
              future: Provider.of<ItemsProvider>(context).getItems(),
              builder: (context, snapshot) {
                return StoreGridView();
              }),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Most selling',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          SizedBox(
            height: kBottomNavigationBarHeight,
          )
        ],
      ),
    );
  }
}
