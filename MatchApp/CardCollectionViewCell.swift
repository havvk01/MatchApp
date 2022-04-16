//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Slava Havvk on 28.01.2022.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        
        self.card = card
        
        // Set the front image view to the image that represents the card
        frontImageView.image = UIImage(named: card.imageName)
        
        // Reset the state of the cell by checking the flipped ststus of the card and then showing the front or the back imageview accordingly
        
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
        }
        
        else {
            
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        if card.isFlipped == true {
            // Show the front image view
            flipUp(speed: 0)
        }
        
        else {
            // Show the back image view
            flipDown(speed: 0, delay: 0)
        }
        
    }
    
    func flipUp(speed:TimeInterval = 0.3) {
        
        // Flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        // Set the status of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            // Flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
            
        }
        
        // Set the status of the card
        card?.isFlipped = false
        
    }
    
    func remove() {
        
        // Make the image view invisible
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
    
}
