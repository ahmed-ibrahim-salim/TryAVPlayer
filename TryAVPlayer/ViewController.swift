//
//  ViewController.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 05/03/2023.
//

import UIKit
import SnapKit
import AVFoundation
// https://medium.com/@tarasuzy00/build-video-player-in-ios-i-avplayer-43cd1060dbdc

class PlayerView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("no implemented")
    }
    
    // change the view’s layer
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    // gets this view layer
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // get player from the defined layer
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    
    private var playerItemContext = 0

    // Keep the reference and use it to observe the loading status.
    private var playerItem: AVPlayerItem?
    
    /*
    The needed steps for setting up a player are summarized as below:

    Initialized an AVAsset with an URL.
    Load AVAsset asynchronously and wait for the loaded status.
    If AVAsset is loaded, initialized an AVPlayerItem with the loaded AVAsset.
    Add observer for the AVPlayerItem. Ask the player to play if getting readyToPlay status.
     */
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        print("deinit of PlayerView")
    }
    
    func play(with url: URL) {
        setUpAsset(with: url) {
            [weak self] asset in
            self?.setUpPlayerItem(with: asset)
        }
    }
    
    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?){
        let asset = AVAsset(url: url)
        
        asset.loadValuesAsynchronously(forKeys: ["playable"]){
            var error: NSError? = nil
            
            let status =  asset.statusOfValue(forKey: "playable", error: &error)
            // result
            switch status {
            case .loaded:
                completion?(asset)
            case .failed:
                print(".failed")
            case .cancelled:
                print(".cancelled")
            default:
                print("default")
            }
        }
        
    }
    
    private func setUpPlayerItem(with asset: AVAsset){
        playerItem = AVPlayerItem(asset: asset)
        
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
        }
    }
    
    // observe value of this class
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over playerItem status value
            switch status {
            case .readyToPlay:
                print("playerItem status .readyToPlay")
                player?.play()
            case .failed:
                print("playerItem status .failed")
            case .unknown:
                print("playerItem status .unknown")
            @unknown default:
                print("playerItem status @unknown default")
            }
        }
    }
}

class ViewController: UIViewController {

    private var playerView: PlayerView!
        
    // URL for the test video.
    private let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

    override func viewDidLoad() {
        super.viewDidLoad()
        makePlayer()
        
        playVideo()
        
//        let env = Environment()
        

    }

    func makePlayer(){
        
        playerView = PlayerView()
        playerView.layer.borderColor = UIColor.red.cgColor
        playerView.layer.borderWidth = 2
        
        view.addSubview(playerView)
        
        playerView.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(250)
        })
    }
    
    // controller
    func playVideo() {
        guard let url = URL(string: videoURL) else { return }
        playerView.play(with: url)
    }
}

