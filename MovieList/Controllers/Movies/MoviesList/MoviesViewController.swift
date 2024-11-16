import UIKit
import RealmSwift

//class MoviesViewController: UIViewController, UICollectionViewDelegateFlowLayout {
//    
//    // MARK: - Private Properties
//    private let searchController = UISearchController(searchResultsController: nil)
//    private var collectionView: UICollectionView!
//    private let networkManager = NetworkManager.shared
//    var dataSource = [Film]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = Resources.Colors.backgroundColor
//        configure()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupNavBarController()
//    }
//    
//    // MARK: - Private Methods
//    private func configure() {
//        checkAndRequestApiKey()
//        setupNavBarController()
//        setupSearchController()
//        setupCollectionView()
//        fetchMovies()
//    }
//    
//    private func checkAndRequestApiKey() {
//        guard KeychainManager.shared.retrieve(key: "apiKey") == nil else { return }
//        showApiKeyAlert()
//    }
//    
//    private func showApiKeyAlert() {
//        let alert = UIAlertController(title: "API Key", message: "Введите ваш API ключ", preferredStyle: .alert)
//        alert.addTextField { textField in
//            textField.placeholder = "API Key"
//        }
//        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak self] _ in
//            if let apiKey = alert.textFields?.first?.text, !apiKey.isEmpty {
//                self?.networkManager.setApiKey(apiKey)
//                self?.fetchMovies()
//            } else {
//                self?.showApiKeyAlert()
//            }
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//
//    
//    private func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 180, height: 270)
//        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.backgroundColor = Resources.Colors.backgroundColor
//        self.view.addSubview(collectionView)
//    }
//    
//    private func setupSearchController() {
//        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
//            let placeholderText = "Введите название фильма"
//            
//            let attributes = [
//                NSAttributedString.Key.foregroundColor: UIColor.white
//            ]
//            searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
//            
//            searchTextField.textColor = UIColor.white
//            
//            searchTextField.tintColor = UIColor.white
//        }
//        
//        if let searchIcon = searchController.searchBar.searchTextField.leftView as? UIImageView {
//            searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
//            searchIcon.tintColor = UIColor.white
//        }
//    }
//    
//    private func setupNavBarController() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.searchController = searchController
//        if let navigationBar = navigationController?.navigationBar {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = Resources.Colors.navBarColor
//            
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//            
//            navigationBar.standardAppearance = appearance
//            navigationBar.scrollEdgeAppearance = appearance
//            navigationBar.compactAppearance = appearance
//        }
//    }
//    
//    private func fetchMovies() {
//        networkManager.fetchMovies { [weak self] result in
//            switch result {
//            case .success(let movies):
//                self?.dataSource = movies.films
//                self?.collectionView.reloadData()
//            case .failure(let error):
//                print("Error in fetchMovies: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func navigateToMovieDescriptionViewController(with movieDescription: MoviesDescription) {
//        let descriptionVC = MoviesDescriptionViewController()
//        descriptionVC.movieDescription = movieDescription
//        navigationController?.pushViewController(descriptionVC, animated: true)
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//extension MoviesViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MoviesCell else { return UICollectionViewCell() }
//        cell.imageView.image = UIImage(systemName: "movieclapper")
//        cell.imageView.tintColor = .lightGray
//        cell.label.text = ""
//        
//        let film = dataSource[indexPath.row]
//        cell.label.text = film.nameRU
//        networkManager.fetchPoster(from: film.posterURLPreview) { data in
//            cell.imageView.image = UIImage(data: data)
//        }
//        
//        return cell
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//extension MoviesViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let film = dataSource[indexPath.row]
//        let filmId = film.filmID
//        
//        NetworkManager.shared.fetchDescriptionMovies(for: String(filmId)) { [weak self] result in
//            switch result {
//            case .success(let movieDescription):
//                DispatchQueue.main.async {
//                    self?.navigateToMovieDescriptionViewController(with: movieDescription)
//                }
//            case .failure(let error):
//                print("Error fetching movie description: \(error)")
//            }
//        }
//    }
//}

class MoviesViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Private Properties
    private let realmService = RealmService()
    private let networkManager = NetworkManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    private var collectionView: UICollectionView!
    private var dataSource = [Film]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.backgroundColor
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarController()
    }
    
    // MARK: - Private Methods
    private func configure() {
        checkAndRequestApiKey()
        setupNavBarController()
        setupSearchController()
        setupCollectionView()
        loadData()
    }
    
    private func checkAndRequestApiKey() {
        guard KeychainManager.shared.retrieve(key: "apiKey") == nil else { return }
        showApiKeyAlert()
    }
    
    private func showApiKeyAlert() {
        let alert = UIAlertController(title: "API Key", message: "Введите ваш API ключ", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "API Key"
        }
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak self] _ in
            if let apiKey = alert.textFields?.first?.text, !apiKey.isEmpty {
                self?.networkManager.setApiKey(apiKey)
                self?.fetchMoviesFromNetwork()
            } else {
                self?.showApiKeyAlert()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 270)
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MoviesCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = Resources.Colors.backgroundColor
        view.addSubview(collectionView)
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Введите название фильма"
        navigationItem.searchController = searchController
    }
    
    private func setupNavBarController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func loadData() {
        if realmService.hasFilms() {
            dataSource = realmService.fetchFilms()
            collectionView.reloadData()
        } else {
            fetchMoviesFromNetwork()
        }
    }
    
    private func fetchMoviesFromNetwork() {
        networkManager.fetchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.realmService.saveFilms(movies.films)
                self?.dataSource = movies.films
                self?.collectionView.reloadData()
            case .failure(let error):
                print("Error in fetchMovies: \(error.localizedDescription)")
            }
        }
    }
    
    func navigateToMovieDescriptionViewController(with movieDescription: MoviesDescription) {
        let descriptionVC = MoviesDescriptionViewController()
        descriptionVC.movieDescription = movieDescription
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MoviesCell else { return UICollectionViewCell() }
        let film = dataSource[indexPath.row]
        cell.label.text = film.nameRU
        networkManager.fetchPoster(from: film.posterURLPreview) { data in
            cell.imageView.image = UIImage(data: data)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let film = dataSource[indexPath.row]
        let filmId = film.filmID
        
        NetworkManager.shared.fetchDescriptionMovies(for: String(filmId)) { [weak self] result in
            switch result {
            case .success(let movieDescription):
                DispatchQueue.main.async {
                    self?.navigateToMovieDescriptionViewController(with: movieDescription)
                }
            case .failure(let error):
                print("Error fetching movie description: \(error)")
            }
        }
    }
}
