import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notifications/firebase_api.dart';

class ChatScreen extends StatefulWidget {
  final String channelId;
  static String channelsRoute = '/routes/chatroom';
  ChatScreen({Key? key, required this.channelId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final Map<String, String> channelImages = {
    'Eldoksh': 'images/Eldoksh.jpg',
    'Saba7o': 'images/Saba7o.jpg',
    'MrBeast': 'images/MrBeast.jpg',
    'Spotify': 'images/spotify.png',
  };

  @override
  void initState() {
    super.initState();
    FirebaseAPI.listenForMessages(widget.channelId);
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = channelImages[widget.channelId] ?? 'images/default.jpg';
    return Scaffold(
      appBar: AppBar(
        leading: ClipOval(
          child: Image.asset(
            imagePath,
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.channelId} Chatroom'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('channels')
                  .doc(widget.channelId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final message = messageData['message'] ?? '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color:
                                Colors.blue, // Blue background for the message
                            borderRadius:
                                BorderRadius.circular(15.0), // Rounded corners
                          ),
                          child: Text(
                            message,
                            style: const TextStyle(
                                color: Colors.white), // White text
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      print("There is nothing to send");
                    }
                    else
                      FirebaseAPI.sendMessage(widget.channelId, _controller.text);
                      
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
