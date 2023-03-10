//
//  Adapter.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 08/03/2023.
//

import Foundation
// https://www.tutorialspoint.com/design_pattern/adapter_pattern.htm

// Adapter & Strategy pattern
protocol AdvancedMediaPlayer {
    func play(_ fileName: String)
}

class VlcPlayer: AdvancedMediaPlayer{
    func play(_ fileName: String) {print("Playing vlc file. Name: ", fileName)}
}

class Mp4Player: AdvancedMediaPlayer{
    func play(_ fileName: String) {print("Playing mp4 file. Name: ", fileName)}
}

enum AudioType{
    case vlc
    case mp4
    case mp3
}

protocol MediaPlayer {
    func play(_ audioType: AudioType, _ fileName: String)
}

// The Adapter class knows how to do things with different classes
class MediaPlayerAdapter: MediaPlayer {
    
    private var advancedMusicPlayer: AdvancedMediaPlayer?
    
    init(_ audioType: AudioType){
        
        switch audioType{
        case .vlc:
            advancedMusicPlayer = VlcPlayer()
        case .mp4:
            advancedMusicPlayer = Mp4Player()
        default:
            break
        }
    }
    
    func play(_ audioType: AudioType, _ fileName: String){
        advancedMusicPlayer?.play(fileName)
    }
}

// AudioPlayer -> MediaPlayerAdapter -> AdvancedMediaPlayer

// media player now can use advanced player through the MediaPlayerAdapter
class AudioPlayer: MediaPlayer {
    
    private var mediaAdapter: MediaPlayerAdapter?

    func play(_ audioType: AudioType, _ fileName: String){
        
        switch audioType{
        case .vlc, .mp4:
            // mediaAdapter is providing support to play other file formats
            mediaAdapter = MediaPlayerAdapter(audioType)
            mediaAdapter?.play(audioType, fileName)
            
        case .mp3:
            // inbuilt support to play mp3 music files
            print("Playing mp3 file. Name: " + fileName)
        }
   }
}
