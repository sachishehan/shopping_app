import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';
import 'package:quick/screens/main_screen.dart';
import 'package:quick/services/user_services.dart';
import 'package:quick/widgets/custom_button.dart';

class UserDateScreen extends StatefulWidget {
  const UserDateScreen({super.key});

  @override
  State<UserDateScreen> createState() => _UserDateScreenState();
}

class _UserDateScreenState extends State<UserDateScreen> {

  //for the checkbox
  bool _rememberMe = false;

  //form key for the form validation
  final _formKey = GlobalKey<FormState>();

  //controllers for the text fields
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kdefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enter your Details",
                style:TextStyle(
                  fontSize:25,
                  fontWeight:FontWeight.w500,
                  ),
                ),
                SizedBox(height:30),

                //form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //form field for the user name
                      TextFormField(
                        controller: _userNameController,
                        validator: (value) {
                          //check weather the user entered a valid user name
                          if (value !.isEmpty) {
                            return 'Please enter your name';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),

                      SizedBox(height:20),

                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          //check weather the user entered a valid email
                          if (value !.isEmpty) {
                            return 'Please enter your email';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),

                      SizedBox(height: 20,),

                      //form field for the user password
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          //check weather the user entered a valid password
                          if (value !.isEmpty) {
                            return 'Please enter valid password';
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),

                      SizedBox(height: 20,),

                      //form field for the user confirm password
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          //check weather the user entered a valid password
                          if (value !.isEmpty) {
                            return 'Please enter a the same password';
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                      SizedBox(height: 40,),

                      //remeber for me the next time
                      Row(
                        children: [
                          Text("Remeber me for the next time",style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 131, 115, 115),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              activeColor: buttonColor,
                              value: _rememberMe, onChanged: (value){
                                setState(
                                  () {
                                  _rememberMe = value!;
                                  },
                                );
                              }
                            ),
                          ),
                          
                        ],
                      ),
                      SizedBox(height: 20,),

                          //submit button
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                //form in valid, process data
                                String userName = _userNameController.text;
                                String email = _emailController.text; 
                                String password = _passwordController.text;
                                String confirmPassword = _confirmPasswordController.text;


                                //save the user name and email in the device storage
                                  await UserServices.storeUserDetails(
                                    userName: userName, 
                                    email: email, 
                                    password: password, 
                                    confirmPassword: confirmPassword, 
                                    context: context,
                                    );

                                    //navigate to the main screen
                                    if(context.mounted) {
                                      Navigator.push(
                                      context, MaterialPageRoute(
                                        builder: (context){
                                          return const MainScreen();

                                        },
                                      ),
                                    );
                                    }


                              }
                            },
                            child: CustomButton(
                              buttonName: "Next", 
                              buttonColor: buttonColor),
                          )
                    ],
                  ))
              ],
            ),
          )),
      ),
    
    );
  }
}