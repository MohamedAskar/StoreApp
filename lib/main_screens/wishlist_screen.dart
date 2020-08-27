import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/widgets/store_grid.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<ItemsProvider>(context);
    final favItem = itemsData.favoriteItems;
    print(favItem);
    return (favItem.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'My WishList',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 20,
                ),
                StoreGridView(
                  showFavorites: true,
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/box.png',
                      height: 80,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'There is no items in your WishList yet!',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          'There\'s nothing you like?',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
  }
}
