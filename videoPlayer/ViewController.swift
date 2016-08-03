//
//  ViewController.swift
//  videoPlayer
//
//  Created by Richard Adem on 8/3/16.
//  Copyright © 2016 Richard Adem. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, VideoViewDataSource, VideoViewDelegate {

    @IBOutlet weak var videoView: VideoView? {
        didSet {
            if let videoView = videoView{
                videoView.dataSource = self
                videoView.delegate = self
            }
        }
    }
    
    // MARK: View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        videoView?.play()
    }

    // MARK: Video view data source
    func videoViewUrlString(_ videoView: VideoView) -> String? {
        return "video.mp4"
    }
    
    // MARK: Video view delegate
    
    func videoView(_ videoView:VideoView, timeDidChange time:CMTime) {
    }
    func videoViewVideoDidEnd(_ videoView:VideoView) {
    }
    
    // MARK: Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

