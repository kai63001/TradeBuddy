import 'dart:convert';

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

  Future<String> getProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    final rawProfiles = prefs.getStringList('profileList') ?? [];
    final profiles = rawProfiles.map((e) => jsonDecode(e)).toList();
    final profile =
        profiles.firstWhere((element) => element['id'] == state);
    return profile['name'];
  }
}
