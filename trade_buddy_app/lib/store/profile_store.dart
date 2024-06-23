import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStore extends Cubit<List<Map<String, dynamic>>> {
  ProfileStore() : super([]) {
    initProfileList();
  }

  Future<void> addProfile(String profileData) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = state;
    final newProfiles = [...profiles, jsonDecode(profileData)];
    prefs.setStringList(
        'profileList', newProfiles.map((e) => jsonEncode(e)).toList());
    emit(newProfiles.cast<Map<String, dynamic>>());
  }

  Future<void> initProfileList() async {
    final prefs = await SharedPreferences.getInstance();
    final rawProfiles = prefs.getStringList('profileList') ?? [];
    final profiles = rawProfiles.map((e) => jsonDecode(e)).toList();
    emit(profiles.cast<Map<String, dynamic>>());
  }

  Future<void> deleteProfile(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = state;
    final newProfiles =
        profiles.where((element) => element['id'] != id).toList();
    prefs.setStringList(
        'profileList', newProfiles.map((e) => jsonEncode(e)).toList());
    emit(newProfiles.cast<Map<String, dynamic>>());
  }

  Future<void> updateDisplayNameWithId(String id, String displayName) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = state;
    final newProfiles = profiles.map((e) {
      if (e['id'] == id) {
        e['displayName'] = displayName;
      }
      return e;
    }).toList();
    prefs.setStringList(
        'profileList', newProfiles.map((e) => jsonEncode(e)).toList());
    emit(newProfiles.cast<Map<String, dynamic>>());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('profileList');
    emit([]);
  }
}
