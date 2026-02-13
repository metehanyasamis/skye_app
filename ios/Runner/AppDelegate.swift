import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let didFinish = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "com.skye.app/mapbox_config",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { (call, result) in
        if call.method == "getMapboxAccessToken" {
          let token = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String ?? ""
          result(token)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return didFinish
  }
}
