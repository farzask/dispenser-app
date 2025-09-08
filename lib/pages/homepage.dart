// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dispenser/pages/login.dart';
// import 'package:dispenser/widgets/text.dart';
// import '../widgets/buttons.dart';
// import 'connectbt.dart';
// import 'managefingerprints.dart';

// class MyHomePage extends StatefulWidget {
//   final String employeeId;

//   const MyHomePage({super.key, required this.employeeId});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late String employeeId;
//   bool isConnected = false;
//   String? errorMessage;
//   BluetoothDevice? connectedDevice;
//   BluetoothCharacteristic? connectedCharacteristic;
//   String connectionStatus = "Not Connected";

//   @override
//   void initState() {
//     super.initState();
//     loadConnectionState();
//     checkConnectionStatus();
//     employeeId = widget.employeeId;
//   }

//   // Load connection state from shared preferences
//   Future<void> loadConnectionState() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedConnectionStatus = prefs.getBool('is_connected') ?? false;
//       final savedDeviceId = prefs.getString('connected_device_id');
//       prefs.getString('connected_device_name');

//       if (savedConnectionStatus && savedDeviceId != null) {
//         // Try to find the device in connected devices
//         final connectedDevices = FlutterBluePlus.connectedDevices;
//         final device = connectedDevices.firstWhere(
//           (d) => d.id.toString() == savedDeviceId,
//           // ignore: cast_from_null_always_fails
//           orElse: () => null as BluetoothDevice,
//         );

//         setState(() {
//           isConnected = true;
//           connectedDevice = device;
//           connectionStatus = "Connected to Sanitary Pad Dispenser";
//         });
//       }
//     } catch (e) {
//       print('Error loading connection state: $e');
//     }
//   }

//   // Save connection state to shared preferences
//   Future<void> saveConnectionState(
//     BluetoothDevice? device,
//     bool connected,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_connected', connected);

//       if (connected && device != null) {
//         await prefs.setString('connected_device_id', device.id.toString());
//         await prefs.setString('connected_device_name', device.name);
//       } else {
//         await prefs.remove('connected_device_id');
//         await prefs.remove('connected_device_name');
//       }
//     } catch (e) {
//       print('Error saving connection state: $e');
//     }
//   }

//   // Clear connection state
//   Future<void> clearConnectionState() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('is_connected');
//       await prefs.remove('connected_device_id');
//       await prefs.remove('connected_device_name');

//       setState(() {
//         isConnected = false;
//         connectedDevice = null;
//         connectedCharacteristic = null;
//         connectionStatus = "Not Connected";
//       });
//     } catch (e) {
//       print('Error clearing connection state: $e');
//     }
//   }

//   // Check if there's an existing connection
//   Future<void> checkConnectionStatus() async {
//     try {
//       // Check if we have a saved connected device
//       if (connectedDevice != null) {
//         // Verify if the device is still connected
//         final connectedDevices = FlutterBluePlus.connectedDevices;
//         final stillConnected = connectedDevices.any(
//           (device) => device.id == connectedDevice!.id,
//         );

//         if (!stillConnected) {
//           // Device is no longer connected, clear the state
//           await clearConnectionState();
//         }
//       }

//       setState(() {
//         connectionStatus = isConnected
//             ? "Connected to Sanitary Pad Dispenser"
//             : "Not Connected";
//       });
//     } catch (e) {
//       print('Error checking connection status: $e');
//     }
//   }

//   // Handle connection result from ConnectWithBT page
//   Future<void> handleConnectionResult(dynamic result) async {
//     if (result != null && result is Map) {
//       if (result['connected'] == true) {
//         setState(() {
//           isConnected = true;
//           connectedDevice = result['device'];
//           connectedCharacteristic = result['characteristic'];
//           connectionStatus = "Connected to Sanitary Pad Dispenser";
//           errorMessage = null;
//         });

//         // Save the connection state
//         await saveConnectionState(result['device'], true);
//       } else if (result['disconnected'] == true) {
//         setState(() {
//           isConnected = false;
//           connectedDevice = null;
//           connectedCharacteristic = null;
//           connectionStatus = "Not Connected";
//         });

//         // Clear the connection state
//         await saveConnectionState(null, false);
//       }
//     }
//   }

//   // Navigate to connection page
//   Future<void> navigateToConnection() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ConnectWithBT(
//           alreadyConnectedDevice: connectedDevice,
//           alreadyConnectedCharacteristic: connectedCharacteristic,
//         ),
//       ),
//     );

