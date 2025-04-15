//
//  SoundPlayer.swift
//  Today
//
//  Created by Smruti Bachhav on 10/04/25.
//

import AVFoundation

class SoundPlayer {
    private var player: AVAudioPlayer?

    func playSound(named name: String, fileExtension: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("⚠️ Sound file '\(name).\(fileExtension)' not found in bundle.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("⚠️ Failed to play sound: \(error.localizedDescription)")
        }
    }
}

