import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String userId;
  final bool isAdmin;
  final String name;
  final String userName;
  final String token;

  const UserModel({
    required this.name,
    required this.userName,
    required this.id,
    required this.isAdmin,
    required this.userId,
    required this.token,
  });

  UserModel copyWith({
    final String? name,
    final String? userName,
    final String? password,
    final int? id,
    final String? userId,
    final bool? isAdmin,
    final String? token,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      name: name ?? this.name,
      id: id ?? this.id,
      isAdmin: isAdmin ?? this.isAdmin,
      userId: userId ?? this.userId,
      token: token ?? this.token,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json,
      {bool isLogin = true, String token = ''}) {
    return UserModel(
      id: isLogin ? json['user']['id'] ?? '' : json['id'],
      userId: isLogin ? json['user']['user_id'] ?? '' : json['user_id'],
      isAdmin: isLogin
          ? json['user']['role'] == 'admin'
              ? true
              : false
          : json['role'] == 'admin'
              ? true
              : false,
      token: isLogin ? json['access_token'] ?? '' : token,
      userName: isLogin ? json['user']['username'] ?? '' : json['username'],
      name: isLogin ? json['user']['name'] ?? '' : json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': userName,
      'id': id,
      'access_token': token,
      'roke': isAdmin,
      'user_id': userId,
    };
  }

  @override
  List<Object?> get props => [
        name,
        userName,
        id,
        userId,
        token,
        isAdmin,
      ];
}
