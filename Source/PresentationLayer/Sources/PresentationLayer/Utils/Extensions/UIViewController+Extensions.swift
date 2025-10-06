//
//  UIViewController+Extensions.swift
//  UniSuper
//
//  Created by Harry Singh on 7/2/2022.
//  Copyright © 2022 UniSuper. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static var instantiate: Self {
        return .init(nibName: String(describing: self), bundle: .module)
    }
}
