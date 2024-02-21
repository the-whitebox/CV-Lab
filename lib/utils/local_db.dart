import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

void storeAccessToken(String accessToken) {
  storage.write('accessToken', accessToken);
}

String getAccessToken() {
  return storage.read('accessToken') ?? '';
}
void clearAccessToken(){
  storage.remove('accessToken');
}

void storeUserId(String accessToken) {
  storage.write('userId', accessToken);
}

String getUserId() {
  return storage.read('userId') ?? '';
}
void clearUserId(){
  storage.remove('userId');
}


void storeProfilePic(String accessToken) {
  storage.write('profilePic', accessToken);
}

String getProfilePic() {
  return storage.read('profilePic') ?? '';
}
void clearProfilePic(){
  storage.remove('profilePic');
}


void storePlatformInfo(bool isIOS) {
  storage.write('isIOS', isIOS);
}

bool getPlatformInfo() {
  return storage.read('isIOS') ?? false;
}

