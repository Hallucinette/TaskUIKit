//
//  TaskService.swift
//  TodoTaskUIKit
//
//  Created by Amelie Pocchiolo on 15/02/2024.
//

import Foundation

class TaskService {
    private let url = URL(string: "https://api.airtable.com/v0/appgc7APdd5MSs84o/tblm4YGiAnMKGdoVk")
    private let token = "patYHD0qc8Cahs3AO.f704c94ca61ee573308d3cf73eaca86e028e6ffcf54e3513947a0dd475960ea2"
    
    func getRecords(completion: @escaping ([RecordTask]?, Error?) -> Void) {
        guard let url = url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Ici on est asynchrone
            guard error == nil, let data = data else {
                completion(nil, error)
                return
            }
    
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            }
            
            guard let responseHttp = response as? HTTPURLResponse else {
                completion(nil, nil)
                return
            }
            
            guard responseHttp.statusCode == 200 else {
                completion(nil, nil)
                return
            }
            
            let result: Record? = try? JSONDecoder().decode(Record.self, from: data)
            completion(result?.records, nil)
        }
        task.resume()
    }
    
    func deleteTask(withID taskID: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(url!)/\(taskID)") else {
            completion(nil) // Gérer l'erreur de construction de l'URL
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }

            guard let responseHttp = response as? HTTPURLResponse, responseHttp.statusCode == 200 else {
                completion(NSError(domain: "TaskService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Task deletion failed."]))
                return
            }

            completion(error)
        }
        task.resume()
    }
}
