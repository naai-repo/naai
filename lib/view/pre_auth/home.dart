import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/view/utils/image_path_constant.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 0.1,
          splashColor: Colors.transparent,
          icon: SvgPicture.asset(
            ImagePathConstant.backArrowIos,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Center(child: Text('Home')),
    );
  }
}
