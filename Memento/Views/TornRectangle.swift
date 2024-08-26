//
//  TornRectangle.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 8/25/24.
//


// Copyright 2021 Kyle Hughes
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI

private let drawingOrder: [Edge] = [.top, .trailing, .bottom, .leading]
private let valleyDepth: ClosedRange<CGFloat> = 0.5 ... 6
private let valleyHypotenuseLength: ClosedRange<CGFloat> = 6 ... 18

public struct TornRectangle {
    private let tornEdges: Edge.Set
    
    // Static cache to store precomputed paths
    private struct SizeKey: Hashable {
        let width: CGFloat
        let height: CGFloat
        
        init(size: CGSize) {
            self.width = size.width
            self.height = size.height
        }
    }

    private static var pathCache: [SizeKey: Path] = [:]
    
    // MARK: Public Initialization
    
    public init(tornEdges: Edge.Set) {
        self.tornEdges = tornEdges
    }
}

// MARK: - Shape Extension

extension TornRectangle: Shape {
    // MARK: Shape Body
    
    public func path(in rect: CGRect) -> Path {
        if let cachedPath = TornRectangle.pathCache[SizeKey(size: rect.size)] {
            return cachedPath
        }
        
        let newPath = Path { path in
            path.move(to: .zero)
            
            for edge in drawingOrder {
                let origin = path.currentPoint
                
                while isNotFinishedDrawing(edge, for: path, in: rect) {
                    path.addLine(to: nextPoint(for: path, along: edge, originatingAt: origin, in: rect))
                }
            }
        }
        
        if let cachedPath = TornRectangle.pathCache[SizeKey(size: rect.size)] {
            return cachedPath
        }

        TornRectangle.pathCache[SizeKey(size: rect.size)] = newPath
        return newPath
    }
    
    // MARK: Layout Math
    
    private var randomValleyDepth: CGFloat {
        .random(in: valleyDepth)
    }
    
    private var randomValleyHypotenuseLength: CGFloat {
        .random(in: valleyHypotenuseLength)
    }
    
    private func calculator(for axis: Axis, along edge: Edge) -> (CGFloat, CGFloat) -> CGFloat {
        switch edge {
        case .bottom:
            return (-)
        case .leading:
            switch axis {
            case .horizontal:
                return (+)
            case .vertical:
                return (-)
            }
        case .top:
            return (+)
        case .trailing:
            switch axis {
            case .horizontal:
                return (-)
            case .vertical:
                return (+)
            }
        }
    }
    
    private func endOf(_ edge: Edge, in rect: CGRect) -> CGPoint {
        switch edge {
        case .bottom:
            return CGPoint(x: rect.minX, y: rect.maxY)
        case .leading:
            return CGPoint(x: rect.minX, y: rect.minY)
        case .top:
            return CGPoint(x: rect.maxX, y: rect.minY)
        case .trailing:
            return CGPoint(x: rect.maxX, y: rect.maxY)
        }
    }

    private func isNotFinishedDrawing(_ edge: Edge, for path: Path, in rect: CGRect) -> Bool {
        guard let point = path.currentPoint else {
            return false
        }
        
        switch edge {
        case .bottom:
            return rect.minX < point.x
        case .leading:
            return rect.minY < point.y
        case .top:
            return point.x < rect.maxX
        case .trailing:
            return point.y < rect.maxY
        }
    }
    
    private func nextPoint(
        for path: Path,
        along edge: Edge,
        originatingAt origin: CGPoint?,
        in rect: CGRect
    ) -> CGPoint {
        let origin = origin ?? .zero
        let currentPoint = path.currentPoint ?? origin
        
        return CGPoint(
            x: x(after: currentPoint, along: edge, originatingAt: origin, in: rect),
            y: y(after: currentPoint, along: edge, originatingAt: origin, in: rect)
        )
    }
    
    private func x(
        after point: CGPoint,
        along edge: Edge,
        originatingAt origin: CGPoint,
        in rect: CGRect
    ) -> CGFloat {
        switch edge {
        case .top, .bottom:
            guard point.isNotWithinOneValleyOfEnd(of: edge, in: rect) else {
                return endOf(edge, in: rect).x
            }
            return calculator(for: .horizontal, along: edge)(point.x, randomValleyHypotenuseLength)
        case .leading, .trailing:
            guard tornEdges.contains(edge.asSet), point.isAlong(edge, originatingAt: origin) else {
                return origin.x
            }
            return calculator(for: .horizontal, along: edge)(origin.x, randomValleyDepth)
        }
    }
    
    private func y(
        after point: CGPoint,
        along edge: Edge,
        originatingAt origin: CGPoint,
        in rect: CGRect
    ) -> CGFloat {
        switch edge {
        case .top, .bottom:
            guard tornEdges.contains(edge.asSet), point.isAlong(edge, originatingAt: origin) else {
                return origin.y
            }
            return calculator(for: .vertical, along: edge)(origin.y, randomValleyDepth)
        case .leading, .trailing:
            guard point.isNotWithinOneValleyOfEnd(of: edge, in: rect) else {
                return endOf(edge, in: rect).y
            }
            return calculator(for: .vertical, along: edge)(point.y, randomValleyHypotenuseLength)
        }
    }
}

// MARK: - Extension for CGPoint

extension CGPoint {
    // MARK: Fileprivate Instance Interface
    
    fileprivate func isAlong(_ edge: Edge, originatingAt origin: CGPoint) -> Bool {
        switch edge {
        case .bottom, .top:
            return y == origin.y
        case .leading, .trailing:
            return x == origin.x
        }
    }
    
    fileprivate func isNotWithinOneValleyOfEnd(of edge: Edge, in rect: CGRect) -> Bool {
        switch edge {
        case .bottom:
            return valleyHypotenuseLength.upperBound - rect.minX < x
        case .leading:
            return valleyHypotenuseLength.upperBound - rect.minY < y
        case .top:
            return x < rect.maxX - valleyHypotenuseLength.upperBound
        case .trailing:
            return y < rect.maxY - valleyHypotenuseLength.upperBound
        }
    }
}

// MARK: - Extension for Edge

extension Edge {
    // MARK: Fileprivate Instance Interface
    
    fileprivate var asSet: Edge.Set {
        switch self {
        case .bottom:
            return .bottom
        case .leading:
            return .leading
        case .top:
            return .top
        case .trailing:
            return .trailing
        }
    }
}

// MARK: - Previews

#if DEBUG
public struct TornRectangle_Previews: PreviewProvider {
    // MARK: Preview Views
    
    public static var previews: some View {
        TornRectangle(tornEdges: .all)
            .fill(.green)
            .frame(width: 300, height: 300)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
