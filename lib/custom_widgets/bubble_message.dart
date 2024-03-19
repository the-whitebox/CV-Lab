import 'package:flutter/material.dart';

import '../utils/constants.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                  decoration: BoxDecoration(
                    color: isUser ? kLightOrange : kLightPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message,
                    style: kFont10.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Align(
                alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                child: Image.asset(
                  isUser
                      ? 'assets/images/avatar.png'
                      : 'assets/images/avatars/dogDP.png',
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
