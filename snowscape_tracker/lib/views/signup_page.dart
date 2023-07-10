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
  final TextEditingController _displayNameController = TextEditingController();

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
    bool success = await SignupCommand().execute(_emailController.text.trim(),
        _passwordController.text.trim(), _displayNameController.text.trim());
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
          Flexible(
            fit: FlexFit.loose,
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              // height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Create an Account",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 6,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading) const CircularProgressIndicator(),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: InputDecoration(
                          hintText: "Display Name",
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (displayName) =>
                            displayName == null || displayName == ""
                                ? "Enter your name"
                                : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: Theme.of(context).textTheme.labelMedium,
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
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: Theme.of(context).textTheme.labelMedium,
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
                                  Theme.of(context).primaryColor),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20))),
                          child: Text("Sign Up",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Already have an account? ",
                                style: Theme.of(context).textTheme.bodyMedium),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _switchToLogin(),
                              text: "Sign In",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
