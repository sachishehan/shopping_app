import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  // method to store the user name and user email in shared preferencses
  static Future<void> storeUserDetails(
    {required String userName, 
    required email, 
    required password,
    required confirmPassword, 
    required context}) 
    async {
      try{
        //check weather the user entered password and confirm password are the same

      if (password != confirmPassword) {
        //show a message to the user
        ScaffoldMessenger.of( context).showSnackBar(
          SnackBar(
            content: Text("Password and Confirm Password do not match"),
          ),
        );
        return;
      }
      //if the password and confrim password are same then store the users name and email
        //create an instance shared preferences
        SharedPreferences preferences = await SharedPreferences.getInstance();
        //store the user name and email as key value pairs
        await preferences.setString('userName', userName);
        await preferences.setString('email', email);

        //show a message to the user 
        ScaffoldMessenger.of( context).showSnackBar(
          SnackBar(
            content: Text("User details saved successfully"),
          ),
        );
      }
      catch(err){
        err.toString();
      }
      }
}