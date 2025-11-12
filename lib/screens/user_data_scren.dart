// import 'package:flutter/material.dart';
// import 'package:quick/constant/colors.dart';
// import 'package:quick/constant/constant.dart';
// import 'package:quick/screens/main_screen.dart';
// import 'package:quick/services/user_services.dart';
// import 'package:quick/widgets/custom_button.dart';

// class UserDateScreen extends StatefulWidget {
//   const UserDateScreen({super.key});

//   @override
//   State<UserDateScreen> createState() => _UserDateScreenState();
// }

// class _UserDateScreenState extends State<UserDateScreen> {

//   //for the checkbox
//   bool _rememberMe = false;

//   //form key for the form validation
//   final _formKey = GlobalKey<FormState>();

//   //controllers for the text fields
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   @override
//   void dispose() {
//     _userNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(kdefaultPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Enter your Details",
//                 style:TextStyle(
//                   fontSize:25,
//                   fontWeight:FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height:30),

//                 //form
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [

//                       //form field for the user name
//                       TextFormField(
//                         controller: _userNameController,
//                         validator: (value) {
//                           //check weather the user entered a valid user name
//                           if (value !.isEmpty) {
//                             return 'Please enter your name';
//                           }
//                         },
//                         decoration: InputDecoration(
//                           hintText: "Name",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                       ),

//                       SizedBox(height:20),

//                       TextFormField(
//                         controller: _emailController,
//                         validator: (value) {
//                           //check weather the user entered a valid email
//                           if (value !.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                         },
//                         decoration: InputDecoration(
//                           hintText: "email",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                       ),

//                       SizedBox(height: 20,),

//                       //form field for the user password
//                       TextFormField(
//                         controller: _passwordController,
//                         validator: (value) {
//                           //check weather the user entered a valid password
//                           if (value !.isEmpty) {
//                             return 'Please enter valid password';
//                           }
//                         },
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           hintText: "Enter Password",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                       ),

//                       SizedBox(height: 20,),

//                       //form field for the user confirm password
//                       TextFormField(
//                         controller: _confirmPasswordController,
//                         validator: (value) {
//                           //check weather the user entered a valid password
//                           if (value !.isEmpty) {
//                             return 'Please enter a the same password';
//                           }
//                         },
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           hintText: "Confirm Password",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                       ),
//                       SizedBox(height: 40,),

//                       //remeber for me the next time
//                       Row(
//                         children: [
//                           Text("Remeber me for the next time",style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Color.fromARGB(255, 131, 115, 115),
//                             ),
//                           ),
//                           Expanded(
//                             child: CheckboxListTile(
//                               activeColor: buttonColor,
//                               value: _rememberMe, onChanged: (value){
//                                 setState(
//                                   () {
//                                   _rememberMe = value!;
//                                   },
//                                 );
//                               }
//                             ),
//                           ),
                          
//                         ],
//                       ),
//                       SizedBox(height: 20,),

//                           //submit button
//                           GestureDetector(
//                             onTap: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 //form in valid, process data
//                                 String userName = _userNameController.text;
//                                 String email = _emailController.text; 
//                                 String password = _passwordController.text;
//                                 String confirmPassword = _confirmPasswordController.text;


//                                 //save the user name and email in the device storage
//                                   await UserServices.storeUserDetails(
//                                     userName: userName, 
//                                     email: email, 
//                                     password: password, 
//                                     confirmPassword: confirmPassword, 
//                                     context: context,
//                                     );

//                                     //navigate to the main screen
//                                     if(context.mounted) {
//                                       Navigator.push(
//                                       context, MaterialPageRoute(
//                                         builder: (context){
//                                           return const MainScreen();

//                                         },
//                                       ),
//                                     );
//                                     }


//                               }
//                             },
//                             child: CustomButton(
//                               buttonName: "Register", 
//                               buttonColor: buttonColor),
//                           ),
//                           SizedBox(height: 20,),  
//                           CustomButton(
//                             buttonName: "Login", 
//                             buttonColor: const Color.fromARGB(73, 74, 74, 75)),


//                     ],
//                   ))
//               ],
//             ),
//           )),
//       ),
    
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';
import 'package:quick/screens/login_page.dart';
import 'package:quick/screens/main_screen.dart';
import 'package:quick/services/user_services.dart';
import 'package:quick/widgets/custom_button.dart';


class UserDateScreen extends StatefulWidget {
  const UserDateScreen({super.key});

  @override
  State<UserDateScreen> createState() => _UserDateScreenState();
}

class _UserDateScreenState extends State<UserDateScreen> {
  // for the checkbox
  bool _rememberMe = false;

  // form key for the form validation
  final _formKey = GlobalKey<FormState>();

  // controllers for the text fields
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
                const Text(
                  "Enter your Details",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),

                // form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // user name
                      TextFormField(
                        controller: _userNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // password
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter valid password';
                          }
                          if (value.trim().length < 6) {
                            return 'Password should be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // confirm password
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value.trim() != _passwordController.text.trim()) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // remember me
                      Row(
                        children: [
                          const Text(
                            "Remember me for the next time",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 131, 115, 115),
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              activeColor: buttonColor,
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Register button
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            final userName = _userNameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final confirmPassword = _confirmPasswordController.text.trim();

                            // save details
                            await UserServices.storeUserDetails(
                              userName: userName,
                              email: email,
                              password: password,
                              confirmPassword: confirmPassword,
                              context: context,
                            );

                            // navigate to main
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MainScreen()),
                              );
                            }
                          }
                        },
                        child: CustomButton(
                          buttonName: "Register",
                          buttonColor: buttonColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Login button -> navigates to LoginScreen
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                          // If you prefer replacing the page instead:
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (_) => const LoginScreen()),
                          // );
                        },
                        child: const CustomButton(
                          buttonName: "Login",
                          buttonColor: Color.fromARGB(73, 74, 74, 75),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
