// import 'package:expenz/utils/colors.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(198, 168, 225, 69),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/Logo.png",
            width: 300,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 0,
          ),
          const Center(
            child: 
            Column(
              children: [
                Text("why choose us?", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color( 0xFF0BA024),
                ),
              ),
              SizedBox(
                height: 150,
              ),
                Center(
                  child: Text(
                    "Save Money",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color( 0xFF0BA024),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Purchase high-quality food items at significantly reduced prices, saving money on grocery bills."),
                  ))
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
