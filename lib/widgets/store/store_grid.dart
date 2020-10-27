import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:store/Provider/items_provider.dart';
import 'package:store/widgets/store/store_item.dart';

class StoreGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemData = Provider.of<ItemsProvider>(context);

    return AnimationLimiter(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemData.items.length,
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, i) {
            return AnimationConfiguration.staggeredGrid(
              position: i,
              duration: const Duration(milliseconds: 450),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: ChangeNotifierProvider.value(
                      value: itemData.items[i], child: StoreItem()),
                ),
              ),
            );
          }),
    );
  }
}
