import 'package:firebase_database/firebase_database.dart';

class DeviceStateService {
  DeviceStateService._();

  static final DatabaseReference _rootRef =
      FirebaseDatabase.instance.ref('smart_home');

  static DatabaseReference get _sensorsRef => _rootRef.child('sensors');
  static DatabaseReference get _devicesRef => _rootRef.child('devices');

  static Stream<DatabaseEvent> get statesStream => _rootRef.onValue;

  static Future<void> setAutoMode(bool value) {
    return _devicesRef.child('autoMode').set(value);
  }

  static Future<void> setOutsideLights(bool value) {
    return _devicesRef.child('outsideLights').set(value);
  }

  static Future<void> setRoomFan(bool value) {
    return _devicesRef.child('roomFan').set(value);
  }

  static Future<void> setKitchenHood(bool value) {
    return _devicesRef.child('kitchenHood').set(value);
  }

  static Future<void> setMainDoorLocked(bool value) {
    return _devicesRef.child('mainDoorLocked').set(value);
  }

  static Future<void> setMainDoorState(String state) {
    return _sensorsRef.child('doorState').set(state);
  }

}
