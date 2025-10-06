//
//  AudioManager.swift
//  Taptical - Sarah
//
//  Created by Jana Abdulaziz Malibari on 06/10/2025.
//

import SwiftUI
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?
    
    // Persist mute state across views and sessions
    @AppStorage("isMuted") private var Sound: Bool = false
    
    private init() {
        setupNotifications()
    }

    func playBackgroundMusic() {
        print("🔈 Attempting to play background music...")

        guard let url = Bundle.main.url(forResource: "Taptical_SoundTrack", withExtension: "mp3") else {
            print("🚫 ERROR: Audio file not found in bundle.")
            return
        }

        print("✅ Audio file found at: \(url)")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session activated.")

            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 0.5
            player?.prepareToPlay()
            player?.play()
            print("🎵 Music should now be playing.")
        } catch {
            print("🚫 ERROR: \(error.localizedDescription)")
        }
    }
    
    var isPlaying: Bool {
        player?.isPlaying ?? false
    }

    func stopBackgroundMusic() {
        player?.stop()
    }

    func pauseBackgroundMusic() {
        player?.pause()
    }

    func resumeBackgroundMusic() {
        player?.play()
    }

    func setVolume(to value: Float) {
        player?.volume = value
    }
    
    // MARK: - App Lifecycle Observers
       private func setupNotifications() {
           NotificationCenter.default.addObserver(
               self,
               selector: #selector(appDidEnterBackground),
               name: UIApplication.didEnterBackgroundNotification,
               object: nil
           )

           NotificationCenter.default.addObserver(
               self,
               selector: #selector(appDidBecomeActive),
               name: UIApplication.didBecomeActiveNotification,
               object: nil
           )
       }

       @objc private func appDidEnterBackground() {
           pauseBackgroundMusic()
       }

       @objc private func appDidBecomeActive() {
           resumeBackgroundMusic()
       }
   }
