// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../home_screen.dart';
//
// // typedef StateUpdateCallback = void Function(Map<String, dynamic>);
//
// class ChatAPI {
//   Future<void> chatApi(
//     Map<String, dynamic> cvObj,
//     String jobDescription,
//     String userQuery,
//     String token,
//     // StateUpdateCallback stateUpdateCallback,
//   ) async {
//     final chatApiUrl = Uri.parse('https://api-cvlab.crewdog.ai/api/chat/');
//     final client = http.Client();
//
//     try {
//       final response = await client.post(
//         chatApiUrl,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'cv': cvObj,
//           'job_description': jobDescription,
//           'user_query': userQuery,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseBody = jsonDecode(response.body);
//         print('success 2chat 222a2p22i222222 ::::::::::::::: ');
//         // stateUpdateCallback(responseBody);
//
//         // setState(() {
//         //   messagesFromAPI.add(formatMessage(responseBody));
//         //   updateMessages();
//         //   newMessage = false;
//         // });
//
//         // setStateCallback(responseBody);
//       } else {
//         print('Second API call failed with status code ${response.statusCode}');
//         print(response.body);
//       }
//     } catch (e) {
//       print('Error in second API call: $e');
//     } finally {
//       client.close();
//     }
//   }
//
//   // void setStateCallback(Map<String, dynamic> responseBody) {
//   //   messagesFromAPI.add(formatMessage(responseBody));
//   //   updateMessages();
//   //   newMessage = false;
//   // }
//
//   String formatMessage(Map<String, dynamic> response) {
//     final StringBuffer formattedMessage = StringBuffer();
//
//     // Add summary
//     formattedMessage.writeln('Summary:');
//     formattedMessage.writeln(response['personal_information']['summary']);
//     formattedMessage.writeln();
//
//     // Add personal info
//     formattedMessage.writeln('Personal Info:');
//     formattedMessage
//         .writeln('Name: ${response['personal_information']['name']}');
//     formattedMessage
//         .writeln('Email: ${response['personal_information']['email']}');
//     formattedMessage
//         .writeln('Phone: ${response['personal_information']['phone']}');
//     formattedMessage
//         .writeln('Address: ${response['personal_information']['address']}');
//     formattedMessage.writeln();
//
//     // Add skills
//     formattedMessage.writeln('Skills:');
//     for (Map<String, dynamic> skill in response['skills']) {
//       formattedMessage.writeln('• ${skill['name']}');
//     }
//     formattedMessage.writeln();
//
//     // Add education
//     formattedMessage.writeln('Education:');
//     for (Map<String, dynamic> education in response['education']) {
//       formattedMessage.writeln('Degree: ${education['degree']}');
//       formattedMessage.writeln('Institute: ${education['institute']}');
//       formattedMessage.writeln('City: ${education['city']}');
//       formattedMessage.writeln('Country: ${education['country']}');
//       formattedMessage.writeln('Start date: ${education['start_date']}');
//       formattedMessage.writeln('End date: ${education['end_date']}');
//       formattedMessage.writeln('Description: ${education['description']}');
//       formattedMessage.writeln();
//     }
//
//     // Add employment history
//     formattedMessage.writeln('Employment History:');
//     for (Map<String, dynamic> employment in response['employment_history']) {
//       formattedMessage.writeln('Position: ${employment['position']}');
//       formattedMessage.writeln('Company: ${employment['company']}');
//       formattedMessage.writeln('City: ${employment['city']}');
//       formattedMessage.writeln('Country: ${employment['country']}');
//       formattedMessage.writeln('Start date: ${employment['start_date']}');
//       formattedMessage.writeln('End date: ${employment['end_date']}');
//       formattedMessage.writeln('Description: ${employment['description']}');
//       formattedMessage.writeln();
//     }
//
//     return formattedMessage.toString();
//   }
// }
