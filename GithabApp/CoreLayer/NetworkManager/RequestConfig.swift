//
//  RequestConfig.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model, Error>) -> Void)
    func send(request: IRequest?, delegate: NSObject, completionHandler: @escaping (Error?) -> Void)
}
