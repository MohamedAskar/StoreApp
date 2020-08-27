import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/picture.jpg'),
                  radius: 75.0,
                ),
              ),
            ),
            Text(
              'Mohamed Askar',
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              'mohamedasker11@gmail.com',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.black54,
                ),
                Text('Tanta, Egypt',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w600))
              ],
            )
          ],
        ),
      ],
    );
  }
}
