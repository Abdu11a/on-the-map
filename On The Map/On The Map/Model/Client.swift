//
//  Client.swift
//  On The Map
//
//  Created by Abdulla Aseed on 11/02/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation
class Client {
    
    struct Auth {
        static var keyAccount = ""
        static var sessionId = ""
    }
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case createSessionId
        case getStudentLocation(Int)
        case getOneStudentLocation(String)
        case logout
        case getUserData
        case postStudentLocation
        case updateStudentLocation(String)
        var stringValue : String {
            switch self {
            case .createSessionId :
                return Endpoints.base + "session"
        
            case .getStudentLocation(let index):
                return Endpoints.base + "StudentLocation" + "?limit=100&skip=\(index)&order=-updatedAt"
                
            case .getOneStudentLocation(let uniqueKey):
                return Endpoints.base + "StudentLocation?uniqueKey=\(uniqueKey)"
            case .logout:
                return Endpoints.base + "session"
            case .getUserData:
                return Endpoints.base + "users/\(Auth.keyAccount)"
            case .postStudentLocation:
                return Endpoints.base + "StudentLocation"
            case .updateStudentLocation(let objectID):
                return Endpoints.base + "StudentLocation/\(objectID)"
            }
        }
        var url : URL {
            return URL(string: stringValue)!
        }
    }
    class func postStudentLocation(postLocation : PostLocation , completion: @escaping (PostLocationResponse?, Error?) -> Void){
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(postLocation)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.sync {
                    return  completion(nil , error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PostLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch{ DispatchQueue.main.async {
                completion(nil, error)
                }}
        }
        task.resume()
        
    }
    
    class func putStudentLocation(objectID: String, postLocation: PostLocation, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateStudentLocation(objectID).url)
        
        print(request.description)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = postLocation
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObj = try decoder.decode(PostLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    print(responseObj)
                    completion(true, nil)
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
        task.resume()
        
    }
   
    class func getUserData(completion: @escaping (UserData?, Error?) -> Void){
        let request = URLRequest(url:Endpoints.getUserData.url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            do {
                let requestObject = try decoder.decode(UserData.self, from: newData)
                DispatchQueue.main.async {
                    print(newData)
                    completion(requestObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
        }
        task.resume()
    }
    class func logout(completion: @escaping (Bool, Error?) -> Void){
 
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie}
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
        task.resume()
        
    }
    class func login(with email: String, password: String, completion: @escaping (Bool, Error?) -> Void ) {
         var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyString = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        request.httpBody = bodyString.data(using: .utf8)
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completion(false, error)
                }
                return
            }
            print("login: \(String(describing: String(data: data, encoding: .utf8)))")
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(UserLoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    self.Auth.sessionId = responseObject.session.id
                    self.Auth.keyAccount = responseObject.account.key
                    completion(true, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
     task.resume()
    }
    
    class func getStudentLocation(oneStudent : Bool , completion : @escaping ([StudentLocation]?, Error?) -> Void  ){
        
         var url = URL(string: "www.google.com")!
        
        if oneStudent {
            url = Endpoints.getOneStudentLocation("1234").url
        } else {
            url = Endpoints.getStudentLocation(0).url
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let requestObject = try decoder.decode(StudentLocations.self, from: data)
                DispatchQueue.main.async {
                    completion(requestObject.results, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    
}
