import 'package:dispenser/pages/homepage.dart';
import 'package:dispenser/pages/timeout.dart';
import 'package:flutter/material.dart';
import 'package:dispenser/widgets/buttons.dart';
import 'package:dispenser/widgets/ripple.dart';
import 'package:dispenser/widgets/text.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanningFingerprint extends StatefulWidget {
  final String fingerprintId;
  const ScanningFingerprint({super.key, required this.fingerprintId});

  @override
  State<StatefulWidget> createState() => _ScanningFingerprint();
}

class _ScanningFingerprint extends State<ScanningFingerprint> {
  bool isScanning = false;
  bool firstScanComplete = false;
  bool scanningCompleted = false;
  bool isDisconnecting = false; // Added for disconnect status
  Timer? scanTimer;
  Timer? disconnectTimer; // Added for auto-disconnect
  StreamSubscription<List<int>>? bluetoothSubscription;
  String receivedData = '';
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? connectedCharacteristic;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeBluetoothConnection();

    print('📱 APP: Fingerprint ID received: ${widget.fingerprintId}');
  }

  @override
  void dispose() {
    scanTimer?.cancel();
    disconnectTimer?.cancel(); // Cancel disconnect timer
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
        print('📱 APP TERMINAL: First scan complete, remove finger');
        setState(() {
          firstScanComplete = false; // Still on first scan phase
        });
        break;

      case 'StartSecondScan':
        print('📱 APP TERMINAL: Starting second scan');
        setState(() {
          firstScanComplete = true;
          isScanning = true; // Ensure scanning continues
        });
        break;

      case 'Completed':
        print('📱 APP TERMINAL: Fingerprint enrollment completed');
        setState(() {
          _timer?.cancel();
          isScanning = false;
          firstScanComplete = false; // Reset for next time
          scanningCompleted = true;
        });

        // Start auto-disconnect after 2 seconds
        _startAutoDisconnect();
        break;

      default:
        print('📱 APP: Unknown message received: $message');
    }
  }

  // Start auto-disconnect timer
  void _startAutoDisconnect() {
    disconnectTimer = Timer(Duration(seconds: 2), () {
      _performDisconnection();
    });
  }

  // Perform the disconnection
  Future<void> _performDisconnection() async {
    setState(() {
      isDisconnecting = true;
    });

    try {
      // Disconnect the device
      if (connectedDevice != null) {
        await connectedDevice!.disconnect();
        print('📱 APP: Device disconnected successfully');

        // Wait a bit to ensure disconnection is processed
        await Future.delayed(Duration(milliseconds: 500));
      }

      // Clear connection state in SharedPreferences
      await _clearConnectionState();

      // Update UI
      setState(() {
        isDisconnecting = false;
      });

      print('📱 APP: Auto-disconnect completed');
    } catch (e) {
      print('📱 APP ERROR: Failed to disconnect: $e');
      setState(() {
        isDisconnecting = false;
      });
    }
  }

  // Clear connection state from SharedPreferences
  Future<void> _clearConnectionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_connected');
      await prefs.remove('connected_device_id');
      await prefs.remove('connected_device_name');
      print('📱 APP: Connection state cleared from SharedPreferences');
    } catch (e) {
      print('📱 APP ERROR: Failed to clear connection state: $e');
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

  void startScanning() {
    setState(() {
      isScanning = true;
      _timer = Timer(const Duration(seconds: 30), () {
        // Navigate after 30 seconds
        if (!firstScanComplete) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Timeout()),
          );
        }
      });
    });
    _sendBluetoothMessage('StartScan_${widget.fingerprintId}_');
    print(
      '📱 APP: Starting fingerprint scanning... with ID = _${widget.fingerprintId}_',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFDF5F5),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {
            // Return result indicating potential disconnection
            Navigator.pop(context, {'scanning_completed': scanningCompleted}),
          },
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
                  if (scanningCompleted)
                    scanningCompletedWidget()
                  else if (isScanning)
                    scanningWidget()
                  else
                    instructionsWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column instructionsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Follow these steps to scan your fingerprint:",
            style: CustomTextStyles.subheading(),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 20),

        // Instructions with GIF placeholder
        Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "asset/icons/fingerprint_demo.gif",
              fit: BoxFit.contain,
            ),
          ),
        ),

        SizedBox(height: 25),

        // Step-by-step instructions
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              _buildInstructionStep(
                "1",
                "Place your finger on the scanner. Wait for 2 seconds.",
                Icons.touch_app,
              ),
              SizedBox(height: 15),
              _buildInstructionStep("2", "Remove your finger", Icons.pan_tool),
              SizedBox(height: 15),
              _buildInstructionStep(
                "3",
                "Place your finger again for verification until scanning process is completed",
                Icons.touch_app,
              ),
            ],
          ),
        ),

        SizedBox(height: 35),
        CustomButton(text: "Start Scanning", onPressed: startScanning),
      ],
    );
  }

  Widget _buildInstructionStep(
    String stepNumber,
    String instruction,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Color(0xFFFF386A),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(width: 15),
        Icon(icon, color: Color(0xFFFF386A), size: 24),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            instruction,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Column scanningWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Scanning in Progress",
            style: CustomTextStyles.normal(),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 20),
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

  Column scanningCompletedWidget() {
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
                  isDisconnecting
                      ? "Your fingerprint has been registered. Disconnecting dispenser..."
                      : "Your fingerprint has been successfully registered, you can now use the dispenser",
                  style: CustomTextStyles.normal(),
                  textAlign: TextAlign.center,
                ),
              ),

              // Show disconnecting indicator
              if (isDisconnecting) ...[
                SizedBox(height: 15),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF386A),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 25),
        CustomButton(
          text: "Continue",
          onPressed: isDisconnecting
              ? null
              : () {
                  // Navigate back to homepage using pushReplacement
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyHomePage(fingerprintId: widget.fingerprintId),
                    ),
                  );
                },
        ),
      ],
    );
  }
}
