//
//  ProfileViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-02.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit
import KDCircularProgress
import ZFRippleButton
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var minusButton: ZFRippleButton!
    @IBOutlet weak var plusButton: ZFRippleButton!
    var progress: KDCircularProgress!
    var waterTarget = 0
    var waterCupSize = 35
    var currentWater = 0
    var currentAngle = 0.0
    func setupPlusButton() {
        plusButton.rippleOverBounds = true
        plusButton.buttonCornerRadius = 12.0
        plusButton.clipsToBounds = true
        plusButton.backgroundColor = .black
        plusButton.shadowRippleEnable = true
    }
    
    func setupMinusButton() {
        minusButton.rippleOverBounds = true
        minusButton.buttonCornerRadius = 12.0
        minusButton.clipsToBounds = true
        minusButton.backgroundColor = .black
        minusButton.shadowRippleEnable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupPlusButton()
        setupMinusButton()
    }
    
    func setupProgress() {
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        progress.startAngle = -90
        progress.progressThickness = 0.6
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(.blue)
        progress.center = CGPoint(x: view.center.x, y: view.center.y - 25)
        view.addSubview(progress)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgress()
        let ref = FIRDatabase.database().reference()
        let defaults = UserDefaults.standard
        let uuid = defaults.string(forKey: "identifier")
        let childRefWaterIntake = ref.child(uuid!).child("water")
        childRefWaterIntake.observe(.value, with: { (snapshot) in
            let waterString = snapshot.value as! String
            self.waterTarget = Int(waterString)!
            print("waterTarget is : \(self.waterTarget)")
        })
    }

    @IBAction func plusButtonTapped(_ sender: ZFRippleButton) {
        progress.clockwise = true
        currentWater += waterCupSize
        let ratio: Double = Double(currentWater) / Double(waterTarget)
        let toAngle: Double = ratio * 360.0
        print("Current angle in plus: \(currentAngle)")
        print("To angle in plus: \(toAngle)")
        progress.animate(currentAngle, toAngle: toAngle, duration: 0.5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        currentAngle = toAngle
    }

    @IBAction func minusButtonTapped(_ sender: ZFRippleButton) {
        currentWater = max(currentWater - waterCupSize, 0)
        let ratio: Double = Double(currentWater) / Double(waterTarget)
        let toAngle: Double = ratio * 360.0
        print("Current angle in minus: \(currentAngle)")
        print("To angle in minus: \(toAngle)")
        progress.animate(currentAngle, toAngle: toAngle, duration: 0.5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        currentAngle = toAngle
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}