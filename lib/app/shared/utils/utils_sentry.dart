import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry/sentry.dart';

import 'utils_platform.dart';

class UtilsSentry {
  static void configureSentry() {
    FlutterError.onError =
        (FlutterErrorDetails details, {bool forceReport = false}) {
      if (UtilsPlatform.isDebug()) {
        // In development mode, simply print to console.
        FlutterError.dumpErrorToConsole(details);
      } else {
        // In production mode, report to the application zone to report to Sentry.
        Zone.current.handleUncaughtError(details.exception, details.stack);
      }
    };
  }

  static Future<Event> getSentryEnvEvent(
      dynamic exception, dynamic stackTrace) async {
    /// return Event with IOS extra information to send it to Sentry
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return Event(
        release: '1.4',
        environment: 'production', // replace it as it's desired
        extra: <String, dynamic>{
          'name': iosDeviceInfo.name,
          'model': iosDeviceInfo.model,
          'systemName': iosDeviceInfo.systemName,
          'systemVersion': iosDeviceInfo.systemVersion,
          'localizedModel': iosDeviceInfo.localizedModel,
          'utsname': iosDeviceInfo.utsname.sysname,
          'identifierForVendor': iosDeviceInfo.identifierForVendor,
          'isPhysicalDevice': iosDeviceInfo.isPhysicalDevice,
        },
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    /// return Event with Andriod extra information to send it to Sentry
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return Event(
        release: androidDeviceInfo.version.codename,
        environment: 'production', // replace it as it's desired
        extra: <String, dynamic>{
          'type': androidDeviceInfo.type,
          'model': androidDeviceInfo.model,
          'device': androidDeviceInfo.device,
          'id': androidDeviceInfo.id,
          'androidId': androidDeviceInfo.androidId,
          'brand': androidDeviceInfo.brand,
          'display': androidDeviceInfo.display,
          'hardware': androidDeviceInfo.hardware,
          'manufacturer': androidDeviceInfo.manufacturer,
          'product': androidDeviceInfo.product,
          'version': androidDeviceInfo.version.release,
          'supported32BitAbis': androidDeviceInfo.supported32BitAbis,
          'supported64BitAbis': androidDeviceInfo.supported64BitAbis,
          'supportedAbis': androidDeviceInfo.supportedAbis,
          'isPhysicalDevice': androidDeviceInfo.isPhysicalDevice,
        },
        exception: exception,
        stackTrace: stackTrace,
      );
    }

    /// Return standard Error in case of non-specifed paltform
    ///
    /// if there is no detected platform,
    /// just return a normal event with no extra information
    return Event(
      release: '2.0',
      environment: 'production',
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  static Future<void> reportError(Object error, StackTrace stackTrace,
      {dynamic data}) async {
    if (!UtilsPlatform.isDebug() || (UtilsPlatform.isWindows())) {
      try {
        final SentryClient sentry = new SentryClient(
            dsn: 'https://7efd66bc0ba3428d86d1d8fbfd29a308@sentry.io/2827683');
        // In production mode, report to the application zone to report to Sentry.
        final Event event = await getSentryEnvEvent(error, stackTrace);
        if (event.extra != null && data != null) {
          event.extra['json'] = data;
        }
        print('Sending report to sentry.io ${stackTrace.toString()}');
        await sentry.capture(event: event);
      } catch (e) {
        print('Sending report to sentry.io failed: $e');
        print('Original error: $error');
      }
      return;
    } else {
      // In development mode, simply print to console.
      print('No Sending report to sentry.io as mode is debugging DartError');
      // Print the full stacktrace in debug mode.
      print(stackTrace);
    }
  }
}
