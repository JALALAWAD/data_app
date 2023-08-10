import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/bloc/bloc/note_bloc.dart';
import 'package:qatar_data_app/bloc/states/crud_state.dart';
import 'package:qatar_data_app/database/db_controller.dart';
import 'package:qatar_data_app/get/language_getx_controller.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:qatar_data_app/provider/language_provider.dart';
import 'package:qatar_data_app/provider/note_provider.dart';
import 'package:qatar_data_app/screens/app/home_screen.dart';
import 'package:qatar_data_app/screens/auth/login_screen.dart';
import 'package:qatar_data_app/screens/auth/register_screen.dart';
import 'package:qatar_data_app/screens/launch_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPref();
  await DbController().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NoteBloc(LoadingState())),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        // supportedLocales: AppLocalizations.supportedLocales,
        // locale: Locale(Provider.of<LanguageProvider>(context).language),
        // locale: Locale(context.watch<LanguageProvider>().language),
        locale: Locale('en'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/launch_screen',
        routes: {
          '/launch_screen': (context) => const LaunchScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/register_screen': (context) => const RegisterScreen(),
          '/home_screen': (context) => /* const */ HomeScreen(),
        },
      ),
    );
  }
}
