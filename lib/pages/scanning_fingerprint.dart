// import 'package:flutter/material.dart';
// import 'package:taptocare/widgets/buttons.dart';
// import 'package:taptocare/widgets/ripple.dart';
// import 'package:taptocare/widgets/text.dart';
// import 'dart:async';

// class ScanningFingerprint extends StatefulWidget {
//   const ScanningFingerprint(BuildContext context, {super.key});
//   @override
//   State<StatefulWidget> createState() => _ScanningFingerprint();
// }

// class _ScanningFingerprint extends State<ScanningFingerprint> {
//   bool isScanning = false;
//   bool firstScan = false;
//   bool secondScan = false;
//   bool firstScanComplete = false;
//   Timer? scanTimer;

//   @override
//   void dispose() {
//     scanTimer?.cancel();
//     super.dispose();
//   }

//   void startScanning() {
//     setState(() {
//       isScanning = true;
//     });

//     // Start 5-second timer
//     scanTimer = Timer(Duration(seconds: 5), () {
//       setState(() {
//         isScanning = false;
//         if (!firstScan) {
//           firstScan = true;
//           firstScanComplete = true;
//         } else if (!secondScan) {
//           secondScan = true;
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFDF5F5),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => {Navigator.pop(context)},
//         ),
//         title: Text(
//           "Scan your Fingerprint",
//           style: CustomTextStyles.subheading(),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFFDF5F5), Color(0xFFF9EFEF), Color(0xFFF4E7E7)],
//             stops: [0.0, 0.59, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   if (isScanning)
//                     scanningFinger()
//                   else if (!firstScan)
//                     notScanningFinger()
//                   else if (firstScanComplete && !secondScan)
//                     firstScanCompleteWidget()
//                   else
//                     allScansCompleteWidget(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Column notScanningFinger() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Text(
//             "Please place your finger on the scanner",
//             style: CustomTextStyles.normal(),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         SizedBox(height: 20),

//         // Static fingerprint icon
//         Container(
//           width: 100,
//           height: 100,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 5,
//                 blurRadius: 10,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Icon(Icons.fingerprint, size: 45, color: Color(0xFFFF386A)),
//         ),
//         SizedBox(height: 35),
//         CustomButton(text: "Start First Scan", onPressed: startScanning),
//       ],
//     );
//   }

//   Column firstScanCompleteWidget() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               Icon(Icons.check_circle, size: 60, color: Colors.green),
//               SizedBox(height: 15),
//               Text(
//                 "First scan completed!",
//                 style: CustomTextStyles.normal(),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Please place your finger on the scanner again for verification",
//                 style: CustomTextStyles.normal(),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 20),
//         SizedBox(height: 35),
//         CustomButton(text: "Start Second Scan", onPressed: startScanning),
//       ],
//     );
//   }

//   Column allScansCompleteWidget() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               Icon(Icons.check_circle, size: 80, color: Colors.green),
//               SizedBox(height: 20),
//               Text(
//                 "Fingerprint Scanning Completed!",
//                 style: CustomTextStyles.subheading(),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                 child: Text(
//                   "Your fingerprint has been successfully registered",
//                   style: CustomTextStyles.normal(),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 25),
//         CustomButton(
//           text: "Continue",
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ],
//     );
//   }

//   Column scanningFinger() {
//     String scanText = firstScan
//         ? "Second scan in progress..."
//         : "First scan in progress...";

//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Text(scanText, style: CustomTextStyles.normal()),
//         ),
//         SizedBox(height: 10),
//         SizedBox(
//           width: 200,
//           height: 200,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Multiple ripple circles
//               CustomRippleWidget(
//                 rippleColor: Colors.pink,
//                 rippleCount: 3,
//                 duration: Duration(seconds: 2),
//               ),
//               // Center fingerprint icon
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: 5,
//                       blurRadius: 10,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.fingerprint,
//                   size: 45,
//                   color: Color(0xFFFF386A),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:taptocare/widgets/buttons.dart';
import 'package:taptocare/widgets/ripple.dart';
import 'package:taptocare/widgets/text.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanningFingerprint extends StatefulWidget {
  final String employeeId;

  const ScanningFingerprint(
    BuildContext context, {
    super.key,
    required this.employeeId,
  });

  @override
  State<StatefulWidget> createState() => _ScanningFingerprint();
}

class _ScanningFingerprint extends State<ScanningFingerprint> {
  bool isScanning = false;
  bool firstScan = false;
  bool secondScan = false;
  bool firstScanComplete = false;
  Timer? scanTimer;
  StreamSubscription<List<int>>? bluetoothSubscription;
  String receivedData = '';
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? connectedCharacteristic;

  @override
  void initState() {
    super.initState();
    _initializeBluetoothConnection();
    print('📱 APP: Employee ID received: ${widget.employeeId}');
  }

  @override
  void dispose() {
    scanTimer?.cancel();
    bluetoothSubscription?.cancel();
    super.dispose();
  }

  // Initialize Bluetooth connection from saved state
  Future<void> _initializeBluetoothConnection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDeviceId = prefs.getString('connected_device_id');
      final isConnected = prefs.getBool('is_connected') ?? false;

