import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/constant/constant.dart';
import 'package:quick/screens/main_screen.dart';
import 'package:quick/screens/user_data_scren.dart';
import 'package:quick/widgets/custom_button.dart';
import 'package:quick/services/auth_service.dart';
// If your signup screen is in a different path, adjust this import:


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // remember-me checkbox
  bool _rememberMe = false;

  // form key
  final _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // password visibility
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your email';
    // super-lightweight email check
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Please enter your password';
    if (text.length < 6) return 'Password should be at least 6 characters';
    return null;
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // TODO: Plug in your real auth here (Firebase, API, or compare with stored creds).
    // Example flow:
    // final ok = await AuthService.signIn(email: email, password: password);
    // if (!ok) { show error snackBar and return; }

    // Set logged in status to true
    await AuthService.setLoggedIn(true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
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
                  "Login to your Account",
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
                      // email
                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
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
                        validator: _validatePassword,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                          ),
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
                                setState(() => _rememberMe = value ?? false);
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // login button
                      GestureDetector(
                        onTap: _onLogin,
                        child: CustomButton(
                          buttonName: "Login",
                          buttonColor: buttonColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // go to register (same secondary style you used)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => UserDateScreen()),
                          );
                        },
                        child: const CustomButton(
                          buttonName: "Register",
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
