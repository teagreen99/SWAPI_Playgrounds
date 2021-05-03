import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
//    let opening_crawl: String
//    let release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static let personEndpoint = "people/"
    static let filmsEndpoint = "films/"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // https://swapi.dev/api/person/"
        // STEP 1 - Create your URL
        guard let baseURL = baseURL else { return completion(nil) }
        let personURL = baseURL.appendingPathComponent(personEndpoint)
        let inString = String(id)
        let finalURL = personURL.appendingPathComponent(inString)
        print(finalURL)
        // STEP 2 - Data Task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            // STEP 3 - Error Handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            // STEP 4 - Check for Data
            guard let data = data else { return completion(nil) }
            
            // STEP 5 - Decode Data from JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        // STEP 2 - Data Task
        URLSession.shared.dataTask(with: url) { data, _, error in
            // STEP 3 - Error Handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            // STEP 4 - Check for Data
            guard let data = data else { return completion(nil) }
            
            // STEP 5 - Decode Data
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                print(film)
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
                
            }
        }.resume()
    }
} // End of class

func fetchFilmForGivenURL(url: URL) {
    
    SwapiService.fetchFilm(url: url) { film in
        //if film != nil {
         //   print(film)
       //  }
    }
}

SwapiService.fetchPerson(id: 2) { person in
    if let person = person {
        print(person)
        for url in person.films {
            fetchFilmForGivenURL(url: url)
        }
    }
}




