import 'package:flutter/material.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {

  String language = SharedPrefController().getValueFor(key: PrefKeys.lang.name) ?? 'en' ;

  void changeLanguage(){
    language  = language == 'en' ? 'ar' : 'en' ;
    SharedPrefController().changeLanguage(language: language);
    notifyListeners();
  }
}