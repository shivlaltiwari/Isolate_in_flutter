import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:isolates_flutter/apis/model.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Isolate"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                final person = await getPerson();
                print(person);
              },
              child: Text("Fetch Person"))
        ],
      ),
    );
  }
}

void _getPersonList(SendPort sendPort) async {
  const url = "https://62971e418d77ad6f75fb1ea6.mockapi.io/source";
  final response = await HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((respo) => respo.transform(utf8.decoder).join())
      .then((jsonString) => personFromJson(jsonString));
  sendPort.send(response);
  Isolate.current.addOnExitListener(sendPort);
  print("object1");
}

Future getPerson() async {
  final rp = ReceivePort();
  await Isolate.spawn(_getPersonList, rp.sendPort);
  return await rp.first;
}
