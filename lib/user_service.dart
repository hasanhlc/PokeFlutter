class User {
  final String username;
  final String password;

  User({required this.username, required this.password});
}

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final List<User> _users = [
    User(username: 'hans', password: '1234'), // Varsayılan kullanıcı
  ];

  bool register(String username, String password) {
    // Kullanıcı adı zaten var mı kontrol et
    if (_users.any((user) => user.username == username)) {
      return false;
    }

    // Yeni kullanıcıyı ekle
    _users.add(User(username: username, password: password));
    return true;
  }

  bool login(String username, String password) {
    return _users.any(
      (user) => user.username == username && user.password == password,
    );
  }
}
