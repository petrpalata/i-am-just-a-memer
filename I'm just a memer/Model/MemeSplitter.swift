//
//  MemeSplitter.swift
//  I'm just a memer
//
//  Created by Petr Palata on 19.06.2021.
//

import Foundation
import UIKit

class MemeSplitter {
    typealias MemeColumns = ([Meme], [Meme])
    
    func splitMemesBasedOnHeight(_ memes: [Meme]) -> MemeColumns {
        let (leftArray, rightArray) = splitToEvenAndOddIndices(memes)
        return balanceArraysByMemeHeight(leftArray, rightArray: rightArray)
    }
    
    private func splitToEvenAndOddIndices(_ memes: [Meme]) -> MemeColumns {
        var leftArray: [Meme] = []
        var rightArray: [Meme] = []
        
        memes.enumerated().forEach {
            let meme = $0.element
            if $0.offset % 2 == 0 {
                leftArray.append(meme)
            } else {
                rightArray.append(meme)
            }
        }
        
        return (leftArray, rightArray)
    }
    
    private func balanceArraysByMemeHeight(_ leftArray: [Meme], rightArray: [Meme]) -> MemeColumns {
        var leftArray = leftArray
        var rightArray = rightArray
        
        var prevDistance: CGFloat = 0
        var currentDistance: CGFloat = 0
        
        repeat {
            let leftHeight = leftArray.height()
            let rightHeight = rightArray.height()
            
            let heightDistance = abs(leftHeight - rightHeight) / 2
            if leftHeight < rightHeight {
                guard let rightMemeIndex = rightArray.closestToHeight(heightDistance) else {
                    return (leftArray, rightArray)
                }
                let rightMeme = rightArray.remove(at: rightMemeIndex)
                leftArray.append(rightMeme)
            } else {
                guard let leftMemeIndex = leftArray.closestToHeight(heightDistance) else {
                    return (leftArray, rightArray)
                }
                let leftMeme = leftArray.remove(at: leftMemeIndex)
                rightArray.append(leftMeme)
            }
            
            prevDistance = currentDistance
            currentDistance = heightDistance
        } while(abs(prevDistance - currentDistance) > 0.5)
        
        return (leftArray, rightArray)
    }
}

extension Array where Element == Meme {
    func closestToHeight(_ height: CGFloat) -> Int? {
        let enumeratedElement: (offset: Int, element: Meme)? = nil
        return self
            .enumerated()
            .reduce(into: enumeratedElement) { partialResult, enumeratedMeme in
                let closestHeight = partialResult?.element.height ?? 0
                let currentHeight = enumeratedMeme.element.height
                
                let closestHeightDistance = abs(closestHeight - height)
                let currentHeightDistance = abs(currentHeight - height)
                
                if closestHeightDistance > currentHeightDistance {
                    partialResult = (
                        offset: enumeratedMeme.offset,
                        element: enumeratedMeme.element
                    )
                }
            }?.offset
    }
    
    func height() -> CGFloat {
        return self.reduce(into: 0) { partialResult, meme in
            partialResult += meme.height
        }
    }
}