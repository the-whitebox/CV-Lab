import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cv_templates/controllers/templates_controller.dart';
import '../utils/constants.dart';

class MessageBubbleForJobSearch extends StatelessWidget {
  final String userImage;
  final String message;
  final bool isUser;

  const MessageBubbleForJobSearch({
    required this.userImage,
    required this.message,
    required this.isUser,
    Key? key,
  }) : super(key: key);

  List<InlineSpan> _parseMessage(String message) {
    final regex = RegExp(r'\*\*(.*?)\*\*|\[(.*?)\]\((.*?)\)');
    final spans = <InlineSpan>[];
    int start = 0;

    for (final match in regex.allMatches(message)) {
      if (match.start > start) {
        spans.add(TextSpan(text: message.substring(start, match.start)));
      }

      if (match.group(1) != null) {
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(2) != null && match.group(3) != null) {
        spans.add(TextSpan(
          text: match.group(2),
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final url = match.group(3)!;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
        ));
      }

      start = match.end;
    }

    if (start < message.length) {
      spans.add(TextSpan(text: message.substring(start)));
    }

    return spans;
  }

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
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                  decoration: BoxDecoration(
                    color: isUser ? kLightOrange : kLightPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser && userImage.isNotEmpty)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // CircleAvatar(
                            //   backgroundImage: NetworkImage(userImage),
                            //   minRadius: 30,
                            // ),
                          ],
                        ),
                      RichText(
                        text: TextSpan(
                          style: kFont10.copyWith(color: Colors.black),
                          children: _parseMessage(message),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Align(
                alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                child: isUser
                    ? profileImage.isNotEmpty
                        ? CircleAvatar(
                            maxRadius: 13,
                            backgroundImage: NetworkImage(ssoUrl + profileImage),
                          )
                        : Image.asset(
                            'assets/images/avatar.png',
                            height: 30,
                            width: 30,
                          )
                    : Image.asset(
                        'assets/images/avatars/robot.png',
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
