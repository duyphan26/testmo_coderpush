import 'package:flutter/material.dart';
import 'package:testmo_coderpush/repository/models/models.dart';
import 'package:testmo_coderpush/models/models.dart';

class UsersTargetPage extends StatelessWidget {
  UsersTargetPage({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Users Target'),
      ),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) {
          return const Divider(
            color: Colors.transparent,
            thickness: 10.0,
          );
        },
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 20.0,
        ),
        itemBuilder: (_, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  child: Image.network(
                    users[index].picture,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (users[index].dateOfBirth != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 6.0,
                          ),
                          child: Text(
                            'Age ${users[index].toAge}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      Text(
                        users[index].toFullName,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
