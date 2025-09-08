// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:taptocare/firebase_options.dart';
// import 'pages/homepage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'pages/login.dart';
// import 'pages/adminpanel.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   Future<Widget> _getStartingPage() async {
//     final prefs = await SharedPreferences.getInstance();

//     final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     final bool isAdmin = prefs.getBool('isAdmin') ?? true;

//     if (isLoggedIn) {
//       if (isAdmin) {
//         return const AdminPanel();
//       } else {
//         return MyHomePage(employeeId: employeeId);
//       }
//     } else {
//       return const Login();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromRGBO(255, 56, 106, 1),
//         ),
//       ),
//       home: FutureBuilder<Widget>(
//         future: _getStartingPage(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else if (snapshot.hasError) {
//             return Scaffold(
//               body: Center(child: Text("Error: ${snapshot.error}")),
//             );
//           } else if (snapshot.hasData) {
//             return snapshot.data!;
//           } else {
//             return const Scaffold(
//               body: Center(child: Text("Something went wrong")),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dispenser/firebase_options.dart';
import 'pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';
import 'pages/adminpanel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getStartingPage() async {
    final prefs = await SharedPreferences.getInstance();

    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final bool isAdmin = prefs.getBool('isAdmin') ?? false; // default false
    final String? employeeId = prefs.getString(
      'employeeId',
    ); // 🔑 fetch employeeId

    if (isLoggedIn) {
      if (isAdmin) {
        return const AdminPanel();
      } else {
        if (employeeId != null) {
          return MyHomePage(employeeId: employeeId);
        } else {
          // fallback if employeeId is missing
          return const Login();
        }
      }
    } else {
      return const Login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(255, 56, 106, 1),
        ),
      ),
      home: FutureBuilder<Widget>(
        future: _getStartingPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
          }
        },
      ),
    );
  }
}
