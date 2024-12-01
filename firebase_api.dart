import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifications/firebase_options.dart';

class FirebaseAPI {
  static List<String> subscribed_channels = [];


  //----------------------------------------------------------------------------

  static void foregroundNotificationHandler(RemoteMessage message) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      DatabaseReference messageRef =
          FirebaseDatabase.instance.ref("foreground");
      await messageRef.push().set({
        'title': message.notification?.title,
        'body': message.notification?.body,
        'date': message.sentTime?.toString(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> backgroundNotificationHandler(
      RemoteMessage message) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      DatabaseReference messageRef =
          FirebaseDatabase.instance.ref("background");
      await messageRef.push().set({
        'title': message.notification?.title,
        'body': message.notification?.body,
        'date': message.sentTime?.toString(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
    FirebaseMessaging.onMessage.listen(foregroundNotificationHandler);
  }

  static Future<void> subscribeToChannel(String channel) async {
  
    if (!subscribed_channels.contains(channel)) {
      DatabaseReference userRef = FirebaseDatabase.instance.ref('users/subscriptions');
      await userRef.update({
        channel: true,
      });

      await FirebaseMessaging.instance.subscribeToTopic(channel);
      subscribed_channels.add(channel);
      print('Subscribed to $channel');
    } else {
      print('Already subscribed to $channel');
    }
  }


  static Future<void> unsubscribeFromChannel(String channel) async {

    if (subscribed_channels.contains(channel)) {
      DatabaseReference userRef = FirebaseDatabase.instance.ref('users/subscriptions');
      userRef.child(channel).remove();

      await FirebaseMessaging.instance.unsubscribeFromTopic(channel);
      subscribed_channels.remove(channel);
      print('Unsubscribed from $channel');
    } else {
      print('Not subscribed to $channel');
    }
  }


  //----------------------------------------------------------------------------
  static void listenForMessages(String channelId) {
    FirebaseFirestore.instance
        .collection('channels') 
        .doc(channelId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        print('New message in channel $channelId: ${doc.data()}');  
      }
    });
  }


  static Future<void> sendMessage(String channelId, String message) async {
    try {
      await FirebaseFirestore.instance
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .add({
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('Message sent to channel $channelId: $message');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  static Future<String?> getDeviceToken() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        print('Device Token: $token');
      } else {
        print('Failed to get device token.');
      }

      return token;
    } catch (e) {
      print('Error retrieving device token: $e');
      return null;
    }
  }

  static Future<void> addChannel(String channelId) async {
    try {
      await FirebaseFirestore.instance.collection('channels').doc(channelId).set({
        'name': channelId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Channel $channelId added to Firestore');
    } catch (e) {
      print('Error adding channel: $e');
    }
  }

  static Stream<List<String>> getChannels() {
    return FirebaseFirestore.instance
        .collection('channels')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  static Future<void> subscribeToChannelWithFirestore(String userId, String channelId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('subscriptions')
          .doc(channelId)
          .set({
        'subscribedAt': FieldValue.serverTimestamp(),
      });
      print('User $userId subscribed to $channelId');
    } catch (e) {
      print('Error subscribing to channel: $e');
    }
  }

  static Future<void> unsubscribeFromChannelWithFireStore(String userId, String channelId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('subscriptions')
          .doc(channelId)
          .delete();
      print('User $userId unsubscribed from $channelId');
    } catch (e) {
      print('Error unsubscribing from channel: $e');
    }
  }

  static Future<void> sendMessageRealtime(String channelId, String message) async {
    try {
      DatabaseReference channelRef = FirebaseDatabase.instance.ref('channels/$channelId/messages');
      await channelRef.push().set({
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print('Message sent to channel $channelId');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  static void listenForMessagesRealtime(String channelId) {
    DatabaseReference channelRef = FirebaseDatabase.instance.ref('channels/$channelId/messages');

    channelRef.onChildAdded.listen((event) {
      Map<String, dynamic> messageData = event.snapshot.value as Map<String, dynamic>;
      print('New message in channel $channelId: $messageData');
    });
  }
}