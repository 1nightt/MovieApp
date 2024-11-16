//
//  Resources.swift
//  MovieList
//
//  Created by Артем Ворыпаев on 01.10.2024.
//

import Foundation
import UIKit

enum Resources {
    enum Colors {
        static let active: UIColor = UIColor(hexString: "839FDE")
        static let inactive: UIColor = UIColor(hexString: "8E8B86")
        static let tabBarColor: UIColor = UIColor(hexString: "#353430")
        static let backgroundColor: UIColor = UIColor(hexString: "#1A1C19")
        static let navBarColor: UIColor = UIColor(hexString: "#373155")
        static let textColor: UIColor = UIColor(hexString: "FFFFFA")
    }
    
    enum DescriptionViewColors {
        static let titleNameColor = UIColor(hexString: "#7793d3")
        static let descriptionColor = UIColor(hexString: "#868686")
        static let backButtonColor = UIColor(hexString: "#d1e568")
    }
    
    enum Strings {
        enum TabBar {
            static let movies = "Фильмы"
            static let favorite = "Избранное"
        }
        
        enum Images {
            static let movies = UIImage(systemName: "movieclapper")
            static let favorite = UIImage(systemName: "star")
        }
    }
}
