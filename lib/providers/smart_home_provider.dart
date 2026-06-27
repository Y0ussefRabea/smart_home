import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_home/services/device_state_service.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';

class SmartHomeProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  void addNotification(String title, String type) {
    _notifications.insert(0, NotificationModel(
      title: title,
      type: type,
      time: DateTime.now(),
    ));
    notifyListeners();
  }
  StreamSubscription<DatabaseEvent>? _statesSubscription;

  ///sensors
  double _temperature = 0;
  double _humidity = 0;
  bool _gasSafe = true;
  String _doorState = 'Unknown';

  ///system mode
  bool _autoMode = true;

  ///devices
  bool _outsideLightsOn = false;
  bool _roomFanOn = false;
  bool _kitchenHoodOn = false;
  bool _mainDoorLocked = false;

  bool _isLoading = true;

  ///alerts
  bool _gasAlertSent = false;
  bool _doorAlertSent = false;
  bool _tempAlertSent = false;

  ///getters, to get the values
  double get temperature => _temperature;
  double get humidity => _humidity;
  bool get gasSafe => _gasSafe;
  String get doorState => _doorState;
  bool get autoMode => _autoMode;

  bool get outsideLightsOn => _outsideLightsOn;
  bool get roomFanOn => _roomFanOn;
  bool get kitchenHoodOn => _kitchenHoodOn;
  bool get mainDoorLocked => _mainDoorLocked;

  bool get isLoading => _isLoading;

  void startListening() {
    _statesSubscription ??= DeviceStateService.statesStream.listen((event) {
      final rootMap = _asMap(event.snapshot.value); ///_asMap converts the object to a map(key:value)
      final sensors = _asMap(rootMap['sensors']);
      final devices = _asMap(rootMap['devices']);

      _temperature = _asDouble(
        sensors['temperature'],
        fallback: 0,
      ); // fallback is reserve value
      _humidity = _asDouble(sensors['humidity'], fallback: 0);
      _gasSafe = _asBool(sensors['gasSafe'], fallback: true);
      _doorState = _asDoorState(sensors['doorState']);

                                ///notifications handling///
      /// Gas Leak
      if (!_gasSafe && !_gasAlertSent) {
        _gasAlertSent = true;
        NotificationService.showNotification(title: 'Gas Leak Detected', body: "the kitchen hood is on");
        addNotification('Gas Leak Detected', 'gas');
      }else if (_gasSafe) {
        _gasAlertSent = false; //reset
      }

     /// Door Opened
      if (_doorState.toLowerCase() == 'unlocked' && !_doorAlertSent) {
        _doorAlertSent = true;
        NotificationService.showNotification(title: 'Door Unlocked', body: 'the main door has been unlocked');
        addNotification('Door Unlocked', 'door');
      }else if(_doorState.toLowerCase() == 'locked'){
       _doorAlertSent=false;
      }

     /// High Temperature
      if (_temperature > 35 && !_tempAlertSent) {
        _tempAlertSent = true;
        NotificationService.showNotification(title: 'High Temperature', body: 'high temperature detected, the fan is on now');
        addNotification('High Temperature', 'temp');
      }else if (_temperature <= 35) {
        _tempAlertSent = false;
      }

      _outsideLightsOn = _asBool(devices['outsideLights'], fallback: false);
      _roomFanOn = _asBool(devices['roomFan'], fallback: false);
      _kitchenHoodOn = _asBool(devices['kitchenHood'], fallback: false);
      _mainDoorLocked = _asBool(devices['mainDoorLocked'], fallback: false);
      _autoMode = _asBool(devices['autoMode'], fallback: true);

      _isLoading = false;
      notifyListeners(); //change the UI
    });
  }

  Future<void> setAutoMode(bool value) async {
    await DeviceStateService.setAutoMode(value);

    ///to turn off the switches when the auto mode is on///
    if (value == true) {
      await DeviceStateService.setOutsideLights(false);
      await DeviceStateService.setRoomFan(false);
      await DeviceStateService.setKitchenHood(false);
    }
  }

  Future<void> setOutsideLights(bool value) async {
    await DeviceStateService.setOutsideLights(value);
  }

  Future<void> setRoomFan(bool value) async {
    await DeviceStateService.setRoomFan(value);
  }

  Future<void> setKitchenHood(bool value) async {
    await DeviceStateService.setKitchenHood(value);
  }

  Future<void> setMainDoorLocked(bool value) async {
    await DeviceStateService.setMainDoorLocked(value);
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  bool _asBool(dynamic value, {bool fallback = false}) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'on';
    }
    return fallback;
  }

  double _asDouble(dynamic value, {double fallback = 0.0}) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  String _asDoorState(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    return 'Unknown';
  }

  ///the language of the voice commands
  String _voiceLanguage = 'en_US'; // default
  String get voiceLanguage => _voiceLanguage;

  void setVoiceLanguage(String locale) {
    _voiceLanguage = locale;
    notifyListeners();
  }

  @override
  void dispose() {
    _statesSubscription?.cancel();
    super.dispose();
  }
}
