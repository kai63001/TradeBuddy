
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectProfileStore extends Cubit<String> {
  SelectProfileStore() : super('') {
    initSelectedProfile();
  }

  Future<void> selectProfile(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedProfile', profileId);
    emit(profileId);
  }

  Future<void> initSelectedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedProfile = prefs.getString('selectedProfile') ?? '';
    emit(selectedProfile);
  }

  String getProfileName(
      String profileId, List<Map<String, dynamic>> rawProfiles) {
    final profile =
        rawProfiles.firstWhere((element) => element['id'] == profileId);
    return profile['name'];
  }
}
