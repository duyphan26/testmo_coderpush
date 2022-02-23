import 'entity.dart';

class User extends Entity {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String picture;
  final String? dateOfBirth;
  final String? phone;

  // ignore: prefer_constructors_over_static_methods
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      picture: json['picture'],
      dateOfBirth: json['dateOfBirth'],
      phone: json['phone'],
    );
  }

  User({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.picture,
    this.dateOfBirth,
    this.phone,
  });

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic>? toJson() => null;
}
