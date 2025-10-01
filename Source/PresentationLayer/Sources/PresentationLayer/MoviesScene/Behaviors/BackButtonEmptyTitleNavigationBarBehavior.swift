import UIKit

struct BackButtonEmptyTitleNavigationBarBehavior: @preconcurrency ViewControllerLifecycleBehavior {

    @MainActor func viewDidLoad(viewController: UIViewController) {

        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
