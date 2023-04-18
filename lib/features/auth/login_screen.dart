import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ecommerce_app/core/common/button_app.dart';
import 'package:ecommerce_app/core/common/loader.dart';
import 'package:ecommerce_app/core/common/snackbar.dart';
import 'package:ecommerce_app/core/constans/constans.dart';
import 'package:ecommerce_app/core/enum.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/controller/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isHide = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
  }

  void submitLogin(BuildContext context) {
    if (userNameController.text.trim().isEmpty) {
      return showSnackBar(
        context: context,
        subject: AppConstans.signIn,
        message: 'Username can\'t be empty',
        contentType: ContentType.failure,
      );
    }
    if (passwordController.text.trim().isEmpty) {
      return showSnackBar(
        context: context,
        subject: AppConstans.signIn,
        message: 'Password can\'t be empty',
        contentType: ContentType.failure,
      );
    }

    if (passwordController.text.trim().length < 5) {
      return showSnackBar(
        context: context,
        subject: AppConstans.signIn,
        message: 'Password is too short',
        contentType: ContentType.failure,
      );
    }

    sl<AuthCubit>().loginSubmit(
      context: context,
      password: passwordController.text.trim(),
      userName: userNameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    color: Colors.grey[200],
                    child: state.submissionStatus == SubmissionStatus.inProgress
                        ? const Loader()
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      const CircleAvatar(
                                        radius: 35,
                                        child: Icon(
                                          Icons.shopping_bag,
                                          size: 35,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Sign In',
                                        style: GoogleFonts.anton(
                                          fontSize: 28.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Welcome,',
                                  style: GoogleFonts.anton(
                                    fontSize: 20.0,
                                    height: 1.5,
                                  ),
                                ),
                                Text(
                                  'Sign In to continue',
                                  style: GoogleFonts.karma(
                                    fontSize: 16.0,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  keyboardType: TextInputType.name,
                                  controller: userNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Username',
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: isHide,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    suffixIcon: IconButton(
                                      icon:
                                          const Icon(Icons.visibility_outlined),
                                      onPressed: () {
                                        setState(() {
                                          isHide = !isHide;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ButtonApp(
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(20),
                                  onPressed: () => submitLogin(context),
                                  child: Text(
                                    'Login',
                                    style:
                                        GoogleFonts.anton(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.karma(
                                        fontSize: 16.0,
                                        height: 1.5,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Don\'t have an account? ',
                                      style: GoogleFonts.karma(
                                        fontSize: 16.0,
                                        height: 1.5,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Routemaster.of(context)
                                            .push('/register');
                                      },
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
