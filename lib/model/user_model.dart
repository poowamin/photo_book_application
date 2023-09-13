class User {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String password;
  final String confirmPw;

  User({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.confirmPw,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'confirmPw': confirmPw,
    };
  }
}

class AuthState {
  final User? user;

  AuthState({this.user});
}
