import 'package:flutter/material.dart';
import 'package:laravel_smapp/consts/palette.dart';
import 'package:laravel_smapp/providers/auth_controller.dart';
import 'package:laravel_smapp/screens/auth/signup_screen.dart';
import 'package:laravel_smapp/utils/add_padding.dart';
import 'package:laravel_smapp/utils/add_space.dart';
import 'package:laravel_smapp/utils/navigate_to.dart';
import 'package:laravel_smapp/widgets/custom_appbar_action.dart';
import 'package:laravel_smapp/widgets/custom_button.dart';
import 'package:laravel_smapp/widgets/custom_text.dart';
import 'package:laravel_smapp/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUpClick() async {
    if (!mounted) return;
    await NavigateSkills().pushTo(
      context,
      const SignupScreen(),
    );
  }

  // login user
  Future<void> _loginUser() async {
    await context
        .read<AuthController>()
        .loginUser(context, mounted, _emailController, _passwordController);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette.fromDarkMode(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            // light mode
            CustomAppBarAction(),
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
                  // Icon
                  Icon(
                    Icons.android,
                    size: 75,
                    color: palette.iconColor,
                  ),
                  AddSpace().vertical(20),
                  // email textfield
                  CustomTextfield(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val!.isEmpty ? 'Cant be null' : null,
                  ),
                  AddSpace().vertical(10),
                  // password textfield
                  CustomTextfield(
                    obscureText: true,
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    validator: (val) =>
                        val!.length < 6 ? 'Required min 6 chars' : null,
                  ),
                  AddSpace().vertical(10),
                  // login button
                  context.watch<AuthController>().isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          fontWeight: FontWeight.bold,
                          text: 'Login',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              _loginUser();
                            }
                          },
                        ),
                  AddSpace().vertical(30),
                  // or Textfield
                  const CustomText(text: 'or'),
                  AddSpace().vertical(30),
                  // signup textbutton
                  TextButton(
                    onPressed: _signUpClick,
                    child: const CustomText(
                      text: 'Signup',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AddSpace().vertical(50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
