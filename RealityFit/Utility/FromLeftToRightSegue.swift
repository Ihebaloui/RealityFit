//
//  FromLeftToRightSegue.swift
//  RealityFit
//
//  Created by Apple Esprit on 17/12/2021.
//

import Foundation
class FromLeftToRightSegue: UIStoryboardSegue {
    override func perform() {

        let firstVC = self.sourceViewController.view as UIView!
        let secondVC = self.destinationViewController.view as UIView!

        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height


        secondVC.frame = CGRectMake(-screenWidth, 0, screenWidth, screenHeight)

        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVC, aboveSubview: firstVC)

        // Animate the transition.
        UIView.animateWithDuration(0.3, animations: { () -> Void in // set animation duration

            firstVC.frame = CGRectOffset(firstVC.frame, 0.0, 0.0) // old screen stay

            secondVC.frame = CGRectOffset(secondVC.frame, screenWidth, 0.0) // new screen strave from left to right

        }) { (Finished) -> Void in
            self.sourceViewController.presentViewController(self.destinationViewController as UIViewController,
                                                            animated: false,
                                                            completion: nil)
        }
    }

}
