//
//  File.swift
//  
//
//  Created by Alex Loren on 5/20/24.
//

extension FloatingPoint {
    /// Clamps the number to a ``ClosedRange``.
    /// - Parameter range: The range to keep the ``Float`` within.
    /// - Returns: The clamped value.
    func clamped(to range: ClosedRange<Self>) -> Self {
        return max(min(self, range.upperBound), range.lowerBound)
    }
}
