import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/database/controller/user_db_controller.dart';
import 'package:qatar_data_app/models/process_respnse.dart';
import 'package:qatar_data_app/models/user.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:qatar_data_app/provider/language_provider.dart';
import 'package:qatar_data_app/utlis/helpers.dart';
import 'package:qatar_data_app/widgets/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>  with Helpers {
  late TextEditingController _nameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF18978F)),
        title: Text(
          AppLocalizations.of(context)!.register,
          style: GoogleFonts.nunito(
            color: Color(0xFF18978F),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.register_title,
              style: GoogleFonts.nunito(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF18978F),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.register_subtitle,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w300,
                height: 0.8,
                fontSize: 16,
                color: Color(0xFF54BAB9),
              ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              textController: _nameTextController,
              hint: AppLocalizations.of(context)!.name,
              prefixIcon: Icons.person,
              textInputType: TextInputType.text,
            ),
            SizedBox(height: 10),
            AppTextField(
              textController: _emailTextController,
              hint: AppLocalizations.of(context)!.email,
              prefixIcon: Icons.email,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            AppTextField(
              textController: _passwordTextController,
              hint: AppLocalizations.of(context)!.password,
              prefixIcon: Icons.lock,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (String value) {
                //TODO: Call Login Function
              },
            ),
            SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                      colors: [
                        Color(0xFF54BAB9),
                        Color(0xFF18978F),
                      ]),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      color: Colors.black45,
                      blurRadius: 4,
                    )
                  ]),
              child: ElevatedButton(
                onPressed: () async => await _preformRegister(),
                child: Text(AppLocalizations.of(context)!.register),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                  minimumSize: Size(double.infinity, 45),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<LanguageProvider>(context, listen: false)
              .changeLanguage();
        },
        backgroundColor: Color(0xFFE9DAC1),
        child: Icon(
          Icons.language,
          color: Color(0xFF54BAB9),
        ),
      ),
    );
  }

  Future<void> _preformRegister() async {
    if (_checkData()) {
      await _register();
    }
  }

  bool _checkData() {
    if (_nameTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data !',error: true );
    return false;
  }

  Future<void> _register() async {
    ProcessResponse processResponse =
        await UserDbController().register(user: user);
    if (processResponse.success) {
      Navigator.pop(context);
    }
    showSnackBar(context, message: processResponse.message ,error: !processResponse.success );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(processResponse.message),
        backgroundColor: processResponse.success ? Colors.green : Colors.red,
      ),
    );
  }

  User get user {
    User user = User();
    user.name = _nameTextController.text;
    user.email = _emailTextController.text;
    user.password = _passwordTextController.text;
    return user;
  }
}
