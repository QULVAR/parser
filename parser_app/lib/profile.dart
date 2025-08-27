import 'package:flutter/material.dart';
import 'package:pki_frontend_app/auth.dart';
import 'package:pki_frontend_app/resizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  double _left = 390.w;

  void moveToX (double left) {
    setState(() {
      _left = left;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInCirc,
      top: 0,
      left: _left,
      child: Text('${Api.I.me()}'));
  }

}