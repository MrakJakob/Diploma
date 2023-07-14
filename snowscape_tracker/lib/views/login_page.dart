import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/login_command.dart';
import 'package:snowscape_tracker/models/app_model.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin(GlobalKey<FormState> formKey) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      SnackBarWidget.show("No internet connection", null);
      return;
    }
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      // if the form is not valid, do not proceed with signup
      return;
    }
    bool success = await LoginCommand()
        .execute(_emailController.text.trim(), _passwordController.text.trim());
    return;
  }

  void _switchToSignup() {
    LoginCommand().switchToSignup();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = context
        .select<AppModel, GlobalKey<FormState>>((model) => model.formKey);

    return LoaderOverlay(
      child: Scaffold(
        body: Column(
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                // height: MediaQuery.of(context).size.height * 0.4,
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Sign in to your Account",
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
                        // if (_isLoading) const CircularProgressIndicator(),  // TODO: figure out how to show this without breaking the layout
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: Theme.of(context).textTheme.labelMedium,
                            border: const OutlineInputBorder(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? "Enter a valid email"
                                  : null,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: Theme.of(context).textTheme.labelMedium,
                            border: const OutlineInputBorder(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) => password != null &&
                                  password.length < 6
                              ? "Password must be at least 6 characters long"
                              : null,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.loaderOverlay.show();
                              _handleLogin(formKey).then((_) {
                                context.loaderOverlay.hide();
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                )),
                            child: Text("Sign In",
                                style: Theme.of(context).textTheme.labelLarge),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Don't have an account? ",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _switchToSignup,
                                text: "Sign Up",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                              )
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
