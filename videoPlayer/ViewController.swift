//
//  ViewController.swift
//  videoPlayer
//
//  Created by Richard Adem on 8/3/16.
//  Copyright © 2016 Richard Adem. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class ViewController: UIViewController, VideoViewDataSource, VideoViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pickViewButton: UIButton!
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
        
//        videoView?.play()
    }
    
//    - (NSUInteger) supportedInterfaceOrientations
//    {
//    //Because your app is only landscape, your view controller for the view in your
//    // popover needs to support only landscape
//    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//    }
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return .landscape
//    }
    
    // MARK: Actions
    
    @IBAction func touchUpIn_pickVideoButton(_ sender: AnyObject) {
        
//        let status = AssetsLibrary.status  //[ALAssetsLibrary authorizationStatus];
        
//        if status != ALAuthorizationStatusAuthorized {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Please give this app permission to access your photo library in your settings app!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
//            [alert show];
//        } else {
//            pickVideo()
//        }
        
//        let status = PHPhotoLibrary.authorizationStatus()
//        if status != .authorized {
//            print("not authorized")
//        } else {
//            pickVideo()
//        }
        
        pickVideo()
        
    }
    
    // MARK: Picker
    
    func pickVideo() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .formSheet
        
        
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        
//        imagePicker.popoverPresentationController?.sourceView = pickViewButton
//        imagePicker.mediaTypes = [kUTTypeMovie]
        
//        popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
//        [popover presentPopoverFromRect:CGRectMake(0.0, 0.0, 400.0, 400.0)
//            inView:self.view
//            permittedArrowDirections:UIPopoverArrowDirectionAny
//            animated:YES];
        
//        let popover = UIPopoverController(contentViewController: imagePicker)
//        popover .present(from: pickViewButton.frame, in: view, permittedArrowDirections: .any, animated: true)
        
        present(imagePicker, animated: true, completion: nil)
        if let popController = imagePicker.popoverPresentationController {
            popController.permittedArrowDirections = .any
    //        popController.barButtonItem = self.leftButton;
    //        popController.delegate = self;
            
            // in case we don't have a bar button as reference
            popController.sourceView = pickViewButton
            popController.sourceRect = CGRect(x: 0, y: 0, width: 400, height: 400) //  pickViewButton.frame
            
            
        }
        
        
        
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
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.contentMode = .ScaleAspectFit
//            imageView.image = pickedImage
//        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Memory management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

