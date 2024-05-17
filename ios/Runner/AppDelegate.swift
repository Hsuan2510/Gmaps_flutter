import UIKit
import Flutter
import GoogleMaps //add this line

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyAu0NhZgWZeX8X4nopaP9PVpGLrTr56dGw") //add this line
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
