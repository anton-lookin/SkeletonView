//
//  SkeletonLayer.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit

class SkeletonLayerFactory {
    
    func makeLayer(withType type: SkeletonType, usingColors colors: [UIColor], andHolder holder: UIView) -> SkeletonLayer {
        return SkeletonLayer(withType: type, usingColors: colors, andSkeletonHolder: holder)
    }
    
    func makeMultilineLayer(withType type: SkeletonType, for index: Int, width: CGFloat) -> CALayer {
        let spaceRequiredForEachLine = SkeletonDefaultConfig.multilineHeight + SkeletonDefaultConfig.multilineSpacing
        let layer = self.layer(forType: type)
        layer.anchorPoint = .zero
        layer.name = CALayer.skeletonSubLayersName
        layer.frame = CGRect(x: 0.0, y: CGFloat(index) * spaceRequiredForEachLine, width: width, height: SkeletonDefaultConfig.multilineHeight)
        return layer
    }
	
	func layer(forType type: SkeletonType) -> CALayer {
		switch type {
		case .solid:
			return CALayer()
		case .gradient:
			return CAGradientLayer()
		}
	}
	
	func layerAnimation(forType type: SkeletonType) -> SkeletonLayerAnimation {
		switch type {
		case .solid:
			return { $0.pulse }
		case .gradient:
			return { $0.sliding }
		}
	}
}

public typealias SkeletonLayerAnimation = (CALayer) -> CAAnimation

@objc public enum SkeletonType : Int {
    case solid
    case gradient
}

class SkeletonLayer : NSObject {
    
    private var maskLayer: CALayer
    private weak var holder: UIView?
    
    var type: SkeletonType {
        return maskLayer is CAGradientLayer ? .gradient : .solid
    }
    
    var contentLayer: CALayer {
        return maskLayer
    }
    
    init(withType type: SkeletonType, usingColors colors: [UIColor], andSkeletonHolder holder: UIView) {
        self.holder = holder
        self.maskLayer = SkeletonLayerFactory().layer(forType: type)
        self.maskLayer.anchorPoint = .zero
        self.maskLayer.bounds = holder.maxBoundsEstimated
        self.maskLayer.tint(withColors: colors)
		guard let multiLineView = holder as? ContainsMultilineText else { return }
		maskLayer.addMultilinesLayers(lines: multiLineView.numLines, type: type, lastLineFillPercent: multiLineView.lastLineFillingPercent)
    }
    
    func removeLayer() {
        maskLayer.removeFromSuperlayer()
    }
}

extension SkeletonLayer {

    func start(_ anim: SkeletonLayerAnimation? = nil) {
        let animation = anim ?? SkeletonLayerFactory().layerAnimation(forType: type)
        contentLayer.playAnimation(animation, key: "skeletonAnimation")
    }
    
    func stopAnimation() {
        contentLayer.stopAnimation(forKey: "skeletonAnimation")
    }
}
