import UIKit
import RealmSwift

class FilmObject: Object {
    @Persisted(primaryKey: true) var filmID: Int = 0
    @Persisted var nameRU: String = ""
    @Persisted var posterURLPreview: String = ""

    // Метод инициализации из Film
    func setValues(from film: Film) {
        self.filmID = film.filmID
        self.nameRU = film.nameRU
        self.posterURLPreview = film.posterURLPreview.absoluteString
    }

    // Преобразование FilmObject -> Film
    func toFilm() -> Film {
        return Film(
            filmID: self.filmID,
            nameRU: self.nameRU,
            posterURLPreview: URL(string: self.posterURLPreview)!
        )
    }
}
