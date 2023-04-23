import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/signUp_command.dart';
import 'package:snowscape_tracker/models/app_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _handleSignUp(GlobalKey<FormState> formKey) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      // if the form is not valid, do not proceed with signup
      return;
    }

    setState(() {
      _isLoading = true;
    });
    bool success = await SignupCommand()
        .execute(_emailController.text.trim(), _passwordController.text.trim());
    if (!success) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchToLogin() {
    SignupCommand().switchToLogin();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = context
        .select<AppModel, GlobalKey<FormState>>((model) => model.formKey);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              // height: MediaQuery.of(context).size.height * 0.4,
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 68, 116, 116)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Title(
                  color: Colors.black,
                  child: const Text(
                    "Create an Account",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading) const CircularProgressIndicator(),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? "Enter a valid email"
                              : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(83, 0, 0, 0)),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) =>
                          password != null && password.length < 6
                              ? "Password must be at least 6 characters long"
                              : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleSignUp(formKey),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 68, 116, 116)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 20))),
                        child: const Text("Sign Up",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _switchToLogin(),
                            text: "Sign In",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 68, 116, 116),
                                decoration: TextDecoration.underline),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
