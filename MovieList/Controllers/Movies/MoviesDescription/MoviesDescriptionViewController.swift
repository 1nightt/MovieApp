import UIKit

class MoviesDescriptionViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    var movieDescription: MoviesDescription?
    var onFilmIdReceived: ((String) -> Void)?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterImageView = UIImageView()
    private let titleNameLabel = UILabel()
    
    private let releaseYearLabel = UILabel()
    private let ratingLabel = UILabel()
    private let genreLabel = UILabel()
    private let stackView = UIStackView()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.backgroundColor
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configure() {
        setupScrollView()
        setupContentView()
        setupPosterImage()
        setupTitleNameLabel()
        setupStackView()
        setupDescriptionLabel()
        setupCustomBackButton()
    }
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        
        // Устанавливаем SF Symbol chevron.backward с жирной конфигурацией
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let chevronImage = UIImage(systemName: "chevron.backward", withConfiguration: boldConfig)
        backButton.setImage(chevronImage, for: .normal)
        backButton.tintColor = Resources.DescriptionViewColors.backButtonColor
        backButton.contentHorizontalAlignment = .leading
        
        // Добавляем действие для кнопки
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupPosterImage() {
        networkManager.fetchPoster(from: movieDescription!.posterURL) { data in
            self.posterImageView.image = UIImage(data: data)
        }
        
        posterImageView.contentMode = .scaleAspectFill
        
        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOpacity = 0.5
        posterImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        posterImageView.layer.shadowRadius = 4
        posterImageView.layer.masksToBounds = false
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    
    private func setupTitleNameLabel() {
        titleNameLabel.text = movieDescription?.nameRU
        titleNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleNameLabel.textColor = Resources.DescriptionViewColors.titleNameColor
        titleNameLabel.numberOfLines = 0
        titleNameLabel.textAlignment = .center
        titleNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleNameLabel)
        
        NSLayoutConstraint.activate([
            titleNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 95),
            titleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupStackView() {
        releaseYearLabel.text = "\(movieDescription!.year)"
        releaseYearLabel.textColor = Resources.DescriptionViewColors.descriptionColor
        releaseYearLabel.font = UIFont.systemFont(ofSize: 15)
        
        ratingLabel.text = "\(movieDescription!.ratingKinopoisk)"
        ratingLabel.textColor = Resources.DescriptionViewColors.descriptionColor
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        genreLabel.text = "Жанр: \(movieDescription!.genres.map( { $0.genre }).joined(separator: ", "))"
        genreLabel.textColor = Resources.DescriptionViewColors.descriptionColor
        genreLabel.font = UIFont.boldSystemFont(ofSize: 15)
        genreLabel.numberOfLines = 0
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        stackView.addArrangedSubview(releaseYearLabel)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(genreLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = movieDescription?.description
        descriptionLabel.textColor = Resources.DescriptionViewColors.titleNameColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
