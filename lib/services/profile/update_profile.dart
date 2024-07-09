import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../utils/consts/api_consts.dart';
import '../../utils/consts/constants.dart';

Future<void> updateProfile(
    String token,
    String firstName,
    String lastName,
    XFile? profilePic,
    int? avatarIndex,
    ) async {
  try {
    final uri = Uri.parse('$ssoUrl/api/accounts/profile/update/');
    var request = http.MultipartRequest('PATCH', uri)
      ..headers['Authorization'] = 'Bearer $token';

    if (profilePic != null) {
      var stream = http.ByteStream(Stream.castFrom(profilePic.openRead()));
      var length = await profilePic.length();
      var multipartFile = http.MultipartFile(
        'profile_pic',
        stream,
        length,
        filename: basename(profilePic.path),
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['avatar_url'] = '';
    } else if (avatarIndex != null && avatarIndex != 0) {
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['avatar_url'] = avatarIndex.toString();
      request.fields['profile_pic'] = '';
    } else {
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