import 'package:flutter/material.dart';

class StoreAppBar extends StatelessWidget {
  final String headline;
  StoreAppBar(this.headline);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
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
            Text(
              headline,
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
    );
  }
}
