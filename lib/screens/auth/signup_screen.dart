import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/providers/auth_controller.dart';
import 'package:laravel_smapp/providers/light_mode_provider.dart';
import 'package:laravel_smapp/screens/auth/login_screen.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/custom_button.dart';
import 'package:laravel_smapp/widgets/custom_circle_avatar.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';
import 'package:laravel_smapp/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _loginClick() async {
    if (!mounted) return;
    await NavigateSkills().pushTo(
      context,
      const LoginScreen(),
    );
  }

  // register user
  void _registerUser() async {
    await context.read<AuthController>().registerUser(
          context,
          mounted,
          _emailController,
          _usernameController,
          _passwordController,
          _imageFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    bool isDarkMode = Provider.of<LightMode>(context, listen: true).isDarkMode;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // light mode
            IconButton(
              onPressed: () {
                context.read<LightMode>().changeLightMode();
              },
              icon: isDarkMode
                  ? Icon(
                      Icons.light_mode,
                      color: palette.iconColor,
                    )
                  : Icon(
                      Icons.dark_mode,
                      color: palette.iconColor,
                    ),
            ),
          ],
        ),
        body: Padding(
          padding: AddPadding.symmetric(horizontal: 15, vertical: 13),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // pp
                  GestureDetector(
                    onTap: () async {
                      await getImage();
                    },
                    child: _imageFile != null
                        ? CustomCircleAvatar(
                            isBorderEnabled: true,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_imageFile ?? File(''))),
                          )
                        : const CustomCircleAvatar(
                            isBorderEnabled: true,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/default_pp.png'),
                            ),
                          ),
                  ),
                  AddSpace().vertical(20),
                  // username textfield
                  CustomTextfield(
                    controller: _usernameController,
                    hintText: 'Username',
                    icon: Icons.person,
                    validator: (val) =>
                        val!.isEmpty ? 'Username required' : null,
                  ),
                  AddSpace().vertical(10),
                  // email textfield
                  CustomTextfield(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val!.isEmpty ? 'Email required' : null,
                  ),
                  AddSpace().vertical(10),
                  // password textfield
                  CustomTextfield(
                    obscureText: true,
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    validator: (val) =>
                        val!.length < 6 ? 'Min 6 chars required' : null,
                  ),
                  AddSpace().vertical(10),
                  // password confirm textfield
                  CustomTextfield(
                    obscureText: true,
                    controller: _passwordConfirmController,
                    hintText: 'Password Confirmation',
                    icon: Icons.lock,
                    validator: (val) => val! != _passwordController.text
                        ? 'Password does not match'
                        : null,
                  ),
                  AddSpace().vertical(10),
                  // signup button
                  context.watch<AuthController>().isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          fontWeight: FontWeight.bold,
                          text: 'Signup',
                          onTap: () async {
                            if (formKey.currentState!.validate() &&
                                _imageFile != null) {
                              _registerUser();
                            }
                          },
                        ),
                  AddSpace().vertical(30),
                  // or Textfield
                  const CustomText(text: 'or'),
                  AddSpace().vertical(30),
                  // login textbutton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // go to
                      const CustomText(
                        text: 'go to',
                        fontStyle: FontStyle.italic,
                      ),
                      // login
                      TextButton(
                        onPressed: _loginClick,
                        child: const CustomText(
                          text: 'Login',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
