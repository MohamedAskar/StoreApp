import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/widgets/store_item.dart';

class StoreGridView extends StatelessWidget {
  final bool showFavorites;
  final String category;
  StoreGridView({
    this.showFavorites = false,
    this.category = '',
  });
  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<ItemsProvider>(context);
    final items =
        showFavorites ? itemsData.favoriteItems : itemsData.storeItems;
    final categoryItems =
        (category == 'Men') ? itemsData.menItems : itemsData.womenItems;
    return AnimationLimiter(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (category == '') ? items.length : categoryItems.length,
          itemBuilder: (context, i) {
            return AnimationConfiguration.staggeredGrid(
              position: i,
              duration: const Duration(milliseconds: 450),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: ChangeNotifierProvider.value(
                    value: (category.isEmpty) ? items[i] : categoryItems[i],
                    child: StoreItem(),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
