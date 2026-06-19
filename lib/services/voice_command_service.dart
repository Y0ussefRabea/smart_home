import 'package:speech_to_text/speech_to_text.dart';
import 'package:smart_home/services/device_state_service.dart';

class VoiceCommandService {
  static final SpeechToText _speech = SpeechToText();
  static bool _isListening = false;
  static bool get isListening => _isListening;

  static Future<void> initialize() async {
    await _speech.initialize();
  }

  static Future<String?> listen(String localeId) async {
    if (!_speech.isAvailable) return null;

    String? recognizedText;

    await _speech.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords.toLowerCase();
      },
      listenFor: const Duration(seconds: 5),
      localeId: localeId,
    );

    _isListening = true;


    await Future.delayed(const Duration(seconds: 5));
    await _speech.stop();
    _isListening = false;

    return recognizedText;
  }

  static Future<String> processCommand(String text) async {
    //todo:i added auto mode and door commands before checking the auto mode state cause they are not under the control of auto mode
    /// Auto Mode
    if (text.contains('turn on')&&text.contains('auto') || text.contains('enable auto')||
        text.contains('افتح') && text.contains('الوضع الالي') || text.contains('افتح الوضع الالي')) {
      await DeviceStateService.setAutoMode(true);
     // return 'Auto Mode ON';
    }
    if (text.contains('turn off')&&text.contains('auto') || text.contains('disable auto')||
        text.contains('اقفل') && text.contains('الوضع الالي') || text.contains('اقفل الوضع الالي')) {
      await DeviceStateService.setAutoMode(true);
      return 'Auto Mode OFF';
    }
    //todo: Door
    if (text.contains('open') && text.contains('door') || text.contains('unlock door') ||
        text.contains('افتح') && text.contains('باب') || text.contains('افتح الباب')) {
      await DeviceStateService.setMainDoorLocked(false);
      return 'Door Unlocked';
    }

    if (text.contains('close') && text.contains('door') || text.contains('lock door') ||
        text.contains('اقفل') && text.contains('باب') || text.contains('اقفل الباب')||
    text.contains('أغلق') && text.contains('باب') || text.contains('أغلق الباب'))
    {
      await DeviceStateService.setMainDoorLocked(true);
      return 'Door Locked';
    }

    ///check auto mode state
    final autoMode = await DeviceStateService.getAutoMode();
    if (autoMode) {
      return '🤖 Auto mode is ON, disable it first';
    }

    //todo: Lights
    if (text.contains('turn on') && text.contains('light') || text.contains('open light')||
        text.contains('افتح') && text.contains('نور') || text.contains('افتح النور')||
        text.contains('شغل') && text.contains('نور') || text.contains('شغل النور'))
    {
        await DeviceStateService.setOutsideLights(true);
        return 'Lights turned ON';
    }
    if (text.contains('turn off') && text.contains('light') || text.contains('close light')|
    text.contains('اقفل') && text.contains('نور') || text.contains('اقفل النور')||
        text.contains('أغلق') && text.contains('نور') || text.contains('أغلق النور'))
    {
      await DeviceStateService.setOutsideLights(false);
      return 'Lights turned OFF';
    }

    // todo:FAN

    ///turn on
    if (text.contains('turn on') && text.contains('fan') || text.contains('open fan')||
        text.contains('افتح') && text.contains('مروحه') || text.contains('افتح المروحه')||
        text.contains('شغل') && text.contains('مروحه') || text.contains('شغل المروحه'))
    {
      await DeviceStateService.setRoomFan(true);
      return 'Fan turned ON';
    }
    ///turn off
    if (text.contains('turn off') && text.contains('fan') || text.contains('close fan')||
        text.contains('اقفل') && text.contains('مروحه') || text.contains('اقفل المروحه')||
        text.contains('أغلق') && text.contains('مروحه') || text.contains('أغلق المروحه'))
    {
      await DeviceStateService.setRoomFan(false);
      return 'Fan turned OFF';
    }

    //todo: Kitchen Hood
    if (text.contains('turn on') && text.contains('hood') || text.contains('open hood')||
        text.contains('افتح') && text.contains('شفاط') || text.contains('افتح الشفاط')||
        text.contains('شغل') && text.contains('شفاط') || text.contains('شغل الشفاط'))
    {
      await DeviceStateService.setKitchenHood(true);
      return 'Hood turned ON';
    }
    if (text.contains('turn off') && text.contains('hood') ||text.contains('close hood')||
    text.contains('اقفل') && text.contains('شفاط') || text.contains('اقفل الشفاط')||
    text.contains('أغلق') && text.contains('شفاط') || text.contains('أغلق الشفاط')) {
      await DeviceStateService.setKitchenHood(false);
      return 'Hood turned OFF';
    }

    return '❓ Command not recognized: "$text"';
  }
}