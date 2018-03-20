//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Daniel Avery on 2/26/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate rating of selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // Reset if current rating is selected
            rating = 0
        }
        else {
            rating = selectedRating
        }
    }
    
    //MARK: Private methods
    private func setupButtons() {
        // Clear out existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load button images
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            // Create a button
            let button = UIButton()
            
            // Set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup button action
            button.addTarget(
                self,
                action: #selector(RatingControl.ratingButtonTapped(button:)),
                for: .touchUpInside)
            
            // Add button to stack
            addArrangedSubview(button)
            
            // Add button to array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }

    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            
            // Set hint string for currently selected star
            let hint: String?
            if rating == index + 1 {
                hint = "Tap to reset the rating to zero."
            }
            else {
                hint = nil
            }
            
            // Set value string
            let value: String
            switch (rating) {
            case 0:
                value = "No rating set."
            case 1:
                value = "1 star set."
            default:
                value = "\(rating) stars set."
            }
            
            button.accessibilityHint = hint
            button.accessibilityValue = value
        }
    }
}
