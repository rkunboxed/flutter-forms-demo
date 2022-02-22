import 'package:flutter/material.dart';
import 'package:flutter_forms_demo/example_one.dart';
import 'package:flutter_forms_demo/example_two.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Route _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'example-one':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const ExampleOne();
          },
        );
      case 'example-two':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const ExampleTwo();
          },
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const Center(
              child: Text('404'),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tips & Tricks for Flutter Forms'),
        ),
        body: const Toc(),
      ),
      onGenerateRoute: _generateRoute,
    );
  }
}

class Toc extends StatelessWidget {
  const Toc({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: SizedBox(
          width: 200,
          child: ListView(
            children: [
              ListTile(
                tileColor: Colors.lightBlue.withAlpha(50),
                title: const Text('Example One'),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pushNamed('example-one');
                },
              ),
              ListTile(
                tileColor: Colors.lightBlue.withAlpha(30),
                title: const Text('Example Two'),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pushNamed('example-two');
                },
              ),
              ListTile(
                tileColor: Colors.lightBlue.withAlpha(50),
                title: const Text('Example Three'),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pushNamed('example-one');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