//     await handleConnectionResult(result);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Color(0xFFEA91A0),
//       backgroundColor: Color(0xFFF74370),
//       // appBar: AppBar(backgroundColor: Color(0xFFF74370)),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: 40, top: 60),
//               //greeting text
//               child: Text(
//                 "Hi NIC!",
//                 style: TextStyle(
//                   fontFamily: "Helvetica",
//                   fontSize: 38,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(height: 130),
//             //elevated rectangle
//             Expanded(
//               child: Container(
//                 width: double.infinity, // full width
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.25), // shadow color
//                       spreadRadius: 0, // how wide the shadow spreads
//                       blurRadius: 10.1, // softness of the shadow
//                       offset: const Offset(2, -6),
//                     ),
//                   ],
//                   color: Color(0xFFFDF5F5), // background color of the box
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(37),
//                     topRight: Radius.circular(37),
//                   ),
//                 ),
//                 //content inside the rectangular box
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     children: [
//                       //nic logo
//                       Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Image.asset("asset/icons/nicLogo.png"),
//                       ),

//                       // Connection Status Card
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(16),
//                         margin: EdgeInsets.symmetric(horizontal: 20),
//                         decoration: BoxDecoration(
//                           color: isConnected
//                               ? Colors.green.withOpacity(0.1)
//                               : Colors.grey.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isConnected
//                                 ? Colors.green.withOpacity(0.3)
//                                 : Colors.grey.withOpacity(0.3),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               isConnected
//                                   ? Icons.bluetooth_connected
//                                   : Icons.bluetooth_disabled,
//                               color: isConnected ? Colors.green : Colors.grey,
//                               size: 24,
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Dispenser Status",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey[600],
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   SizedBox(height: 2),
//                                   Text(
//                                     connectionStatus,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: isConnected
//                                           ? Colors.green[700]
//                                           : Colors.grey[700],
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       //spacing
//                       SizedBox(height: 30),

//                       //connect with dispenser button
//                       CustomButton(
//                         text: isConnected
//                             ? "Manage Dispenser Connection"
//                             : "Connect with Dispenser",
//                         onPressed: navigateToConnection,
//                       ),

//                       //spacing
//                       SizedBox(height: 10),

//                       //manage fingerprints button
//                       CustomButton(
//                         text: "Manage your Fingerprints",
//                         onPressed: () {
//                           if (isConnected) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     Managefingerprints(employeeId: employeeId),
//                               ),
//                             );
//                           } else {
//                             setState(() {
//                               //display the error message if app is not connected with the dispenser
//                               errorMessage =
//                                   "Please connect with dispenser first";

//                               //remove the error message after 3 seconds
//                               Future.delayed(const Duration(seconds: 3), () {
//                                 if (mounted) {
//                                   setState(() {
//                                     errorMessage = null;
//                                   });
//                                 }
//                               });
//                             });
//                           }
//                         },
//                       ),

//                       //displaying error message and its style
//                       if (errorMessage != null) // show only if message exists
//                         Text(
//                           errorMessage!,
//                           style: TextStyle(
//                             fontFamily: "Inter",
//                             fontSize: 12,
//                             color: const Color.fromARGB(255, 197, 23, 23),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),

//                       SizedBox(height: 10),

//                       CustomButton(
//                         text: 'Log out',
//                         onPressed: () {
//                           showDialog<void>(
//                             context: context,
//                             barrierDismissible: false,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Logout'),
//                                 content: const Text(
//                                   'Are you sure you want to logout?',
//                                 ),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     child: Text(
//                                       'Cancel',
//                                       style: CustomTextStyles.normal(),
//                                     ),

//                                     onPressed: () =>
//                                         Navigator.of(context).pop(),
//                                   ),
//                                   TextButton(
//                                     child: Text(
//                                       'Logout',
//                                       style: CustomTextStyles.normal(
//                                         color: Color.fromARGB(255, 15, 5, 8),
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       Navigator.of(context).pop();
//                                       final prefs =
//                                           await SharedPreferences.getInstance();
//                                       await prefs.clear();
//                                       Navigator.pushAndRemoveUntil(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => const Login(),
//                                         ),
//                                         (route) => false,
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dispenser/pages/login.dart';
import 'package:dispenser/widgets/text.dart';
import '../widgets/buttons.dart';
import 'connectbt.dart';
import 'managefingerprints.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  final String employeeId;

  const MyHomePage({super.key, required this.employeeId});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String employeeId;
  bool isConnected = false;
  String? errorMessage;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? connectedCharacteristic;
  String connectionStatus = "Not Connected";

  // Stream subscriptions for real-time monitoring
  StreamSubscription<BluetoothConnectionState>? connectionStateSubscription;
  StreamSubscription<List<BluetoothDevice>>? connectedDevicesSubscription;
  Timer? periodicCheckTimer;

  @override
  void initState() {
    super.initState();
    employeeId = widget.employeeId;
    loadConnectionState();
    setupRealtimeMonitoring();
  }

  @override
  void dispose() {
    connectionStateSubscription?.cancel();
    connectedDevicesSubscription?.cancel();
    periodicCheckTimer?.cancel();
    super.dispose();
  }

  // Setup real-time connection monitoring
  // Setup real-time connection monitoring
  void setupRealtimeMonitoring() {
    // Monitor Bluetooth adapter state changes
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print('📱 APP: Bluetooth adapter state: $state');
      if (state == BluetoothAdapterState.on) {
        checkConnectionStatus();
      } else {
        // Bluetooth is off, clear connection
        if (isConnected) {
          handleDeviceDisconnection();
        }
      }
    });

    // More frequent periodic check for better real-time experience
    periodicCheckTimer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      checkConnectionStatus();
    });

    print('📱 APP: Real-time monitoring setup complete');
  }

  // Monitor specific device connection state
  void monitorDeviceConnection(BluetoothDevice device) {
    connectionStateSubscription?.cancel();

    connectionStateSubscription = device.connectionState.listen(
      (BluetoothConnectionState state) {
        print('📱 APP: Device connection state changed: $state');

        if (state == BluetoothConnectionState.disconnected) {
          handleDeviceDisconnection();
        } else if (state == BluetoothConnectionState.connected) {
          handleDeviceConnection(device);
        }
      },
      onError: (error) {
        print('📱 APP ERROR: Connection state stream error: $error');
      },
    );
  }

  // Handle device disconnection
  Future<void> handleDeviceDisconnection() async {
    print('📱 APP: Device disconnected detected');

    setState(() {
      isConnected = false;
      connectedDevice = null;
      connectedCharacteristic = null;
      connectionStatus = "Not Connected";
    });

    await clearConnectionState();
  }

  // Handle device connection
  Future<void> handleDeviceConnection(BluetoothDevice device) async {
    print('📱 APP: Device connected detected');

    setState(() {
      isConnected = true;
      connectedDevice = device;
      connectionStatus = "Connected to Sanitary Pad Dispenser";
    });

    await saveConnectionState(device, true);
  }

  // Check connection status from device list
  Future<void> checkConnectionStatusFromDeviceList(
    List<BluetoothDevice> connectedDevices,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDeviceId = prefs.getString('connected_device_id');

      if (savedDeviceId != null) {
        final device = connectedDevices
            .where((d) => d.id.toString() == savedDeviceId)
            .firstOrNull;

        if (device != null && !isConnected) {
          // Device found and we're not currently showing as connected
          handleDeviceConnection(device);
          monitorDeviceConnection(device);
        } else if (device == null && isConnected) {
          // Device not found but we're showing as connected
          handleDeviceDisconnection();
        }
      } else if (isConnected) {
        // No saved device ID but showing as connected
        handleDeviceDisconnection();
      }
    } catch (e) {
      print('📱 APP ERROR: Error checking connection from device list: $e');
    }
  }

  // Load connection state from shared preferences
  Future<void> loadConnectionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedConnectionStatus = prefs.getBool('is_connected') ?? false;
      final savedDeviceId = prefs.getString('connected_device_id');

      if (savedConnectionStatus && savedDeviceId != null) {
        // Check if device is actually connected
        final connectedDevices = FlutterBluePlus.connectedDevices;
        final device = connectedDevices
            .where((d) => d.id.toString() == savedDeviceId)
            .firstOrNull;

        if (device != null) {
          setState(() {
            isConnected = true;
            connectedDevice = device;
            connectionStatus = "Connected to Sanitary Pad Dispenser";
          });

          // Start monitoring this specific device
          monitorDeviceConnection(device);
        } else {
          // Device not actually connected, clear saved state
          await clearConnectionState();
        }
      }
    } catch (e) {
      print('📱 APP ERROR: Error loading connection state: $e');
    }
  }

  // Save connection state to shared preferences
  Future<void> saveConnectionState(
    BluetoothDevice? device,
    bool connected,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_connected', connected);

      if (connected && device != null) {
        await prefs.setString('connected_device_id', device.id.toString());
        await prefs.setString('connected_device_name', device.name);
      } else {
        await prefs.remove('connected_device_id');
        await prefs.remove('connected_device_name');
      }
    } catch (e) {
      print('📱 APP ERROR: Error saving connection state: $e');
    }
  }

  // Clear connection state
  Future<void> clearConnectionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_connected');
      await prefs.remove('connected_device_id');
      await prefs.remove('connected_device_name');

      setState(() {
        isConnected = false;
        connectedDevice = null;
        connectedCharacteristic = null;
        connectionStatus = "Not Connected";
      });

      // Cancel device-specific monitoring
      connectionStateSubscription?.cancel();
    } catch (e) {
      print('📱 APP ERROR: Error clearing connection state: $e');
    }
  }

  // Check connection status manually (with enhanced real-time checking)
  Future<void> checkConnectionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDeviceId = prefs.getString('connected_device_id');
      final savedConnectionStatus = prefs.getBool('is_connected') ?? false;

      if (savedConnectionStatus && savedDeviceId != null) {
        final connectedDevices = FlutterBluePlus.connectedDevices;
        final device = connectedDevices
            .where((d) => d.id.toString() == savedDeviceId)
            .firstOrNull;

        if (device != null && !isConnected) {
          // Device found and we're not currently showing as connected
          await handleDeviceConnection(device);
          monitorDeviceConnection(device);
        } else if (device == null && isConnected) {
          // Device not found but we're showing as connected
          await handleDeviceDisconnection();
        }
      } else if (isConnected) {
        // No saved connection but showing as connected
        await handleDeviceDisconnection();
      }
    } catch (e) {
      print('📱 APP ERROR: Error checking connection status: $e');
    }
  }

  // Handle connection result from ConnectWithBT page
  Future<void> handleConnectionResult(dynamic result) async {
    if (result != null && result is Map) {
      if (result['connected'] == true) {
        final device = result['device'] as BluetoothDevice?;
        if (device != null) {
          setState(() {
            isConnected = true;
            connectedDevice = device;
            connectedCharacteristic = result['characteristic'];
            connectionStatus = "Connected to Sanitary Pad Dispenser";
            errorMessage = null;
          });

          await saveConnectionState(device, true);
          monitorDeviceConnection(device);
        }
      } else if (result['disconnected'] == true) {
        await handleDeviceDisconnection();
      }
    }
  }

  // Navigate to connection page
  Future<void> navigateToConnection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectWithBT(
          alreadyConnectedDevice: connectedDevice,
          alreadyConnectedCharacteristic: connectedCharacteristic,
        ),
      ),
    );

    await handleConnectionResult(result);
  }

  // Navigate to manage fingerprints
  Future<void> navigateToManageFingerprints() async {
    if (isConnected) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Managefingerprints(employeeId: employeeId),
        ),
      );

      // No need to handle scanning result since real-time monitoring will detect disconnection
      print('📱 APP: Returned from fingerprint management');
    } else {
      setState(() {
        errorMessage = "Please connect with dispenser first";

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              errorMessage = null;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF74370),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 40, top: 60),
              child: Text(
                "Hi NIC!",
                style: TextStyle(
                  fontFamily: "Helvetica",
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 130),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 10.1,
                      offset: const Offset(2, -6),
                    ),
                  ],
                  color: Color(0xFFFDF5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(37),
                    topRight: Radius.circular(37),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Image.asset("asset/icons/nicLogo.png"),
                      ),

                      // Real-time Connection Status Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isConnected
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isConnected
                                ? Colors.green.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Animated connection icon
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Icon(
                                isConnected
                                    ? Icons.bluetooth_connected
                                    : Icons.bluetooth_disabled,
                                key: ValueKey(isConnected),
                                color: isConnected ? Colors.green : Colors.grey,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Dispenser Status",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    child: Text(
                                      connectionStatus,
                                      key: ValueKey(connectionStatus),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isConnected
                                            ? Colors.green[700]
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      CustomButton(
                        text: isConnected
                            ? "Manage Dispenser Connection"
                            : "Connect with Dispenser",
                        onPressed: navigateToConnection,
                      ),

                      SizedBox(height: 10),

                      CustomButton(
                        text: "Manage your Fingerprints",
                        onPressed: navigateToManageFingerprints,
                      ),

                      if (errorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 12,
                              color: const Color.fromARGB(255, 197, 23, 23),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      SizedBox(height: 10),

                      CustomButton(
                        text: 'Log out',
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: CustomTextStyles.normal(),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Logout',
                                      style: CustomTextStyles.normal(
                                        color: Color.fromARGB(255, 15, 5, 8),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.clear();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Login(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
