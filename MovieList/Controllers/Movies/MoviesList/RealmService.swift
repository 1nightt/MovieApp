import UIKit
import RealmSwift

class RealmService {
    private let realm = try! Realm()

    func saveFilms(_ films: [Film]) {
        do {
            try realm.write {
                for film in films {
                    let filmObject = FilmObject()
                    filmObject.setValues(from: film)
                    realm.add(filmObject, update: .modified)
                }
            }
        } catch {
            print("Error saving films to Realm: \(error)")
        }
    }

    func fetchFilms() -> [Film] {
        let filmObjects = realm.objects(FilmObject.self)
        return filmObjects.map { $0.toFilm() }
    }

    func hasFilms() -> Bool {
        return !realm.objects(FilmObject.self).isEmpty
    }
}
