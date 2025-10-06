import AuthenticationServices
import Foundation
import UIKit

public protocol WindowType: ASPresentationAnchor {

    var rootViewController: UIViewController? { get set }

    func makeKeyAndVisible()
}

extension UIWindow: WindowType {}
