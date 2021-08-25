//
//  AuthorizationParser.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 18.08.2021.
//

import Foundation

class AuthorizationParser: IParser {
    
    typealias Model = Token
    
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
