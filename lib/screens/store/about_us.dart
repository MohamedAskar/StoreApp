import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  final Uri _emailUri = Uri(scheme: 'mailto', path: 'mohamedasker11@gmail.com');
  static const facbookUrl = 'https://www.facebook.com/MohamedAskar11';
  static const twitterUrl = 'https://twitter.com/iAskoor';
  static const githubUrl = 'https://github.com/MohamedAskar';
  static const linkedinUrl = 'https://www.linkedin.com/in/mohamedaskar11/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: BackButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          'About us',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Developed by',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 12,
            ),
            CircleAvatar(
              radius: 90,
              backgroundImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/store-ef99f.appspot.com/o/Users%2Fmohamedasker11%40gmail.com%2Fscaled_image_picker1891820958.jpg?alt=media&token=ccb105a8-de87-44b0-83cb-50f1a7dea9ac'),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Mohamed Askar',
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              children: [
                SocialMediaButton(
                    buttonColor: Color(0xFFDB4437),
                    icon: MaterialCommunityIcons.email,
                    iconColor: Colors.white,
                    text: 'Email',
                    textColor: Colors.white,
                    function: () => launch(_emailUri.toString())),
                SocialMediaButton(
                    buttonColor: Color(0xFF211f1f),
                    icon: FontAwesome.github,
                    iconColor: Colors.white,
                    text: 'GitHub',
                    textColor: Colors.white,
                    function: () => launch(githubUrl)),
                SocialMediaButton(
                    buttonColor: Color(0xFF2867B2),
                    icon: FontAwesome.linkedin,
                    iconColor: Colors.white,
                    text: 'LinkedIn',
                    textColor: Colors.white,
                    function: () => launch(linkedinUrl)),
                SocialMediaButton(
                    buttonColor: Color(0xFF1877F2),
                    icon: FontAwesome.facebook_f,
                    iconColor: Colors.white,
                    text: 'Facebook',
                    textColor: Colors.white,
                    function: () => launch(facbookUrl)),
                SocialMediaButton(
                    buttonColor: Color(0xFF1DA1F2),
                    icon: FontAwesome.twitter,
                    iconColor: Colors.white,
                    text: 'Twitter',
                    textColor: Colors.white,
                    function: () => launch(twitterUrl)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final Color buttonColor;
  final Color iconColor;
  final Color textColor;
  final String text;
  final Function function;
  final IconData icon;

  SocialMediaButton(
      {@required this.buttonColor,
      @required this.icon,
      @required this.iconColor,
      @required this.text,
      @required this.textColor,
      @required this.function});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: MaterialButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        color: buttonColor,
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                  color: textColor, fontSize: 15, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }
}
