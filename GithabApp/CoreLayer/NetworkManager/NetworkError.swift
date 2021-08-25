//
//  NetworkError.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

enum NetworkError: Error {
    case badData, badURL, badResponse, noResponse, notModel, badRequest
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badData:
            return NSLocalizedString("Error: Bad data", comment: "")
        case .badResponse:
            return NSLocalizedString("Error: This response status code > 200", comment: "")
        case .badURL:
            return NSLocalizedString("Error: This url non valid", comment: "")
        case .notModel:
            return NSLocalizedString("Error: Data does not match model", comment: "")
        case .badRequest:
            return NSLocalizedString("Error: Bad request", comment: "")
        case .noResponse:
            return NSLocalizedString("No response received from the server", comment: "")
        }
    }
}
