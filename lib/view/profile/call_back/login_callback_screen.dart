import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/theme_data.dart';
import 'bloc/login_callback_bloc.dart';

class LoginCallbackScreen extends StatelessWidget {
  const LoginCallbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocBuilder<LoginCallbackBloc, LoginCallbackState>(
        builder: (context, state) {
          return (state is LoginCallbackInitial)
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 24,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Lottie.asset(
                          'assets/animation/Animation_wait.json',
                          width: 200,
                          height: 200,
                          animate: true,
                          repeat: true,
                          frameRate: FrameRate.max,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          spacing: 8,
                          children: [
                            Text(
                              'Please Wait...',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Login in progress!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : (state is LoginCallbackSuccess)
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 24,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Lottie.asset(
                              'assets/animation/Animation_success.json',
                              width: 200,
                              height: 200,
                              animate: true,
                              repeat: false,
                              frameRate: FrameRate.max,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              spacing: 8,
                              children: [
                                Text(
                                  'You\'re in!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade900),
                                ),
                                Text(
                                  'Time to build your epic movie lists.\nJust don’t spend more time organizing than actually watching! 🎬😄',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green.shade900),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () => context.pop(),
                            style: ButtonStyle(
                                foregroundColor: WidgetStatePropertyAll(LightThemeColors.primary)),
                            child: Text(
                              "Return to Profile",
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : (state is LoginCallbackFailed)
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 24,
                            children: [
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: Lottie.asset(
                                  'assets/animation/Animation_fail.json',
                                  width: 200,
                                  height: 200,
                                  animate: true,
                                  repeat: false,
                                  frameRate: FrameRate.max,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  spacing: 8,
                                  children: [
                                    Text(
                                      'Login Failed',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade900),
                                    ),
                                    Text(
                                      'Please try again...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red.shade900),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => context.pop(),
                                style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStatePropertyAll(LightThemeColors.primary)),
                                child: Text(
                                  "Return to Profile",
                                  style: TextStyle(),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox();
        },
      ),
    );
  }
}
