import Foundation
#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif
import HaishinKit
import RTMPHaishinKit
import AVFoundation
import VideoToolbox
#if canImport(UIKit)
import UIKit
#endif

final class MediaMixerHandler: NSObject {
    var texture: HKStreamFlutterTexture?
    private lazy var mixer = MediaMixer(captureSessionMode: .multi, multiTrackAudioMixingEnabled: false)
    private var attachedVideoTracks: [UInt8] = []
    private var addedVideoTrackScreenObjects: [VideoTrackScreenObject] = []

    override init() {
        super.init()
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        #endif
    }

    func addOutput(_ output: some MediaMixerOutput) {
        Task {
            await mixer.addOutput(output)
            await mixer.startRunning()

            var videoMixerSettings = await mixer.videoMixerSettings
            videoMixerSettings.mode = .offscreen
            await mixer.setVideoMixerSettings(videoMixerSettings)
        }
    }

    func removeOutput(_ output: some MediaMixerOutput) {
        Task { await mixer.removeOutput(output) }
    }

    func stopRunning() {
        Task {
            await mixer.stopCapturing()
            await mixer.stopRunning()
        }
    }

    func dispose() async {
        await stopRunning()
        for track in attachedVideoTracks {
            _ = try? await mixer.attachVideo(nil, track: track)
        }
        _ = try? await mixer.attachAudio(nil, track: 0)
    }

    #if canImport(UIKit)
    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
        Task { await mixer.setVideoOrientation(orientation) }
    }
    #endif
}

extension MediaMixerHandler: MethodCallHandler {
    // MARK: MethodCallHandler
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let arguments = call.arguments as? [String: Any?] else {
            result(nil)
            return
        }
        switch call.method {
        case "RtmpStream#getHasAudio":
            Task {
                let isMuted = await !mixer.audioMixerSettings.isMuted
                result(isMuted)
            }
        case "RtmpStream#setHasAudio":
            guard let hasAudio = arguments["value"] as? Bool else {
                result(nil)
                return
            }
            Task {
                var audioMixerSettings = await mixer.audioMixerSettings
                audioMixerSettings.isMuted = !hasAudio
                await mixer.setAudioMixerSettings(audioMixerSettings)
                result(nil)
            }
        case "RtmpStream#getHasVideo":
            Task {
                let hasVideo = await !mixer.videoMixerSettings.isMuted
                result(hasVideo)
            }
        case "RtmpStream#setHasVideo":
            guard let hasVideo = arguments["value"] as? Bool else {
                result(nil)
                return
            }
            Task {
                var videoMixerSettings = await mixer.videoMixerSettings
                videoMixerSettings.isMuted = !hasVideo
                await mixer.setVideoMixerSettings(videoMixerSettings)
                result(nil)
            }
        case "RtmpStream#setFrameRate":
            guard
                let frameRate = arguments["value"] as? NSNumber else {
                result(nil)
                return
            }
            Task {
                _ = try? await mixer.setFrameRate(frameRate.doubleValue)
                result(nil)
            }
        case "RtmpStream#setSessionPreset":
            guard let sessionPreset = arguments["value"] as? String else {
                result(nil)
                return
            }
            let preset: AVCaptureSession.Preset = switch sessionPreset {
            case "high": .high
            case "medium": .medium
            case "low": .low
            case "hd1280x720": .hd1280x720
            case "hd1920x1080": .hd1920x1080
            case "hd4K3840x2160": .hd4K3840x2160
            case "vga640x480": .vga640x480
            case "iFrame960x540": .iFrame960x540
            case "iFrame1280x720": .iFrame1280x720
            case "cif352x288": .cif352x288
            default: .hd1280x720
            }
            Task {
                await mixer.setSessionPreset(preset)
                result(nil)
            }
        case "RtmpStream#attachAudio":
            let source = arguments["source"] as? [String: Any?]
            Task {
                if source == nil {
                    try? await mixer.attachAudio(nil)
                } else {
                    try? await mixer.attachAudio(AVCaptureDevice.default(for: .audio))
                }
                result(nil)
            }
        case "RtmpStream#setScreenSettings":
            guard
                let settings = arguments["settings"] as? [String: Any?],
                let width = settings["width"] as? NSNumber,
                let height = settings["height"] as? NSNumber else {
                result(nil)
                return
            }
            Task { @ScreenActor in
                mixer.screen.size = CGSize(width: CGFloat(width.floatValue), height: CGFloat(height.floatValue))
                result(texture?.id)
            }
        case "RtmpStream#attachVideo":
            let source = arguments["source"] as? [String: Any?]
            let id = source?["id"] as? String
            let track = arguments["track"] as? Int
            guard let id = id, let track = track else {
                Task {
                    try? await mixer.attachVideo(nil, track: 0)
                    attachedVideoTracks.append(0)
                    result(nil)
                }
                return
            }
            let device = AVCaptureDevice.init(uniqueID: id)
            Task {
                if let device = device {
                    try? await mixer.attachVideo(device, track: UInt8(track))
                    attachedVideoTracks.append(UInt8(track))
                }
                result(nil)
            }
        case "RtmpStream#screenAddChild":
            guard
                let child = arguments["child"] as? [String: Any?] else {
                result(nil)
                return
            }
            Task { @ScreenActor in
                let videoTrackScreenObject = VideoTrackScreenObject()
                if let track = child["track"] as? Int {
                    videoTrackScreenObject.track = UInt8(track)
                }
                if let isVisible = child["isVisible"] as? Bool {
                    videoTrackScreenObject.isVisible = isVisible
                }
                if let size = child["size"] as? [String: Any?],
                let width = size["width"] as? Double,
                let height = size["height"] as? Double {
                    videoTrackScreenObject.size = CGSize(width: width, height: height)
                }
                if let layoutMargin = child["layoutMargin"] as? [String: Any?],
                let left = layoutMargin["left"] as? Double,
                let top = layoutMargin["top"] as? Double,
                let right = layoutMargin["right"] as? Double,
                let bottom = layoutMargin["bottom"] as? Double {
                    videoTrackScreenObject.layoutMargin = NSEdgeInsets(top: top, left: left, bottom: bottom, right: right)
                }
                if let horizontalAlignment = child["horizontalAlignment"] as? String {
                    videoTrackScreenObject.horizontalAlignment = switch horizontalAlignment {
                        case "left": .left
                        case "center": .center
                        case "right": .right
                        default: .left
                    }
                }
                if let verticalAlignment = child["verticalAlignment"] as? String {
                    videoTrackScreenObject.verticalAlignment = switch verticalAlignment {
                        case "top": .top
                        case "middle": .middle
                        case "bottom": .bottom
                        default: .top
                    }
                }
                if let videoGravity = child["videoGravity"] as? String {
                    videoTrackScreenObject.videoGravity = switch videoGravity {
                        case "resize": .resize
                        case "resizeAspect": .resizeAspect
                        case "resizeAspectFill": .resizeAspectFill
                        default: .resize
                    }
                }
                addedVideoTrackScreenObjects.append(videoTrackScreenObject)
                try! await mixer.screen.addChild(videoTrackScreenObject)
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
