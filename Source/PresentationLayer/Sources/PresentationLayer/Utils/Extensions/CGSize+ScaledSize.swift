import Foundation
import UIKit

public extension CGSize {
    @MainActor var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
