// import 'package:expenz/utils/colors.dart';
import 'package:flutter/material.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(197, 254, 254, 254),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/Logo.png",
            width: 400,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 20,
          ),  
            // Text(
            //   "Quick Pay",
            //   style: TextStyle(
            //     fontSize: 40,
            //     fontWeight: FontWeight.bold,
            //     color: Color.fromARGB(255, 11, 160, 36),
            //   ),
            // ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
