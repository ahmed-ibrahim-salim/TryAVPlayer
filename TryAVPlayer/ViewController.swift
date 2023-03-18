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

    
    let label = {
        let label = ExpandableLabel()
        label.fullText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla lacinia accumsan felis ac bibendum. Nunc dapibus magna vitae velit laoreet, vel tristique est posuere. Aliquam porta eget purus vel commodo. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        label.numberOfLines = 3
        label.maxHeight = label.font.lineHeight * 3
        
        label.readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
        label.readmoreFontColor = UIColor.blue        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        makePlayer()
        
//        playVideo()

        makeExpandedLblAndSeeMoreAndAssignTabGesture()
        
        
    }
    
    @objc func moreButtonTapped() {
        label.toggleExpansion()
    }
    
    func makeExpandedLblAndSeeMoreAndAssignTabGesture(){
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moreButtonTapped))
        label.addGestureRecognizer(tapGesture)
        
        view.addSubview(label)
        
        label.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            
        })
        
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



extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "T##String")
    }
}

class ExpandableLabel: UILabel {

    var isExpanded: Bool = false
    var maxHeight: CGFloat = 0
    
    var readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
    var readmoreFontColor = UIColor.blue

    var fullText: String?{
        didSet{
            if fullText!.count >= truncatedLength{

                text = fullText
                
                DispatchQueue.main.async {
                    self.addTrailing(with: "... ", moreText: "Readmore", moreTextFont: self.readmoreFont!, moreTextColor: self.readmoreFontColor)
                }
            }
        }
    }
    private var truncatedLength = 100
    private var isTruncated = true

    private func collapse(){
        
        DispatchQueue.main.async {
            self.addTrailing(with: "... ", moreText: "Read more", moreTextFont: self.readmoreFont!, moreTextColor: self.readmoreFontColor)
        }
        isTruncated = true
    }

    private func expand(){
        // just do not delete these lines
        let index = fullText!.index(fullText!.startIndex, offsetBy: (fullText!.count - 1))
        self.text = fullText![...index].description + " Read less".localized
        
        DispatchQueue.main.async {
            self.addTrailing(with: "", moreText: "Read less", moreTextFont: self.readmoreFont!, moreTextColor: self.readmoreFontColor)
        }
        isTruncated = false
    }
        
    func toggleExpansion() {
        isExpanded = !isExpanded
        print("should expand",isExpanded)
        
        if isExpanded {
            self.numberOfLines = 0
            self.frame.size.height = self.intrinsicContentSize.height
            
            expand()
            
        } else {
            self.numberOfLines = 3
            self.frame.size.height = min(self.intrinsicContentSize.height, maxHeight)
            collapse()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}


extension UILabel{
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
