import 'package:flutter/material.dart';
import 'package:store/widgets/store_grid.dart';

class Men extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Men',
              style: Theme.of(context).textTheme.headline2,
            ),
            StoreGridView(
              category: 'Men',
            )
          ],
        ),
      ),
    );
  }
}
