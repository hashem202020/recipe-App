//
//  Extensions.swift
//  iosTask
//
//  Created by hashem on 06/08/2021.
//

import UIKit
import Kingfisher

fileprivate var aView: UIView?

//MARK:- KINGFISHER ex
extension UIImageView{
    /// this function loads the image from url udimg kingfiher pod
    /// - Parameter url: the image url to convret to image
  func loadImage(_ url : URL?) {
    self.kf.setImage(
      with: url,
      options: [
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(1)),
        .cacheOriginalImage
      ])
    self.kf.indicatorType = .activity
  }
}


//MARK:- uiviewcontroller ex
extension UIViewController{
    
    /// this function showing spinner using built in indicator
    func showSpinner(){
         aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        aView?.tag = 100
        
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    
    /// this function removing the spinner from the view
    func removeSpinner(){
        if let removeView = self.view.viewWithTag(100){
            removeView.removeFromSuperview()
//        aView = nil
        
        }
    }
 
    /// this function creates a warning with an (ok) button
    /// - Parameter message: the warning Body
    func createWarning(message: String){
        let alert  = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- String ex
extension String {
    /// this function check on the string if it english letters or not using regular expression
    /// - Returns: true if english letters false if any thing else
    func isEnglish() -> Bool {
        guard  self.count > 0  else {return false}
        let englishLetters: Set<Character> = ["a", "b" , "c" , "d" , "e" , "f", "g" , "h" , "i" , "j" , "k", "l", "m" , "n" , "o" , "p" , "q", "r", "s" , "t" , "u" , "v" , "w" , "x" , "y" , "z" , " " ]
        return Set(self.lowercased()).isSubset(of: englishLetters)
    }
}


