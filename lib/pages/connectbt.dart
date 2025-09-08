// ignore_for_file: cast_from_null_always_fails

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dispenser/widgets/buttons.dart';
import 'package:dispenser/widgets/ripple.dart';
import 'package:dispenser/widgets/text.dart';

class ConnectWithBT extends StatefulWidget {
  final BluetoothDevice? alreadyConnectedDevice;
  final BluetoothCharacteristic? alreadyConnectedCharacteristic;

  const ConnectWithBT({
    super.key,
    this.alreadyConnectedDevice,
    this.alreadyConnectedCharacteristic,
  });

  @override
  State<ConnectWithBT> createState() => _ConnectWithBTState();
}

class _ConnectWithBTState extends State<ConnectWithBT>
    with TickerProviderStateMixin {
  // Animation controllers
  bool isSearching = false;
  late AnimationController _rippleController;
  late AnimationController _fadeController;

  // Bluetooth variables
  final String serviceUUID = "12345678-1234-1234-1234-123456789abc";
  final String characteristicUUID = "87654321-4321-4321-4321-cba987654321";

  String statusMessage =
      "Please turn on Bluetooth before scanning for dispensers";
  List<BluetoothDevice> scanResults = [];
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? targetCharacteristic;
  bool isConnecting = false;
  bool isDisconnecting = false;
  bool isAlreadyConnected = false;

  @override
  void initState() {
    super.initState();
    initializeAnimations();
    requestPermissions();
    checkExistingConnection();
  }

  // Check existing connection more thoroughly
  Future<void> checkExistingConnection() async {
    try {
      // First check if we have passed devices
      if (widget.alreadyConnectedDevice != null) {
        // Verify the device is still actually connected
        final connectedDevices = FlutterBluePlus.connectedDevices;
        final deviceStillConnected = connectedDevices.any(
          (device) => device.id == widget.alreadyConnectedDevice!.id,
        );

        if (deviceStillConnected) {
          setState(() {
            connectedDevice = widget.alreadyConnectedDevice;
            targetCharacteristic = widget.alreadyConnectedCharacteristic;
            isAlreadyConnected = true;
            statusMessage = "Sanitary Pad Dispenser is already connected!";
          });
        } else {
          // Device is not actually connected, clear the saved state
          await clearSavedConnectionState();
          setState(() {
            isAlreadyConnected = false;
            statusMessage =
                "Previous connection lost. Please scan for dispenser.";
          });
        }
      } else {
        // Check if there's any "Sanitary Pad Dispenser" connected
        final connectedDevices = FlutterBluePlus.connectedDevices;
        final dispenserDevice = connectedDevices.firstWhere(
          (device) => device.name == "Sanitary Pad Dispenser",
          orElse: () => null as BluetoothDevice,
        );

        setState(() {
          connectedDevice = dispenserDevice;
          isAlreadyConnected = true;
          statusMessage = "Sanitary Pad Dispenser is already connected!";
        });

        // Save this connection state
        await saveConnectionState(dispenserDevice, true);
      }
    } catch (e) {
      print('Error checking existing connection: $e');
      setState(() {
        statusMessage =
            "Error checking connection status. Please try scanning.";
      });
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
      print('Error saving connection state: $e');
    }
  }

  // Clear saved connection state
  Future<void> clearSavedConnectionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_connected');
      await prefs.remove('connected_device_id');
      await prefs.remove('connected_device_name');
    } catch (e) {
      print('Error clearing connection state: $e');
    }
  }

  void initializeAnimations() {
    // Initialize ripple animation controller
    _rippleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Initialize fade animation controller
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Create ripple animation

    // Create fade animation for ripples
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    print("Permissions: $statuses");
  }

  Future<void> scanForDevices() async {
    if (isSearching) return;

    setState(() {
      isSearching = true;
      scanResults.clear();
      statusMessage = "Scanning for Sanitary Pad Dispenser...";
    });

    // Start ripple animation
    _rippleController.repeat();
    _fadeController.repeat();

    try {
      // Check if Bluetooth is on
      if (await FlutterBluePlus.isOn == false) {
        setState(() {
          statusMessage = "Please turn on Bluetooth";
          isSearching = false;
        });
        stopAnimations();
        return;
      }

      FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          // Search specifically for "Sanitary Pad Dispenser"
          if (result.device.name.isNotEmpty &&
              result.device.name == "Sanitary Pad Dispenser") {
            if (!scanResults.any((device) => device.id == result.device.id)) {
              setState(() {
                scanResults.add(result.device);
              });
            }
          }
        }
      });

      await Future.delayed(Duration(seconds: 5));
      FlutterBluePlus.stopScan();

      setState(() {
        isSearching = false;
        if (scanResults.isEmpty) {
          statusMessage =
              "Sanitary Pad Dispenser not found. Make sure the dispenser is turned on and in pairing mode.";
        } else {
          statusMessage = "Sanitary Pad Dispenser found! Tap to connect.";
        }
      });

      stopAnimations();
    } catch (e) {
      setState(() {
        isSearching = false;
        statusMessage = "Scan error: $e";
      });
      stopAnimations();
    }
  }

  void stopSearching() {
    if (isSearching) {
      FlutterBluePlus.stopScan();
    }
    setState(() {
      isSearching = false;
      statusMessage = "Scan stopped";
    });
    stopAnimations();
  }

  void stopAnimations() {
    _rippleController.stop();
    _rippleController.reset();
    _fadeController.stop();
    _fadeController.reset();
  }

  Future<void> disconnectDevice() async {
    if (isDisconnecting || connectedDevice == null) return;

    setState(() {
      isDisconnecting = true;
      statusMessage = "Disconnecting from Sanitary Pad Dispenser...";
    });

    try {
      await connectedDevice!.disconnect();

      // Clear saved connection state
      await saveConnectionState(null, false);

      setState(() {
        connectedDevice = null;
        targetCharacteristic = null;
        isAlreadyConnected = false;
        isDisconnecting = false;
        statusMessage = "Successfully disconnected from Sanitary Pad Dispenser";
      });

      // Wait a moment to show success message
      await Future.delayed(Duration(seconds: 1));

      // Return to home page with disconnection result
      Navigator.pop(context, {'disconnected': true});
    } catch (e) {
      setState(() {
        statusMessage = "Disconnect failed: ${e.toString()}";
        isDisconnecting = false;
      });
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (isConnecting) return;

    setState(() {
      isConnecting = true;
      statusMessage = "Connecting to Sanitary Pad Dispenser...";
    });

    try {
      // Connect to the device
      await device.connect();
      connectedDevice = device;

      // Discover services
      List<BluetoothService> services = await device.discoverServices();

      // Find our specific service and characteristic
      for (BluetoothService service in services) {
        if (service.uuid.toString().toLowerCase() ==
            serviceUUID.toLowerCase()) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() ==
                characteristicUUID.toLowerCase()) {
              targetCharacteristic = characteristic;

              // Subscribe to notifications if available
              if (characteristic.properties.notify) {
                await characteristic.setNotifyValue(true);
              }

              // Save connection state
              await saveConnectionState(device, true);

              setState(() {
                statusMessage =
                    "Successfully connected to Sanitary Pad Dispenser!";
              });

              // Wait a moment to show success message
              await Future.delayed(Duration(seconds: 1));

              // Return to home page with connected device
              Navigator.pop(context, {
                'device': device,
                'characteristic': targetCharacteristic,
                'connected': true,
              });
              return;
            }
          }
        }
      }

      // If we reach here, service/characteristic not found
      await device.disconnect();
      setState(() {
        statusMessage = "Service not found. Please try again.";
        isConnecting = false;
      });
    } catch (e) {
      setState(() {
        statusMessage = "Connection failed: ${e.toString()}";
        isConnecting = false;
      });

      // Try to disconnect if there was an error
      try {
        await device.disconnect();
      } catch (disconnectError) {
        print("Disconnect error: $disconnectError");
      }
    }
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Device", style: CustomTextStyles.subheading()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
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
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isAlreadyConnected) ...[
                          // Already connected state
                          Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 60,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Connected to',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  connectedDevice?.name ??
                                      'Sanitary Pad Dispenser',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 16),

                                CustomButton(
                                  text: isDisconnecting
                                      ? 'Disconnecting...'
                                      : 'Disconnect Device',
                                  onPressed: disconnectDevice,
                                  isLoading: isDisconnecting,
                                  icon: const Icon(
                                    Icons.bluetooth_disabled,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (!isSearching && scanResults.isEmpty) ...[
                          // Initial state
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              statusMessage,
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.normal(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          // Static Bluetooth icon
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
                              Icons.bluetooth,
                              size: 40,
                              color: Color(0xFFFF386A),
                            ),
                          ),
                        ] else if (isSearching) ...[
                          // Searching state
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              statusMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          // Animated ripple effect
                          Container(
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
                                // Center Bluetooth icon
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
                                    Icons.bluetooth,
                                    size: 40,
                                    color: Color(0xFFFF386A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (scanResults.isNotEmpty) ...[
                          // Found devices state
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Text(
                                  statusMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Device list
                                ...scanResults.map(
                                  (device) => Card(
                                    color: Color(0xFFFF386A),
                                    margin: EdgeInsets.only(bottom: 12),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      leading: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.bluetooth,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                      title: Text(
                                        device.name.isNotEmpty
                                            ? device.name
                                            : "Unknown Dispenser",
                                        style: CustomTextStyles.normal(
                                          color: Colors.white,
                                        ),
                                      ),
                                      trailing: isConnecting
                                          ? SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                      onTap: isConnecting
                                          ? null
                                          : () => connectToDevice(device),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom buttons
              if (!isAlreadyConnected) ...[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (scanResults.isNotEmpty && !isSearching) ...[],

                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed:
                              (isSearching ||
                                  isConnecting ||
                                  isAlreadyConnected)
                              ? null
                              : scanForDevices,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE91E63),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSearching || isConnecting) ...[
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                              ],
                              Text(
                                isConnecting
                                    ? 'Connecting...'
                                    : (isSearching
                                          ? 'Searching'
                                          : (scanResults.isEmpty
                                                ? 'Start Scanning for Dispenser'
                                                : 'Scan for Dispenser Again')),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (!isSearching && !isConnecting) ...[
                                SizedBox(width: 50),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: CustomButton(
                      text: "Back to Home",
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
