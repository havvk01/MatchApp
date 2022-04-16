//
//  ViewController.swift
//  MatchApp
//
//  Created by Slava Havvk on 28.01.2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var CollectionView: UICollectionView!

    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliseconds: Int = 60 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsArray = model.getCards()
        
        // Set the view controller as the datasource and delegate of the collection view
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        // Initilize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reaches zero
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // Check if the user has cleared all the pairs
            checkForGameEnd()
        }
        
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        print("Cell is tapped \(indexPath.row)")
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        // Return it
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        // Finish configuring the cell
        cardCell?.configureCell(card: card)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Cell is tapped: \(indexPath.row)")
        
        // Check if there's any time remaining. Dont't let the user interact if the time is 0
        if milliseconds <= 0 {
            return 
        }
        
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card

        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            // Flip the card up
            cell?.flipUp()
            
            // Play flip sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if this is the first card that was flipped or the second card
            if firstFlippedCardIndex == nil {
                
                // This is the first card flipped over
                
                firstFlippedCardIndex = indexPath
            }
            
            else {
                
                // Second card that is flipped
                
                // Run the comparison logic
                checkForMatch(indexPath)
            }
            
        }
        
//        else {
//            // Flip the card down
//            cell?.flipDown()
//        }
        

    }

    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent card one and two
        let cardOneCell = CollectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = CollectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare the two cards
        
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            
            // Play sound
            soundPlayer.playSound(effect: .match)
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Was the last pair?
            checkForGameEnd()
            
        }
        
        else {
            // It's not a match
            
            // Play sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            // Flip them back over
            
            
            cardOneCell?.flipDown(speed: 0.9)
            cardTwoCell?.flipDown(speed: 0.9)
            
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
        
    }
    
    func checkForGameEnd() {
        
        // Check if there's any card that is unmatched
        // Assume the user has won, loop through all the cards to see if all of them are matched
        var hasWon = true
        for card in cardsArray {
            
            if card.isMatched == false {
                // We' ve found a card that is ummatched
                hasWon = false
                break
            }
        }
        
        if hasWon  == true {
            
            // User has won, show an alert
            timerLabel.textColor = UIColor.green
            timer?.invalidate()
            showAlert(title: "Congratulations!", message: "You.ve won the game!")
 
        }
        
        else {
            // User hasn't won yet, check if there's any time left
            if milliseconds <= 0 {
                showAlert(title: "Time's up", message: "Sorry, better luck next time!")
            }
        }
    }
    
    func showAlert(title:String, message: String) {
        
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button for the user to dismiss it
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        // Show the alert
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

