//
//  MemeSplitterTests.swift
//  I'm just a memerTests
//
//  Created by Petr Palata on 19.06.2021.
//

import XCTest
@testable import I_m_just_a_memer

class MemeSplitterTests: XCTestCase {
    let sut = MemeSplitter()
    
    func test_splitMemesBasedOnHeight_emptyArray_returnsTwoEmptyArrays() throws {
        let result = sut.splitMemesBasedOnHeight([])
        
        XCTAssertEqual(Mirror(reflecting: result).children.count, 2)
        
        let array1 = result.0
        let array2 = result.1
        
        XCTAssertEqual(array1.count, 0)
        XCTAssertEqual(array2.count, 0)
    }
    
    func test_splitMemesBasedOnHeight_arrayWithOneElement_returnsOneElementAndEmptyArray() throws {
        let result = sut.splitMemesBasedOnHeight([generateMeme()])
        
        let leftArray = result.0
        let rightArray = result.1
        
        XCTAssertEqual(leftArray.count, 1)
        XCTAssertEqual(rightArray.count, 0)
    }
    
    func test_splitMemesBasedOnHeight_arrayWithTwoElements_returnsTwoArraysWithOneElemenEach() throws {
        
        let result = sut.splitMemesBasedOnHeight([generateMeme(), generateMeme()])
        
        let leftArray = result.0
        let rightArray = result.1
        
        XCTAssertEqual(leftArray.count, 1)
        XCTAssertEqual(rightArray.count, 1)
    }
    
    func test_splitMemesBasedOnHeight_memeHeight2And2MemesHeight1_returnsCorrectlySplitArrays() throws {
        
        var memeWithHeight1 = generateMeme()
        memeWithHeight1.height = 1
        var memeWithHeight2 = generateMeme()
        memeWithHeight2.height = 2
        
        let result = sut.splitMemesBasedOnHeight([
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight2
        ])
        
        let leftArray = result.0
        let rightArray = result.1
        
        XCTAssertTrue(checkArraySplitValidity(
            leftArray,
            rightArray: rightArray,
            desiredHeights: (2, 2))
        )
    }
    
    func test_splitMemesBasedOnHeight_manyShortMemesOneTallMeme_returnCorrectlySplitArray() {
        var memeWithHeight1 = generateMeme()
        memeWithHeight1.height = 1
        var memeWithHeight8 = generateMeme()
        memeWithHeight8.height = 8
        
        let result = sut.splitMemesBasedOnHeight([
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight8
        ])
        
        let leftArray = result.0
        let rightArray = result.1
        
        XCTAssertTrue(checkArraySplitValidity(
            leftArray,
            rightArray: rightArray,
            desiredHeights: (8, 8))
        )
    }
    
    func test_splitMemesBasedOnHeight_oddSizes_returnCorrectlySplitArray() {
        var memeWithHeight1 = generateMeme()
        memeWithHeight1.height = 1
        var memeWithHeight8 = generateMeme()
        memeWithHeight8.height = 8
        
        let result = sut.splitMemesBasedOnHeight([
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight1,
            memeWithHeight8
        ])
        
        let leftArray = result.0
        let rightArray = result.1
        
        XCTAssertTrue(checkArraySplitValidity(
            leftArray,
            rightArray: rightArray,
            desiredHeights: (8, 7))
        )
    }
    
    private func generateMeme() -> Meme {
        return Meme(
            backendId: "",
            name: "Test Meme",
            width: 0,
            height: 0,
            boxCount: 0
        )
    }
    
    private func checkArraySplitValidity(
        _ leftArray: [Meme],
        rightArray: [Meme],
        desiredHeights: (firstHeight: CGFloat, secondHeight: CGFloat)) -> Bool {
        
        let leftHeight = leftArray.height()
        let rightHeight = rightArray.height()
        return (leftHeight.isEqual(to: desiredHeights.firstHeight) && rightHeight.isEqual(to: desiredHeights.secondHeight)) || (leftArray.height().isEqual(to: desiredHeights.secondHeight) && rightArray.height().isEqual(to: desiredHeights.firstHeight))
    }
}
