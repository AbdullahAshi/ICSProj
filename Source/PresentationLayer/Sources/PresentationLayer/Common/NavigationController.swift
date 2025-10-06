import Combine
import UIKit

public typealias Block = () -> Void

open class NavigationController: UINavigationController {

    private final class Item {

        enum State {
            case pushed
            case displayed
        }

        weak var viewController: UIViewController?
        let key: String
        let popHandler: Block?
        var state: State

        init(viewController: UIViewController, popHandler: Block?, state: State) {
            self.viewController = viewController
            key = viewController.description
            self.popHandler = popHandler
            self.state = state
        }
    }

    // MARK: - Properties

    private var cancellable: Set<AnyCancellable> = .init()
    private var popHandlers: [String: Item] = [:]

    // MARK: - Lifecycle

    override open func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        // This needs to be delayed otherwise it never publishes any values
        DispatchQueue.main.async {

            // The reason for this is to avoid a retain cycle when
            // assigning the delegate to self. There is an open radar for it.
            // https://openradar.appspot.com/radar?id=5051204623138816
            self.publisher(for: \.presentingViewController)
                .compactMap { $0 }
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [unowned self] _ in self.presentationController?.delegate = self })
                .store(in: &self.cancellable)
        }

//        navigationBar.applyDefaultTheme()
    }

    // MARK: - Public

    func push(_ viewController: UIViewController, animated: Bool = true, popHandler: Block? = nil) {
        viewController.navigationItem.backButtonTitle = "back"
        viewController.navigationItem.backButtonDisplayMode = .minimal

        if let popHandler = popHandler {
            popHandlers[viewController.description] = .init(viewController: viewController, popHandler: popHandler, state: .pushed)
        }

        if viewControllers.isEmpty {
            setViewControllers([viewController], animated: false)
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }
}

// MARK: - Conformance

// MARK: UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {

    @available(*, unavailable)
    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }

    public func navigationController(
        _: UINavigationController,
        didShow viewController: UIViewController,
        animated _: Bool
    ) {
        didShow(viewController: viewController)
    }
}

// MARK: UIAdaptivePresentationControllerDelegate

extension NavigationController: UIAdaptivePresentationControllerDelegate {

    public func presentationControllerDidDismiss(_: UIPresentationController) {
        topViewController?.viewDidAppear(true)
        clearPopHandlers()
    }
}

// MARK: - Public

extension NavigationController {

    override open func present(_ viewController: UIViewController, animated: Bool = true, completion: Block? = nil) {
        super.present(
            viewController,
            animated: animated,
            completion: completion
        )
    }

    override open func dismiss(animated: Bool = true, completion: Block? = nil) {
        super.dismiss(animated: animated, completion: completion)

        // System alerts also trigger dismiss
        // so we want to make sure nothing is presented
        // before we clear all the popHandlers
        guard presentedViewController != nil else {
            return
        }

        clearPopHandlers()
    }

    @discardableResult
    override open func popViewController(animated: Bool = true) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
}

// MARK: - Helpers

private extension NavigationController {

    func clearPopHandlers() {
        popHandlers.forEach { $0.value.popHandler?() }
        popHandlers = [:]
    }

    func popHandlers(for stack: [UIViewController]) {
        let current: Set<UIViewController> = .init(stack)
        let shown: Set<UIViewController> = .init(popHandlers.filter { $0.value.state == .displayed }.compactMap(\.value.viewController))

        shown.subtracting(current).forEach {
            popHandlers[$0.description]?.popHandler?()
            popHandlers[$0.description] = nil
        }
    }

    func didShow(viewController: UIViewController) {
        popHandlers(for: viewControllers)
        popHandlers[viewController.description]?.state = .displayed
    }
}
