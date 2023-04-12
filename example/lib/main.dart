import 'package:flutter/material.dart';
import 'package:vertical_scroll_picker/widgets/picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            width: 100,
            child: VerticalPickerWidget(
                controller: FixedExtentScrollController(initialItem: 66),
                onScroll: (value) {
                  print(" current value $value");
                }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: 200,
            child: Center(
              child: VerticalPickerWidget(
                  controller: FixedExtentScrollController(initialItem: 66),
                  onScroll: (value) {
                    print(" current value $value");
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
