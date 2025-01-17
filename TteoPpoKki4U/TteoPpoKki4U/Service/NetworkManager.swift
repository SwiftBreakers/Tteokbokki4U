//
//  NetworkManager.swift
//  TteoPpoKki4U
//
//  Created by 박준영 on 5/30/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    var stores: [Document] = []
    
    
    func fetchAPI(query: String, completion: @escaping ([Document]) -> Void) {
        
        var components = URLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword")!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "category_group_code", value: "FD6")
        ]
        
        // URL 구성 요소를 사용하여 URL 생성
        guard let url = components.url else {
            print("Failed to create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.allHTTPHeaderFields = ["Authorization" : "KakaoAK \(Secret().kakaoLocalApi)"]
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            // 응답 코드가 성공(200)인지 확인
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response code: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            guard let store = try? JSONDecoder().decode(Welcome.self, from: data) else { return }
            self.stores = store.documents
            
            DispatchQueue.main.async {
                completion(self.stores)
            }
            
        }.resume()
    }
    
}
