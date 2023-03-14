import Foundation
import MapKit

final class ApiService {
    static let shared = ApiService()
    
    private let apiUrl = "http://127.0.0.1:8000/api"
    
    private init() {}
    
    func getUserByID(userId: Int, completionHandler: @escaping (Result<User, Error>) -> Void) {
        let request: String = apiUrl + "/users/" + String(userId)
        
        guard let requestUrl = URL(
            string: request
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) {
            data, response, error in
            if
                let data = data,
                let result = try? JSONDecoder().decode(User.self, from: data)
            {
                completionHandler(.success(result))
            } else {
                guard let error = error else {
                    return
                }
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    func getItemByID(itemId: Int, completionHandler: @escaping (Result<Item, Error>) -> Void) {
        let request: String = apiUrl + "/items/" + String(itemId)
        
        guard let requestUrl = URL(
            string: request
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) {
            data, response, error in
            if
                let data = data,
                let result = try? JSONDecoder().decode(Item.self, from: data)
            {
                completionHandler(.success(result))
            } else {
                guard let error = error else {
                    return
                }
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getItemsOnMap(mapRect: MKCoordinateRegion, completionHandler: @escaping (Result<[Item], Error>) -> Void) {
        let request: String = apiUrl + "/items/on_map?" + (
            "east_longitude=" + String(mapRect.eastLongitude) +
            "&west_longitude=" + String(mapRect.westLongitude) +
            "&north_latitude=" + String(mapRect.northLatitude) +
            "&south_latitude=" + String(mapRect.southLatitude)
        )
        
        guard let requestUrl = URL(
            string: request
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) {
            data, response, error in
            if
                let data = data,
                let result = try? JSONDecoder().decode(ItemArray.self, from: data)
            {
                completionHandler(.success(result.array))
            } else {
                guard let error = error else {
                    return
                }
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
