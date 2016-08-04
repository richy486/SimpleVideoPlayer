//
//  VideoView.swift
//  videoPlayer
//
//  Created by Richard Adem on 8/3/16.
//  Copyright © 2016 Richard Adem. All rights reserved.
//

import UIKit
import AVFoundation

public protocol VideoViewDataSource : class {
    func videoViewUrlString(_ videoView: VideoView) -> String?
}

public protocol VideoViewDelegate : class {
    func videoView(_ videoView:VideoView, timeDidChange time:CMTime)
    func videoViewVideoDidEnd(_ videoView:VideoView)
}

public class VideoView : UIView {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var timeObserverToken: AnyObject?
    
    let timeObserverInterval = 0.01
    
    var loop = true
    
    // Why doesn't this appear in interface builder
    weak public var dataSource:VideoViewDataSource?
    weak public var delegate:VideoViewDelegate?
    
    public var volume:Float = 1.0 {
        didSet {
            player?.volume = volume
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let playerLayer = playerLayer {
            playerLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height);
        }
    }
    
    // MARK: Notifications
    
    func playerItemDidReachEnd(_ notification: Notification) {
        delegate?.videoViewVideoDidEnd(self)
        if let playerItem = notification.object  where loop == true {
            playerItem.seek(to: kCMTimeZero)
        }
    }
    
    func willEnterForeground(_ notification: Notification) {
        if player != nil && player!.rate == 0 {
            player!.play()
        }
    }
    
    // MARK: Public controls
    
    func play() {
        if let urlString = dataSource?.videoViewUrlString(self) {
            
            let url:URL? = {
                if urlString.contains("http") {
                    if let u =  URL(string: urlString) {
                        return u
                    }
                } else {
                    
                    let pathExtention = URL(fileURLWithPath: urlString).pathExtension
                    let pathPrefix = NSURL(fileURLWithPath: urlString).deletingPathExtension?.lastPathComponent
                    
                    
                    if let u = Bundle.main().urlForResource(pathPrefix, withExtension: pathExtention) {
                        return u
                    }
                }
                
                return nil
            }()
            
            
            if let url = url {
                if player == nil || playerLayer == nil {
                    
                    
                    player = AVPlayer(url: url)
                    if let player = player {
                        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
                        
                        
                        
                        playerLayer = AVPlayerLayer(player: player)
                        if let playerLayer = playerLayer {
                            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                        }
                        
                        
                        
                        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: timeObserverInterval, preferredTimescale: Int32(NSEC_PER_SEC))
                            , queue: DispatchQueue.main
                            , using: { [weak self]  (time) in
                                self?.delegate?.videoView(self!, timeDidChange: time)
                            })
                        
                        
                    }
                } else {
                    //                let asset = AVAsset(URL: url)
                    
                    
                    let playItem = AVPlayerItem(url: url)
                    
                    player?.replaceCurrentItem(with: playItem)
                }
                
                
                
                if let player = player, let playerLayer = playerLayer {
                    
                    NotificationCenter.default().addObserver(self
                        , selector: #selector(playerItemDidReachEnd(_:))
                        , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime
                        , object: player.currentItem)
                    NotificationCenter.default().addObserver(self
                        , selector: #selector(willEnterForeground(_:))
                        , name: "ApplicationWillEnterForeground" as NSNotification.Name //GlobalNotification.ApplicationWillEnterForeground.rawValue
                        , object: nil)
                    
                    player.play()
                    
//                    let muteVideos = Tweaks.assign(Tweaks.video.debugging.mutevideo)
//                    if muteVideos {
//                        player.volume = 0
//                    }
                    layer.insertSublayer(playerLayer, at: 0)
                }
            } else {
                print("cannot play: \(urlString)")
            }
        }
    }
    
    func pause() {
        
        if let player = player {
            player.pause()
        }
        NotificationCenter.default().removeObserver(self)
    }
    
    // MARK: Memory management
    
    deinit {
        NotificationCenter.default().removeObserver(self)
    }
}

