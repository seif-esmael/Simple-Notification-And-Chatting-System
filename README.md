# Flutter Channels App with Firebase Messaging

# Features
  - Channel Management: Add, subscribe to, and unsubscribe from channels.
  - Real-time Messaging: Send and receive messages instantly within subscribed channels.
  - Access Control: Restrict chat access to subscribed users.
  - Push Notifications: Receive foreground and background notifications for subscribed channels.
  - User Interface: Display channel details with associated images and responsive design.

# Setup
  # Prerequisites
    - Flutter SDK installed on your system.
    - A Firebase project set up with Firestore, Realtime Database, and Firebase Messaging enabled.
    - Mobile device or emulator configured for running the Flutter app.
  # Configuration
    1- Set up a Firebase project at Firebase Console.
    2- Add Android and iOS apps to your Firebase project:
      - Generate the google-services.json (Android) and GoogleService-Info.plist     (iOS) files.
      - Place them in the respective project directories:
        - android/app/ for google-services.json.
        - ios/Runner/ for GoogleService-Info.plist.
    3- Enable Firestore, Realtime Database, and Cloud Messaging in the Firebase console.
    4- Update the firebase_options.dart file generated by the FlutterFire CLI:
        (flutter pub run flutterfire configure)
    
