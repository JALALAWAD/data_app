import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed( const Duration(seconds: 3 ),() {
      String route  =  SharedPrefController().getValueFor<bool>(key: PrefKeys.loggedIn.name) ??
          false ?
          '/home_screen' :
      '/login_screen' ;
      Navigator.pushReplacementNamed(context , route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: AlignmentDirectional.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              Color(0xFF54BAB9),
              Color(0xFF18978F),
            ],
          ),
        ),
        child:  Text('DATA APP',style: GoogleFonts.nunito(
          fontSize: 18 ,
          color: const Color(0xFFE9DAC1),
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
    );
  }
}


