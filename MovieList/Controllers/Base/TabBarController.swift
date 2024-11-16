import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        let moviesViewController = MoviesViewController()
        let favoriteViewController = FavoriteViewController()
        
        tabBar.barStyle = .black
        tabBar.tintColor = Resources.Colors.active
        tabBar.unselectedItemTintColor = Resources.Colors.inactive
        tabBar.backgroundColor = Resources.Colors.tabBarColor
        
        moviesViewController.tabBarItem.image = Resources.Strings.Images.movies
        favoriteViewController.tabBarItem.image = Resources.Strings.Images.favorite
        
        moviesViewController.title = Resources.Strings.TabBar.movies
        favoriteViewController.title = Resources.Strings.TabBar.favorite
        
        let moivesNavViewController = UINavigationController(rootViewController: moviesViewController)
//        let favoriteNavViewController = UINavigationController(rootViewController: favoriteViewController)
        
        setViewControllers([moivesNavViewController, favoriteViewController], animated: true)
    }
}
