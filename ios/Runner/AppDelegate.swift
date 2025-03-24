import UIKit
import Flutter
import Firebase  // Import Firebase library

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()  // Initialize Firebase
    GeneratedPluginRegistrant.register(with: self)  // Default Flutter setup
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
