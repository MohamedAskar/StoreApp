import 'package:flutter/material.dart';

class Kids extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kids',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text('Data to be filled out...')
          ],
        ),
      ),
    );
  }
}
