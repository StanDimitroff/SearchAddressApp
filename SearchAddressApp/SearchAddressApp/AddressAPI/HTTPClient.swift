//
//  HTTPClient.swift
//  SearchAddressApp
//
//  Created by Stanislav Dimitrov on 7.10.23.
//

import Foundation

final class HTTPClient {
  typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

  private let session: URLSession

  init(session: URLSession = .shared) {
    self.session = session
  }

  func get(from url: URL, completion: @escaping (Result) -> Void) {
    session.dataTask(with: url, completionHandler: { data, response, error in
      if let error {
        completion(.failure(error))
      } else if let data, let response = response as? HTTPURLResponse {
        completion(.success((data, response)))
      }
    }).resume()
  }
}
