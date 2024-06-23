import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectProfileStore extends Cubit<String> {
  SelectProfileStore() : super('') {
    _initSelectedProfile();
  }

  Future<void> selectProfile(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedProfile', profileId);
    emit(profileId);
  }

  Future<void> _initSelectedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedProfile = prefs.getString('selectedProfile') ?? '';
    emit(selectedProfile);
  }
}