      if (isConnected && savedDeviceId != null) {
        // Find the connected device
        final connectedDevices = FlutterBluePlus.connectedDevices;
        final device = connectedDevices
            .where((d) => d.id.toString() == savedDeviceId)
            .firstOrNull;

        if (device != null) {
          connectedDevice = device;
          await _discoverAndSetupCharacteristic();
        } else {
          print('📱 APP ERROR: Saved device not found in connected devices');
        }
      } else {
        print('📱 APP ERROR: No saved Bluetooth connection found');
      }
    } catch (e) {
      print('📱 APP ERROR: Failed to initialize Bluetooth connection: $e');
    }
  }

  // Discover services and setup characteristic
  Future<void> _discoverAndSetupCharacteristic() async {
    if (connectedDevice == null) return;

    try {
      List<BluetoothService> services = await connectedDevice!
          .discoverServices();

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          // Look for a characteristic that supports write and notify
          if (characteristic.properties.write &&
              characteristic.properties.notify) {
            connectedCharacteristic = characteristic;
            await _setupBluetoothListener();
            print('📱 APP: Bluetooth characteristic setup complete');
            return;
          }
        }
      }

      print('📱 APP ERROR: No suitable characteristic found');
    } catch (e) {
      print('📱 APP ERROR: Failed to setup characteristic: $e');
    }
  }

  // Setup Bluetooth message listener
  Future<void> _setupBluetoothListener() async {
    if (connectedCharacteristic == null) {
      print('📱 APP ERROR: No characteristic available for listening');
      return;
    }

    try {
      // Enable notifications
      await connectedCharacteristic!.setNotifyValue(true);

      bluetoothSubscription = connectedCharacteristic!.value.listen(
        (List<int> data) {
          String message = utf8.decode(data).trim();
          receivedData += message;

          print('📱 APP RECEIVED: $message');

          // Process complete messages
          if (receivedData.contains('\n') || receivedData.contains('\r')) {
            List<String> messages = receivedData.split(RegExp(r'[\r\n]'));
            for (String msg in messages) {
              if (msg.trim().isNotEmpty) {
                _handleBluetoothMessage(msg.trim());
              }
            }
            receivedData = '';
          } else if (message == 'Status_OK' ||
              message == 'StartSecondScan' ||
              message == 'Completed') {
            _handleBluetoothMessage(message);
            receivedData = '';
          }
        },
        onError: (error) {
          print('📱 APP ERROR: Bluetooth error: $error');
        },
      );

      print('📱 APP: Bluetooth listener setup complete');
    } catch (e) {
      print('📱 APP ERROR: Failed to setup Bluetooth listener: $e');
    }
  }

  // Handle received Bluetooth messages
  void _handleBluetoothMessage(String message) {
    print('📱 APP PROCESSING: $message');

    switch (message) {
      case 'Status_OK':
        setState(() {
          isScanning = true;
        });
        break;

      case 'StartSecondScan':
        setState(() {
          isScanning = false;
          firstScan = true;
          firstScanComplete = true;
        });
        break;

      case 'Completed':
        setState(() {
          isScanning = false;
          secondScan = true;
        });
        break;

      default:
        print('📱 APP: Unknown message received: $message');
        setState(() {
          // TEMP: force scanning to test UI
          isScanning = true;
        });
      // print('📱 APP: Unknown message received: $message');
    }
  }

  // Send message to ESP32 via Bluetooth
  Future<void> _sendBluetoothMessage(String message) async {
    if (connectedCharacteristic == null) {
      print('📱 APP ERROR: No Bluetooth characteristic available');
      _showErrorDialog('Device not connected');
      return;
    }

    try {
      String fullMessage = '$message\n';
      // String fullMessage = '$message:${widget.employeeId}\n';
      List<int> bytes = utf8.encode(fullMessage);
      await connectedCharacteristic!.write(bytes);
      print('📱 APP SENT: $fullMessage');
    } catch (e) {
      print('📱 APP ERROR: Failed to send message: $e');
      _showErrorDialog('Failed to communicate with device');
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Communication Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void startFirstScan() {
    _sendBluetoothMessage('StartScan');
    print('📱 APP: Starting first scan...');
  }

  void startSecondScan() {
    _sendBluetoothMessage('StartScan');
    print('📱 APP: Starting second scan...');
  }

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
          "Scan your Fingerprint",
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
                children: [
                  // Show employee ID for debugging
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Employee ID: ${widget.employeeId}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),

                  if (isScanning)
                    scanningFinger()
                  else if (!firstScan)
                    notScanningFinger()
                  else if (firstScanComplete && !secondScan)
                    firstScanCompleteWidget()
                  else
                    allScansCompleteWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column notScanningFinger() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Please place your finger on the scanner",
            style: CustomTextStyles.normal(),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),

        // Static fingerprint icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(Icons.fingerprint, size: 45, color: Color(0xFFFF386A)),
        ),
        SizedBox(height: 35),
        CustomButton(text: "Start First Scan", onPressed: startFirstScan),
      ],
    );
  }

  Column firstScanCompleteWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.check_circle, size: 60, color: Colors.green),
              SizedBox(height: 15),
              Text(
                "First scan completed!",
                style: CustomTextStyles.normal(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Remove your finger and place it on the scanner again for verification",
                style: CustomTextStyles.normal(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(height: 35),
        CustomButton(text: "Start Second Scan", onPressed: startSecondScan),
      ],
    );
  }

  Column allScansCompleteWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.check_circle, size: 80, color: Colors.green),
              SizedBox(height: 20),
              Text(
                "Fingerprint Scanning Completed!",
                style: CustomTextStyles.subheading(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  "Your fingerprint has been successfully registered",
                  style: CustomTextStyles.normal(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
        CustomButton(
          text: "Continue",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Column scanningFinger() {
    String scanText = firstScan
        ? "Second scan in progress..."
        : "First scan in progress...";

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(scanText, style: CustomTextStyles.normal()),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Multiple ripple circles
              CustomRippleWidget(
                rippleColor: Colors.pink,
                rippleCount: 3,
                duration: Duration(seconds: 2),
              ),
              // Center fingerprint icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.fingerprint,
                  size: 45,
                  color: Color(0xFFFF386A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
