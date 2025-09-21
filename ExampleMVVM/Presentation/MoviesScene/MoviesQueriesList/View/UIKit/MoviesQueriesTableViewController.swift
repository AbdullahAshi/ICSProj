import UIKit
import Combine

final class MoviesQueriesTableViewController: UITableViewController, StoryboardInstantiable {
    
    private var viewModel: MoviesQueryListViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var currentItems: [MoviesQueryListItemViewModel] = []

    // MARK: - Lifecycle

    static func create(with viewModel: MoviesQueryListViewModel) -> MoviesQueriesTableViewController {
        let view = MoviesQueriesTableViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: MoviesQueryListViewModel) {
        viewModel.items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.currentItems = items
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear()
    }

    // MARK: - Private

    private func setupViews() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = MoviesQueriesItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MoviesQueriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesQueriesItemCell.reuseIdentifier, for: indexPath) as? MoviesQueriesItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(MoviesQueriesItemCell.self) with reuseIdentifier: \(MoviesQueriesItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        cell.fill(with: currentItems[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(item: currentItems[indexPath.row])
    }
}
