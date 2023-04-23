import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snowscape_tracker/commands/login_command.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    bool success = await LoginCommand()
        .execute(_emailController.text.trim(), _passwordController.text.trim());
    if (!success) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchToSignup() {
    LoginCommand().switchToSignup();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white,
                  child: const Text(
                    "Sign in to your Account",
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (_isLoading) const CircularProgressIndicator(),  // TODO: figure out how to show this without breaking the layout
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Color.fromARGB(83, 0, 0, 0)),
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleLogin(),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 68, 116, 116)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 20))),
                      child: const Text("Sign In",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = _switchToSignup,
                          text: "Sign Up",
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
