import 'package:flutter/material.dart';
import 'package:dispenser/pages/scanning_fingerprint.dart';
import 'package:dispenser/widgets/buttons.dart';
import 'package:dispenser/widgets/text.dart';

class Managefingerprints extends StatelessWidget {
  final String employeeId;
  const Managefingerprints({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFDF5F5),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text(
          "Manage your Fingerprints",
          style: CustomTextStyles.subheading(),
        ),
      ),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: "Add fingerprint",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanningFingerprint(
                            context,
                            employeeId: employeeId,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  CustomButton(
                    text: "Change fingerprint",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ScanningFingerprint(context, employeeId: ''),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
