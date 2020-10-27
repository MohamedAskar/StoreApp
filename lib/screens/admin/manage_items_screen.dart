import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/screens/admin/Edit_item_screen.dart';

class ManageItemsScreen extends StatelessWidget {
  static const routeName = '/manage-items-screen';
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<ItemsProvider>(context).items;
    var width = MediaQuery.of(context).size.width - 72;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.maybePop(context);
                    },
                    child: Icon(
                      Icons.clear_outlined,
                      size: 25,
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Manage Items',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(EditItemScreen.routeName);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 142,
            child: SingleChildScrollView(
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (context, i) {
                    return AnimationConfiguration.staggeredList(
                      position: i,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Card(
                            color: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.only(
                                right: 16, left: 16, bottom: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    EditItemScreen.routeName,
                                    arguments: items[i].id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                height: 120,
                                width: width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width / 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            items[i].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                            textScaleFactor: 0.8,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            '\$${items[i].price}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          )
                                        ],
                                      ),
                                    ),
                                    CachedNetworkImage(
                                      imageUrl: items[i].images.first,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
