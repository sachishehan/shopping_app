import 'package:flutter/widgets.dart';
import 'package:quick/constant/constant.dart';

class SharedOnboardingScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String subTitle;
  final String subImagePath;
  final String subDescription;
  const SharedOnboardingScreen({super.key,
    required this.title,
    required this.imagePath,
    required this.description, 
    required this.subTitle, 
    required this.subImagePath, 
    required this.subDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kdefaultPadding),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 300,
            fit: BoxFit.cover,
          ),
      
        Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
      
          SizedBox(height: 10,),
      
      
          Text(
            description,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
      
      
          Image.asset(
              subImagePath,
              width: 300,
              fit: BoxFit.cover,
            ),
      
            SizedBox(height: 10,),
      
          
      
          SizedBox(height: 10),
      
      
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,              
                color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
      
      
            
        ],
        
      ),
    );
  }
}