// import 'package:flutter/material.dart';
//
// import '../data/repo/auth_repo.dart';
//
// class TmdbLogin extends StatefulWidget {
//   const TmdbLogin({super.key});
//
//   @override
//   TmdbLoginState createState() => TmdbLoginState();
// }
//
// class TmdbLoginState extends State<TmdbLogin> {
//   bool loggedIn = false;
//   String? sessionId;
//
//   // Step 1: Get Request Token
//   Future<void> getRequestToken() async {
//     loggedIn = await authRepo.login();
//
//     setState(() async {
//       sessionId = await authRepo.getSessionToken();
//     });
//   }
//
//   // Step 3: Create Access Token or Session ID (Post Authentication)
//   // Future<void> createAccessToken() async {
//   //   if (requestToken != null) {
//   //     String accessTokenModel =
//   //         await authRepository.getSessionToken(requestToken: requestToken!);
//   //
//   //     if (accessTokenModel.success) {
//   //       setState(() {
//   //         accessTokenModel = accessTokenModel;
//   //       });
//   //       debugPrint("Access Token: ${accessTokenModel.token}");
//   //     } else {
//   //       debugPrint("Error");
//   //     }
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("TMDb Login")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: getRequestToken,
//               child: const Text("Login with TMDb"),
//             ),
//             if (sessionId != null) Text("UserAccessToken: ${sessionId!}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
