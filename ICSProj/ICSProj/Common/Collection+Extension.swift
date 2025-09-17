//
//  Collection+Extension.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

extension Collection {
    /// Safely retrieves an element from the collection at the specified index.
    /// - Parameter index: The index of the element to retrieve.
    /// - Returns: The element at the given index, or `nil` if the index is out of bounds.
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
