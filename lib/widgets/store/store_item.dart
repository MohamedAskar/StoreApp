import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/item.dart';
import 'package:store/screens/store/item_details_screen.dart';

class StoreItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Item>(
      context,
      listen: false,
    );
    const itemHeight = 180.0;
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ItemDetailsScreen.routeName, arguments: item.id);
        },
        child: Container(
          height: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).cardColor,
          ),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: 'model_${item.id}',
                    child: SizedBox(
                      height: itemHeight * 0.55,
                      child: Material(
                        color: Colors.transparent,
                        child: FittedBox(
                          child: Text(
                            item.category,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.08),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Positioned(
                top: 50,
                height: itemHeight * 0.45,
                child: Hero(
                  tag: 'image_${item.id}',
                  child: CachedNetworkImage(
                    imageUrl: item.images.first,
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
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 20,
                child: Consumer<Item>(
                  builder: (ctx, item, child) {
                    return GestureDetector(
                      onTap: () {
                        item.toggleFavorite();
                      },
                      child: Icon(
                        item.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                        color: item.isFavorite ? Colors.redAccent : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                  bottom: 15,
                  right: 20,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.grey,
                    size: 20,
                  )),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(item.name,
                          style: Theme.of(context).textTheme.bodyText1),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Text('\$${item.price}',
                          style: Theme.of(context).textTheme.bodyText1)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
