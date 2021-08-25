//
//  ReposParser.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 13.08.2021.
//

import Foundation

class ReposParser: IParser {
    
    typealias Model = [Repos]?
    
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
