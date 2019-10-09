class User {
  String username;
  String name;
  String email;
  String token;
  String photoUrl;
  List<String> roles;

  User(this.username, this.name, this.email, this.token, this.photoUrl,
      this.roles);

  User.fromJson(Map<String, dynamic> map)
      : username = map["login"],
        name = map["nome"],
        email = map["email"],
        token = map["token"],
        photoUrl = map["urlFoto"],
        roles = _getRoles(map);

  static List<String> _getRoles(final Map<String, dynamic> map) {
    return map["roles"] != null
        ? map["roles"].map<String>((role) => role.toString()).toList()
        : null;
  }

  @override
  String toString() {
    return 'User{username: $username, name: $name, email: $email, token: $token, photoUrl: $photoUrl, roles: $roles}';
  }

}
