// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:dispenser/firebase_options.dart';
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
//     final bool isAdmin = prefs.getBool('isAdmin') ?? false; // default false
//     final String? employeeId = prefs.getString(
//       'employeeId',
//     ); // 🔑 fetch employeeId
//     final Object fingerprintId = prefs.getString('fingerprintId');

//     if (isLoggedIn) {
//       if (isAdmin) {
//         return const AdminPanel();
//       } else {
//         if (employeeId != null) {
//           return MyHomePage(fingerprintId: fingerprintId);
//         } else {
//           // fallback if employeeId is missing
//           return const Login();
//         }
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
    final bool isAdmin = prefs.getBool('isAdmin') ?? false;
    final String? employeeId = prefs.getString('employeeId');
    final String? fingerprintId = prefs.getString(
      'fingerprintId',
    ); // Fixed: Changed Object to String?

    if (isLoggedIn) {
      if (isAdmin) {
        // Pass both employeeId and fingerprintId to AdminPanel if needed
        return AdminPanel();
      } else {
        if (employeeId != null && fingerprintId != null) {
          // Check both values
          return MyHomePage(fingerprintId: fingerprintId);
        } else {
          // Clear invalid session and redirect to login
          await _clearSession(prefs);
          return const Login();
        }
      }
    } else {
      return const Login();
    }
  }

  // Helper method to clear invalid session data
  Future<void> _clearSession(SharedPreferences prefs) async {
    await prefs.remove('isLoggedIn');
    await prefs.remove('isAdmin');
    await prefs.remove('employeeId');
    await prefs.remove('fingerprintId');
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
      // Add named routes for better navigation
      // routes: {
      //   '/login': (context) => const Login(),
      //   '/home': (context) =>
      //       const MyHomePage(), // You'll need to handle parameters differently for routes
      //   '/admin': (context) => const AdminPanel(),
      // },
    );
  }
}
