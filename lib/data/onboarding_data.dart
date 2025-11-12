import 'package:quick/models/onboarding_model.dart';

class onboardingData{
  static final List<Onboarding> onboardingList =[

    Onboarding(
      title: "Why Choose?", 
      imagePath: "assets/images/hand.png",
      description: "Save Money",
      subTitle: "Purchase high-quality food items at significantly reduced prices, saving money on grocery bills.",
      SubDescription: "Get the best deals on surplus food.",
      SubImagePath: "assets/images/save_money.png",
    ),
  
    Onboarding(
      title: "Why Choose?", 
      imagePath: "assets/images/hand.png", 
      description: "Reduce Food Waste",
      subTitle: " Help combat food waste by purchasing surplus food that would otherwise be descarded. contributing to a more sustainable environment.",
      SubDescription: "Get the best deals on surplus food.",
      SubImagePath: "assets/images/food_waste.png",
    ),

    Onboarding(
      title: "Why Choose?", 
      imagePath: "assets/images/hand.png", 
      description: "Find Great Deals",
      subTitle: "Discover a wide range of discounted fooditmes from various stores.emsuring you always find something you love at a great price",
      SubDescription: "Get the best deals on surplus food.",
      SubImagePath: "assets/images/save_money.png",
    ),
  
  ];
}