//
//  SkeletonAnimationBuilder.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 17/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

typealias GradientAnimationPoint = (from: CGPoint, to: CGPoint)

@objc public enum GradientDirection : Int {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
}

public class SkeletonAnimationBuilder {
    
    public init() {
    }
    
    public func makeSlidingAnimation(withDirection direction: GradientDirection, duration: CFTimeInterval = 1.5) -> SkeletonLayerAnimation {
        return { layer in
            
            let startPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
            startPointAnim.fromValue = NSValue(cgPoint: self.startPoint(forGradientDirection: direction).from)
            startPointAnim.toValue = NSValue(cgPoint: self.startPoint(forGradientDirection: direction).to)
            
            let endPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
            endPointAnim.fromValue = NSValue(cgPoint: self.endPoint(forGradientDirection: direction).from)
            endPointAnim.toValue = NSValue(cgPoint: self.endPoint(forGradientDirection: direction).to)
            
            let animGroup = CAAnimationGroup()
            animGroup.animations = [startPointAnim, endPointAnim]
            animGroup.duration = duration
            animGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animGroup.repeatCount = .infinity
            
            return animGroup
        }
    }
	
	func startPoint(forGradientDirection direction: GradientDirection) -> GradientAnimationPoint {
		switch direction {
		case .leftRight:
			return (from: CGPoint(x:-1, y:0.5), to: CGPoint(x:1, y:0.5))
		case .rightLeft:
			return (from: CGPoint(x:1, y:0.5), to: CGPoint(x:-1, y:0.5))
		case .topBottom:
			return (from: CGPoint(x:0.5, y:-1), to: CGPoint(x:0.5, y:1))
		case .bottomTop:
			return (from: CGPoint(x:0.5, y:1), to: CGPoint(x:0.5, y:-1))
		case .topLeftBottomRight:
			return (from: CGPoint(x:-1, y:-1), to: CGPoint(x:1, y:1))
		case .bottomRightTopLeft:
			return (from: CGPoint(x:1, y:1), to: CGPoint(x:-1, y:-1))
		}
	}
	
	func endPoint(forGradientDirection direction: GradientDirection) -> GradientAnimationPoint {
		switch direction {
		case .leftRight:
			return (from: CGPoint(x:0, y:0.5), to: CGPoint(x:2, y:0.5))
		case .rightLeft:
			return ( from: CGPoint(x:2, y:0.5), to: CGPoint(x:0, y:0.5))
		case .topBottom:
			return ( from: CGPoint(x:0.5, y:0), to: CGPoint(x:0.5, y:2))
		case .bottomTop:
			return ( from: CGPoint(x:0.5, y:2), to: CGPoint(x:0.5, y:0))
		case .topLeftBottomRight:
			return ( from: CGPoint(x:0, y:0), to: CGPoint(x:2, y:2))
		case .bottomRightTopLeft:
			return ( from: CGPoint(x:2, y:2), to: CGPoint(x:0, y:0))
		}
	}

}
