import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/consts/api_consts.dart';
import '../../utils/consts/constants.dart';


Future<Map<String, dynamic>> retrieveProfile(String token) async {
  try {
    final response = await http.get(
      Uri.parse('$ssoUrl/api/accounts/profile/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
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



