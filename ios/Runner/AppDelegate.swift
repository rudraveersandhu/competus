import UIKit
import OtplessSDK
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      if Otpless.sharedInstance.isOtplessDeeplink(url: url){
      Otpless.sharedInstance.processOtplessDeeplink(url: url) }
      return true
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      for context in URLContexts {
        if Otpless.sharedInstance.isOtplessDeeplink(url: context.url.absoluteURL) {
        Otpless.sharedInstance.processOtplessDeeplink(url: context.url.absoluteURL)
        break
        }
      }
  }


//  override func application(
//  _ application: UIApplication,
//  open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//  ) -> Bool {
//    if Otpless.sharedInstance.isOtplessDeeplink(url: url) {
//      Otpless.sharedInstance.processOtplessDeeplink(url: url)
//      return true
//    }
//    return super.application(application, open: url, options: options)
//  }

}