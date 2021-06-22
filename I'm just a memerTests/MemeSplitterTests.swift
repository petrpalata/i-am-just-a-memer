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
        let testMemes = generateMemesByHeight([1, 1, 2])
        
        let result = sut.splitMemesBasedOnHeight(testMemes)

        XCTAssertTrue(checkArraySplitValidity(result, desiredHeights: (2, 2)))
    }
    
    func test_splitMemesBasedOnHeight_manyShortMemesOneTallMeme_returnCorrectlySplitArray() {
        let testMemes = generateMemesByHeight([8, 1, 1, 1, 1, 1, 1, 1, 1])
        
        let result = sut.splitMemesBasedOnHeight(testMemes)
        
        XCTAssertTrue(checkArraySplitValidity(result, desiredHeights: (8, 8)))
    }
    
    func test_splitMemesBasedOnHeight_oddSizes_returnCorrectlySplitArray() {
        let testMemes = generateMemesByHeight([8, 1, 1, 1, 1, 1, 1, 1])
                
        let result = sut.splitMemesBasedOnHeight(testMemes)
         
        XCTAssertTrue(checkArraySplitValidity(result, desiredHeights: (8, 7)))
    }
    
    func test_splitMemesBasedOnHeight_columnWidthZero_returnCorrectlySplitArray() {
        let testMemes = generateMemesByHeight([8, 1, 1, 1, 1, 1, 1, 1])
        
        let result = sut.splitMemesBasedOnHeight(testMemes, columnWidth: 0)
 
        XCTAssertTrue(checkArraySplitValidity(result, desiredHeights: (8, 7)))
    }
    
    func test_splitMemesBasedOnHeight_columnWidthLessThanZero_returnCorrectlySplitArray() {
        let testMemes = generateMemesByHeight([8, 1, 1, 1, 1, 1, 1, 1])
        
        let result = sut.splitMemesBasedOnHeight(testMemes, columnWidth: -1)
        
        XCTAssertTrue(checkArraySplitValidity(result, desiredHeights: (8, 7)))
    }
    
    
    func test_splitMemesBasedOnHeight_columnWidthNonZero_returnCorrectlySplitArray() {
        let testMemes = generateMemesByHeight(
            [50, 50, 50, 50, 50],
            widths: [50, 1, 1, 1, 1]
        )
        let result = sut.splitMemesBasedOnHeight(testMemes, columnWidth: 1)
        
        XCTAssertTrue(checkArraySplitValidity(result, desiredHeights: (101, 100)))
    }
    
    private func generateMemesByHeight(_ heights: [CGFloat], widths: [CGFloat]? = nil) -> [Meme] {
        let widths = widths ?? heights.map({ _ in return 0 })
        return zip(heights, widths).map { height, width in
            var meme = generateMeme()
            meme.width = width
            meme.height = height
            return meme
        }
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
        _ memeArrays: (leftArray: [Meme], rightArray: [Meme]),
        desiredHeights: (firstHeight: CGFloat, secondHeight: CGFloat)) -> Bool {
        
        let leftHeight = memeArrays.leftArray.height()
        let rightHeight = memeArrays.rightArray.height()
        return (leftHeight.isEqual(to: desiredHeights.firstHeight) && rightHeight.isEqual(to: desiredHeights.secondHeight)) || (leftHeight.isEqual(to: desiredHeights.secondHeight) && rightHeight.isEqual(to: desiredHeights.firstHeight))
    }
}
