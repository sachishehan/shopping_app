import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';
import 'package:quick/screens/login_page.dart';
import 'package:quick/screens/main_screen.dart';
import 'package:quick/services/user_services.dart';
import 'package:quick/services/auth_service.dart';
import 'package:quick/widgets/custom_button.dart';

class UserDateScreen extends StatefulWidget {
  const UserDateScreen({super.key});

  @override
  State<UserDateScreen> createState() => _UserDateScreenState();
}

class _UserDateScreenState extends State<UserDateScreen> {
  // for the checkbox
  bool _rememberMe = false;

  // account types
  final List<String> _accountTypes = const [
    'Shopper account',
    'Customer account',
  ];
  String? _selectedAccountType;

  // form key for the form validation
  final _formKey = GlobalKey<FormState>();

  // controllers for the text fields
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
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
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
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

                      // NEW: account type dropdown (styled like a text field)
                      DropdownButtonFormField<String>(
                        value: _selectedAccountType,
                        items:
                            _accountTypes
                                .map(
                                  (t) => DropdownMenuItem<String>(
                                    value: t,
                                    child: Text(t),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (val) => setState(() => _selectedAccountType = val),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an account type';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Account Type",
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
                            final confirmPassword =
                                _confirmPasswordController.text.trim();
                            // safe due to validator

                            // TODO: persist accountType too (extend UserServices if needed)
                            await UserServices.storeUserDetails(
                              userName: userName,
                              email: email,
                              password: password,
                              confirmPassword: confirmPassword,
                              context: context,
                            );
                            // Example:
                            // await UserServices.storeAccountType(accountType);

                            // Set logged in status to true after registration
                            await AuthService.setLoggedIn(true);

                            // navigate to main
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
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
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
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
