import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:snowscape_tracker/app/modules/home/view/home_controller.dart';
import 'package:snowscape_tracker/commands/increment_counter_command.dart';
import 'package:snowscape_tracker/models/home_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _handleIncrementCounter() {
    IncrementCounterCommand().execute();
  }

  @override
  Widget build(BuildContext context) {
    var counter = context.select<HomeModel, int>((model) => model.counter);

    return Scaffold(
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
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleIncrementCounter(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
