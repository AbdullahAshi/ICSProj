import UIKit

struct BlackStyleNavigationBarBehavior: @preconcurrency ViewControllerLifecycleBehavior {

    @MainActor func viewDidLoad(viewController: UIViewController) {

        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
