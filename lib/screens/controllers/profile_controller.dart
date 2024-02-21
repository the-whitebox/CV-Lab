import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../utils/constants.dart';

Future<void> updateProfile(
  String token,
  String firstName,
  String lastName,
  XFile? profilePic,
  int? avatarIndex,
) async {
  try {
    final uri = Uri.parse('$baseUrl/accounts/api/profile/update/');
    var request = http.MultipartRequest('PATCH', uri)
      ..headers['Authorization'] = 'Bearer $token';
    // ..fields['first_name'] = firstName
    // ..fields['last_name'] = lastName;

    if (profilePic != null) {
      var stream = http.ByteStream(Stream.castFrom(profilePic.openRead()));
      var length = await profilePic.length();
      print("Profile Pic");
      var multipartFile = http.MultipartFile(
        'profile_pic',
        stream,
        length,
        filename: basename(profilePic.path),
        contentType: MediaType('image', 'jpeg'),
      );
      print("jUST Image....................");

      request.files.add(multipartFile);
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['avatar_url'] = '';
    } else if (avatarIndex != null && avatarIndex != 0) {
      print("Avatar Index");
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['avatar_url'] = avatarIndex.toString();
      request.fields['profile_pic'] = '';
    } else {
      print("jUST namesssss");
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Error updating profile: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error during profile update: $e');
  }
}

Future<Map<String, dynamic>> retrieveProfile(String token) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/api/profile/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print("$decodedData");
      return decodedData;
    } else {
      print('Error retrieving profile: ${response.reasonPhrase}');
      throw Exception('Failed to load profile');
    }
  } catch (error) {
    print('Error retrieving profile: $error');
    throw error;
  }
}

Future<Map<String, dynamic>> fetchProfile(String token) async {
  try {
    final Map<String, dynamic> response = await retrieveProfile(token);
    return response;
  } catch (e) {
    print('Error retrieving profile: $e');
    return {};
  }
}

Future<String> uploadDataAndImage(
  XFile imageToUpload,
  String token,
  String template,
  String userId,
) async {
  try {
    List<int> imageBytes = await imageToUpload.readAsBytes();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api-cvlab.crewdog.ai/api/save/picture/'),
    );

    // Add form data
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['user'] = userId;
    request.fields['template'] = template;

    // Add image file
    request.files.add(http.MultipartFile(
      'picture',
      http.ByteStream.fromBytes(imageBytes),
      imageBytes.length,
      filename: 'cv_image.jpg',
      contentType: MediaType('image', 'jpeg'),
    ));
    var response = await request.send();

    if (response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseData = jsonDecode(responseBody);

      // Check if "picture_path" exists in the response
      if (responseData.containsKey('picture_path')) {
        String picturePath = responseData['picture_path'];
        print('Picture path: $picturePath');
        return picturePath;
      } else {
        print('Failed to get "picture_path" from the response.');
        return "null";
      }
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      print('Response: ${await response.stream.bytesToString()}');
      return "null";
    }
  } catch (e) {
    print('Error uploading data and image: $e');
    return "null";
  }
}
