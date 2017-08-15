//
//  RecordSoundViewController.swift
//  secondApp
//
//  Created by navarrocantero on 6/8/17.
//  Copyright (c) 2017 ___driftinapp___. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {


    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var labelEdit: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder: AVAudioRecorder!


    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.imageView?.contentMode = .scaleAspectFit
        recordButton.imageView?.contentMode = .scaleAspectFit
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        stopButton.isEnabled = false
        print("view will appear")
    }

    @IBAction func changeAction(_ sender: Any) {

        labelEdit.text = "recording"
        stopButton.isEnabled = true
        recordButton.isEnabled = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            print("listo")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)

        } else {
            print("failed!!")
        }
    }


    @IBAction func stopRecord(_ sender: Any) {
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        labelEdit.text = "tap to record"
        audioRecorder.stop()

        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}






