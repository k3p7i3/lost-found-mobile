import Foundation
import MapKit

struct ItemCreateResponse: Decodable {
    let status: String
    let item_id: Int
}

struct UserCreateResponse: Decodable {
    let status: String
    let user_id: Int
}

struct ImageCreateResponse: Decodable {
    let status: String
    let path: String
}

final class ApiService {
    static let shared = ApiService()
    
    private let apiUrl = "http://127.0.0.1:8000/api"
    
    private init() {}
    
    private func getJSONDecoder() -> JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    func getUserByID(userId: Int, completionHandler: @escaping (Result<UserModel, Error>) -> Void) {
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
                let result = try? JSONDecoder().decode(UserModel.self, from: data)
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
    
    func loginUser(user: UserModel, completionHandler: @escaping (Result<UserModel, Error>) -> Void) {
        let requestPath: String = apiUrl + "/users/login"
        guard let requestUrl = URL(
            string: requestPath
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedUser = try JSONEncoder().encode(user)
            request.httpBody = encodedUser
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if
                let data = data,
                let result = try? JSONDecoder().decode(UserModel.self, from: data)
            {
                guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode)
                else {
                    completionHandler(.failure(URLError(.badServerResponse)))
                    return
                }
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
    
    func registrateUser(user: UserModel, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        let requestPath: String = apiUrl + "/users/registration"
        guard let requestUrl = URL(
            string: requestPath
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedUser = try JSONEncoder().encode(user)
            request.httpBody = encodedUser
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if
                let data = data,
                let result = try? JSONDecoder().decode(UserCreateResponse.self, from: data)
            {
                completionHandler(.success(result.user_id))
            } else {
                guard let error = error else {
                    return
                }
                completionHandler(.failure(error))
            }
        }

        task.resume()
    }
    
    func getItemByID(
        itemId: Int,
        completionHandler: @escaping (Result<ItemModel, Error>) -> Void
    ) {
        let request: String = apiUrl + "/items/" + String(itemId)
        
        guard let requestUrl = URL(
            string: request
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) {
            [weak self] data, response, error in
            if
                let data = data,
                let result = try? self?.getJSONDecoder().decode(ItemModel.self, from: data)
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
    
    func getItemImage(path: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        let request: String = apiUrl + "/items/images/" + path
        guard let requestUrl = URL(string: request) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) {
            data, response, error in
            if
                let data = data,
                let image = UIImage(data: data)
            {
                completionHandler(.success(image))
            } else {
                guard let error = error else {
                    return
                }
                completionHandler(.failure(error))
            }

        }
        
        task.resume()
    }
    
    func getUserImage(path: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        let request: String = apiUrl + "/users/images/" + path
        guard let requestUrl = URL(string: request) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) {
            data, response, error in
            if
                let data = data,
                let image = UIImage(data: data)
            {
                completionHandler(.success(image))
            } else {
                guard let error = error else {
                    return
                }
                completionHandler(.failure(error))
            }

        }
        
        task.resume()
    }
    
    func uploadUserImage(userId: Int, image: UIImage, completionHandler: @escaping (Result<String, Error>) -> Void) {
        let requestPath: String = apiUrl + "/users/create/image/" + String(userId)
        guard let requestUrl = URL(
            string: requestPath
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(userId).jpeg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.7)!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            if
                let data = data,
                let result = try? JSONDecoder().decode(ImageCreateResponse.self, from: data)
            {
                completionHandler(.success(result.path))
            } else {
                guard let error = error else {
                    return
                }
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
        
    func getItemsOnMap(mapRect: MKCoordinateRegion, completionHandler: @escaping (Result<[ItemModel], Error>) -> Void) {
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
            [weak self] data, response, error in
            if
                let data = data,
                let result = try? self?.getJSONDecoder().decode(ItemArray.self, from: data)
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
    
    func createItem(item: ItemModel, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        let requestPath: String = apiUrl + "/items/create"
        guard let requestUrl = URL(
            string: requestPath
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encodedItem = try JSONEncoder().encode(item)
            request.httpBody = encodedItem
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if
                let data = data,
                let result = try? JSONDecoder().decode(ItemCreateResponse.self, from: data)
            {
                completionHandler(.success(result.item_id))
            } else {
                guard let error = error else {
                    return
                }
                completionHandler(.failure(error))
            }
        }

        task.resume()
    }
    
    
    func uploadItemImage(itemId: Int, image: UIImage, completionHandler: @escaping (Result<String, Error>) -> Void) {
        let requestPath: String = apiUrl + "/items/create/image/" + String(itemId)
        guard let requestUrl = URL(
            string: requestPath
        ) else {
            completionHandler(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(itemId).jpeg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.7)!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            if
                let data = data,
                let result = try? JSONDecoder().decode(ImageCreateResponse.self, from: data)
            {
                completionHandler(.success(result.path))
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
