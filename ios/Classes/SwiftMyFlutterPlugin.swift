import Flutter
import UIKit
import AVFoundation

public class SwiftMyFlutterPlugin: NSObject, FlutterPlugin {
  private var player: AVAudioPlayer?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "my_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftMyFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      return result("iOS " + UIDevice.current.systemVersion)
    case "playSound":
      return playSound(result: result)
    default:
      return result(FlutterMethodNotImplemented)
    }
  }

  private func playSound(result: @escaping FlutterResult) {
    if player?.isPlaying == true { return }

    let filename = "clap"
    let fileExtension = "wav"
    guard let url = Bundle(for: type(of: self)).url(forResource: filename, withExtension: fileExtension) else {
      let flutterError = FlutterError(
        code: "fileNotFound",
        message: "File not found: \(filename).\(fileExtension).",
        details: nil
      )
      return result(flutterError)
    }

    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      let flutterError = FlutterError(
        code: "audioSessionSetupError",
        message: "Error on AVAudionSession setup.",
        details: error.localizedDescription
      )
      return result(flutterError)
    }

    do {
      player = try AVAudioPlayer(contentsOf: url)
      player?.play()
    } catch {
      let flutterError = FlutterError(
        code: "audioPlayerSetupError",
        message: "Error on AVAudioPlayer setup.",
        details: error.localizedDescription
      )
      return result(flutterError)
    }
  }
}
