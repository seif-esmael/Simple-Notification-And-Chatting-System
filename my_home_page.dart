import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notifications/channels_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Notification Channels"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ChannelsScreen.channelsRoute);
                },
                child: const Text("Go to channels"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
