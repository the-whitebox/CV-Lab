import 'package:crewdog_cv_lab/utils/local_db.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String userImage;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    String profileImage = getProfilePic();
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 13),
                    decoration: BoxDecoration(
                      color: isUser ? kLightOrange : kLightPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        !isUser && userImage.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(baseUrl + userImage),
                                    minRadius: 30,
                                  )
                                ],
                              )
                            : const SizedBox(),
                        Text(
                          message,
                          style: kFont10.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Align(
                alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                child: isUser
                    ? profileImage.isNotEmpty
                        ? CircleAvatar(maxRadius: 13,backgroundImage: NetworkImage(ssoUrl+profileImage),)
                        : Image.asset(
                            'assets/images/avatar.png',
                            height: 30,
                            width: 30,
                          )
                    : Image.asset(
                        'assets/images/avatars/dogDP.png',
                        height: 30,
                        width: 30,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
