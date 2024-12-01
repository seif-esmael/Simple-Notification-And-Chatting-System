import 'package:flutter/material.dart';
import 'package:notifications/firebase_api.dart';
import 'package:notifications/chat_screen.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});
  static String channelsRoute = '/routes/channels';

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  final TextEditingController _channelController = TextEditingController();
  final Map<String, String> channelImages = {
    'Eldoksh': 'images/Eldoksh.jpg',
    'Saba7o': 'images/Saba7o.jpg',
    'MrBeast': 'images/MrBeast.jpg',
    'Spotify': 'images/spotify.png',
  };
  final List<Map<String, bool>> _channels = [
    {"Eldoksh": false},
    {"Saba7o": false},
    {"MrBeast": false},
    {"Spotify": false},
  ];

  void _addChannel(String channelName) {
    setState(() {
      _channels.add({channelName: false});
      channelImages[channelName] = 'images/default.jpg'; // Default image for new channels
    });
    FirebaseAPI.addChannel(channelName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Channels'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _channelController,
              decoration: const InputDecoration(
                labelText: 'Enter Channel Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final channelName = _channelController.text.trim();
              if (channelName.isNotEmpty) {
                _addChannel(channelName);
                _channelController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Channel name cannot be empty.'),
                  ),
                );
              }
            },
            child: const Text('Add Channel'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _channels.length,
              itemBuilder: (context, index) {
                final String channelName = _channels[index].keys.first;
                final bool isSubscribed = _channels[index].values.first;
                final String imagePath =
                    channelImages[channelName] ?? 'images/default.jpg';

                return Card(
                  child: ListTile(
                    leading: ClipOval(
                      child: Image.asset(
                        imagePath,
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(channelName),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _channels[index][channelName] = !isSubscribed;
                        });

                        if (isSubscribed) {
                          FirebaseAPI.unsubscribeFromChannel(channelName);
                        } else {
                          FirebaseAPI.subscribeToChannel(channelName);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSubscribed ? Colors.red : Colors.green,
                      ),
                      child: Text(
                        isSubscribed ? "Unsubscribe" : "Subscribe",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: isSubscribed
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(channelId: channelName),
                              ),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'You must subscribe to $channelName to access its chat.'),
                              ),
                            );
                          },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
