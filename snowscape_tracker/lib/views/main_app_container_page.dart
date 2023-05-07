import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snowscape_tracker/commands/app_command.dart';
import 'package:snowscape_tracker/models/app_model.dart';

class MainAppContainerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget selectedPage =
        context.select<AppModel, Widget>((model) => model.selectedPage);

    void setSelectedPage(int pageIndex) {
      AppCommand().switchMainPage(pageIndex);
    }

    return Scaffold(
      body: selectedPage,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () {
                  setSelectedPage(0);
                },
                iconSize: 38,
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
                iconSize: 38,
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(
                  Icons.person,
                ),
                onPressed: () {
                  setSelectedPage(1);
                },
                iconSize: 38,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
