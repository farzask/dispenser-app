import 'package:dispenser/widgets/buttons.dart';
import 'package:dispenser/widgets/text.dart';
import 'package:flutter/material.dart';

class Timeout extends StatefulWidget {
  const Timeout({super.key});

  @override
  State<Timeout> createState() => _TimeoutState();
}

class _TimeoutState extends State<Timeout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDF5F5), Color(0xFFF9EFEF), Color(0xFFF4E7E7)],
            stops: [0.0, 0.59, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Timeout!', style: CustomTextStyles.heading()),
                    SizedBox(height: 15),
                    Text(
                      'Please start the scanning process again',
                      style: CustomTextStyles.normal(),
                    ),
                    SizedBox(height: 25),
                    CustomButton(
                      text: "Continue",
                      onPressed: () {
                        // Return result indicating scanning was completed
                        Navigator.pop(context, {
                          'scanning_completed': true,
                          'disconnected': true,
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
