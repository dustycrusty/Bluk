//
//  LaunchViewController.swift
//  Bluk
//
//  Created by 이승윤 on 17/06/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import UIKit
import Firebase

class LaunchViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var heightCon: NSLayoutConstraint!
    
    var success:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeColor()
        // Do any additional setup after loading the view.
    }
    
    func changeColor(){
       
        logo.image = logo.image?.withRenderingMode(.alwaysTemplate)
        
        let dg = DispatchGroup()
        dg.enter()
        UIView.animate(withDuration: 1) {
            self.heightCon.constant = self.view.frame.size.height
            self.logo.tintColor = .white
            self.background.layoutIfNeeded()
            dg.leave()
        }
        
        dg.enter()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously() { (authResult, error) in
                if (authResult == nil) && (error != nil){
                   self.success = false
                    self.showAlertView()
                    dg.leave()
                }
                else{
                    self.success = true
                    dg.leave()
                }
            }
        } else {
            success = true
            dg.leave()
        }
       
        dg.notify(queue: .main) {
            if self.success == true{
                self.performSegue(withIdentifier: "toMain", sender: self)
            }
        }
        
    }
    
    func showAlertView(){
        let alert = UIAlertController(title: "Error has Occured", message: "Please check your internet connection and reopen Blutin.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive)
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination
        if segue.identifier == "toMain"{
            nextVC.hero.isEnabled = true
            nextVC.hero.modalAnimationType = .zoomSlide(direction: .left)
        }
    }
    

}
