//
//  GithubParser.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

class UserParser: IParser {
    
    typealias Model = Users
    
    func parse(data: Data) -> Model? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Model.self, from: data)
        } catch {
            print(NetworkError.notModel.localizedDescription)
            return nil
        }
    }
}
