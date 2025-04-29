//
//  LoopingVideoPlayer.swift
//  Nobla Math
//
//  Created by Sebastian Strus on 2025-04-29.
//


import SwiftUI
import AVKit

struct LoopingVideoPlayer: View {
    let videoName: String
    let videoType: String
    
    var body: some View {
        #if os(iOS)
        iOSVideoPlayer(videoName: videoName, videoType: videoType)
        #elseif os(macOS)
        macOSVideoPlayer(videoName: videoName, videoType: videoType)
        #endif
    }
}

#if os(iOS)
struct iOSVideoPlayer: UIViewRepresentable {
    let videoName: String
    let videoType: String
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoName: videoName, videoType: videoType)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed
    }
}

class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    init(videoName: String, videoType: String) {
        super.init(frame: .zero)
        setupPlayer(videoName: videoName, videoType: videoType)
        
        // iOS-specific notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restartVideo),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupPlayer(videoName: String, videoType: String) {
        guard let videoURL = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
            print("Could not find video \(videoName).\(videoType)")
            return
        }
        
        let playerItem = AVPlayerItem(url: videoURL)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        queuePlayer.play()
    }
    
    @objc private func restartVideo() {
        playerLayer.player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
#endif

#if os(macOS)
struct macOSVideoPlayer: NSViewRepresentable {
    let videoName: String
    let videoType: String
    
    func makeNSView(context: Context) -> NSView {
        return PlayerNSView(videoName: videoName, videoType: videoType)
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // No updates needed
    }
}

class PlayerNSView: NSView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    init(videoName: String, videoType: String) {
        super.init(frame: .zero)
        setupPlayer(videoName: videoName, videoType: videoType)
        
        // macOS-specific notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restartVideo),
            name: NSApplication.willBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restartVideo),
            name: NSWindow.didBecomeKeyNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupPlayer(videoName: String, videoType: String) {
        guard let videoURL = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
            print("Could not find video \(videoName).\(videoType)")
            return
        }
        
        let playerItem = AVPlayerItem(url: videoURL)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspectFill
        wantsLayer = true
        layer?.addSublayer(playerLayer)
        
        queuePlayer.play()
    }
    
    @objc private func restartVideo() {
        playerLayer.player?.play()
    }
    
    override func layout() {
        super.layout()
        playerLayer.frame = bounds
    }
}
#endif
