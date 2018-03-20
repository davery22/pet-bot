//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Daniel Avery on 2/24/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    //MARK: Meal class tests
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", rating: 0, photo: nil)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Highest positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", rating: 5, photo: nil)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    func testMealInitFails() {
        // Negative rating
        let negativeRatingMeal = Meal.init(name: "Negative", rating: -1, photo: nil)
        XCTAssertNil(negativeRatingMeal)
        
        // Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", rating: 6, photo: nil)
        XCTAssertNil(largeRatingMeal)
        
        // Empty String
        let emptyStringMeal = Meal.init(name: "", rating: 0, photo: nil)
        XCTAssertNil(emptyStringMeal)
    }
    
}
