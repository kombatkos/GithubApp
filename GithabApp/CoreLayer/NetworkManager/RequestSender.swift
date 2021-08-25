//
//  RequestSender.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

class RequestSender: NSObject, IRequestSender {
    
    private var session = URLSession(configuration: URLSessionConfiguration.default)
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model, Error>) -> Void) where Parser: IParser {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(NetworkError.badRequest))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            } else if let response = response as? HTTPURLResponse {
                
                guard response.statusCode == 200 else {
                    completionHandler(.failure(NetworkError.badResponse))
                    return }
    
                guard let data = data,
                      let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(.failure(NetworkError.notModel))
                    return
                }
                completionHandler(.success(parsedModel))
            } else {
                completionHandler(.failure(NetworkError.noResponse))
            }
        }
        
        task.resume()
    }
    
    func send(request: IRequest?, delegate: NSObject, completionHandler: @escaping (Error?) -> Void) {
        guard let urlRequest = request?.urlRequest else {
            completionHandler(NetworkError.badRequest)
            return
        }
        guard let delegate = delegate as? URLSessionDownloadDelegate else { return }
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())
        let task2 = session.downloadTask(with: urlRequest)
        task2.resume()
    }
    
}
