import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class AgilDeviceInfo {
  Future<Map<String, String>>  getInfoMap() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String> finalInfo = {};
    if (GetPlatform.isWeb) {
      final WebBrowserInfo info = await deviceInfoPlugin.webBrowserInfo;
      finalInfo.putIfAbsent('hostname', () => info.browserName.name);
      finalInfo.putIfAbsent('platform', () => 'Web');
    } else if (GetPlatform.isWindows) {
      final WindowsDeviceInfo info = await deviceInfoPlugin.windowsInfo;
      finalInfo.putIfAbsent('hostname', () => info.computerName);
      finalInfo.putIfAbsent('platform', () => 'Windows_${info.majorVersion}');
    } else if (GetPlatform.isMacOS) {
      final MacOsDeviceInfo info = await deviceInfoPlugin.macOsInfo;
      finalInfo.putIfAbsent('hostname', () => info.computerName);
      finalInfo.putIfAbsent('platform', () => 'MacOS');
    } else if (GetPlatform.isLinux) {
      final LinuxDeviceInfo info = await deviceInfoPlugin.linuxInfo;
      finalInfo.putIfAbsent('hostname', () => info.name + (info.version ?? ''));
      finalInfo.putIfAbsent('platform', () => 'Linux');
    } else if (GetPlatform.isAndroid) {
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      finalInfo.putIfAbsent('hostname', () => info.model);
      finalInfo.putIfAbsent(
          'platform', () => 'Android ${info.version.release}');
    } else if (GetPlatform.isIOS) {
      final IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
      finalInfo.putIfAbsent('hostname', () => info.model);
      finalInfo.putIfAbsent('platform', () => 'IOS');
    }

    return finalInfo;
  }
}


