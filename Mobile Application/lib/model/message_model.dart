import 'package:healthy_kid_app/model/user_model.dart';

class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool unread;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.unread,
  });
}

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: hwBandaragama,
    time: '5:30 PM',
    text: 'What kind of symptoms child have',
    unread: true,
  ),
  Message(
    sender: chWorker,
    time: '4:30 PM',
    text: 'What kind of symptoms child have',
    unread: true,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: hwBandaragama,
    time: '5:30 PM',
    text: 'How can I help you?',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Hi can I get a help',
    unread: true,
  ),
  Message(
    sender: hwBandaragama,
    time: '3:45 PM',
    text: 'How is your child',
    unread: true,
  ),
  Message(
    sender: hwBandaragama,
    time: '3:15 PM',
    text: 'Have any desices',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text:
        'But that  kid is having some difficulties due his identity reveal by a blog called daily bugle.',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'yeah..good',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Yes!',
    unread: true,
  ),
  Message(
    sender: hwBandaragama,
    time: '2:00 PM',
    text: 'I hope doing well.',
    unread: true,
  ),
  
];
