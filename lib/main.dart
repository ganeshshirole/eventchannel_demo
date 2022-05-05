import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Event Channel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Event Channel Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _eventChannel = const EventChannel('platform_channel_events/count');

  late Stream networkStream;

  @override
  void initState() {
    networkStream = _eventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => event as int);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Counter: '),
              StreamBuilder(
                  initialData: -1,
                  stream: networkStream,
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data.toString(),
                    );
                  })
            ],
          ),
        ));
  }
}
