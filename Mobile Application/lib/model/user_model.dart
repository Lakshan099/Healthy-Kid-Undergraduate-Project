import 'package:firebase_auth/firebase_auth.dart';

class User {
  final int id;
  final String name;
  final String imageUrl;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isOnline,
  });
}

final user = FirebaseAuth.instance.currentUser!;

// YOU - current user
final User currentUser = User(
  id: 0,
  name: user.displayName.toString(),
  imageUrl: user.photoURL.toString(),
  isOnline: true,
);

// USERS
final User hwBandaragama = User(
  id: 1,
  name: 'DMO Bandaragama',
  imageUrl: 'assets/images/hwb.jpg',
  isOnline: true,
);
final User chWorker = User(
  id: 2,
  name: 'Child Health Worker',
  imageUrl: 'assets/images/doc.jpg',
  isOnline: true,
);
