//
//  CardModel.swift
//  MatchApp
//
//  Created by Slava Havvk on 28.01.2022.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare a empty array
        var generatedCards = [Card]()
        var finalCards = [Int]()
        
        // randomly generate 8 pairs of cards
        while finalCards.count < 8 {
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            if finalCards.contains(randomNumber) != true {
                
                // Create two new cards objects
                
                let cardOne = Card()
                let cardTwo = Card()
                
                // Set their image names
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                // Add them to the array
                
                generatedCards += [cardOne, cardTwo]
                
                finalCards.append(randomNumber)
                
                print("generated number is \(randomNumber)")
            }
        }
        // Randomize the cards within the array
        
        print("count of array \(generatedCards.count)")
        generatedCards.shuffle()
        
        // Return the array
//        print(generatedCards.count)
        
        return generatedCards
        
        
    }
    
    
}
