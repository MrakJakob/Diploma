import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:snowscape_tracker/app/modules/home/view/home_controller.dart';
import 'package:snowscape_tracker/app/modules/home/controller/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Consumer<HomeController>(
                builder: (context, controller, ___) => Text(
                  '${controller.state.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<HomeController>().incrementCounter();
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
