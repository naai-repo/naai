import 'package:flutter/material.dart';
import 'package:naai/view/post_auth/set_location_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetupHome(),
            ),
          ),
          child: Text('Home'),
        ),
      ),
    );
  }
}
