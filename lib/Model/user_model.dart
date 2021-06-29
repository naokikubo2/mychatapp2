class User {
  final int id;
  final String name;
  final String imageUrl;
  final bool isOnline;

  User({
    required this.id, required this.name, required this.imageUrl, required this.isOnline,
  });
}

final User currentUser = User(
  id: 1,
  name: '九保直樹',
  imageUrl: 'images/user1.png',
  isOnline: true,
);

final User ironMan = User(
  id: 2,
  name: 'iron man',
  imageUrl: 'images/user2.png',
  isOnline: false,
);

final User miyuu = User(
  id: 3,
  name: '早川美優',
  imageUrl: 'images/user3.jpg',
  isOnline: true,
);