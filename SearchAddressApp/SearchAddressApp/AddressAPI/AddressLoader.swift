//
//  AddressLoader.swift
//  SearchAddressApp
//
//  Created by Stanislav Dimitrov on 7.10.23.
//

import Foundation

final class AddressLoader {
  enum Error: Swift.Error, LocalizedError {
    case connection
    case invalidData

    var errorDescription: String? {
      switch self {
      case .connection:
        return "It seems you are offline."
      case .invalidData:
        return "Data cannot be processed."
      }
    }
  }

  private let url: URL
  private let client: HTTPClient

  init(url: URL, client: HTTPClient) {
    self.url = url
    self.client = client
  }

  func load(completion: @escaping (Swift.Result<[Address], Error>) -> Void) {
    client.get(from: url) { result in
      switch result {
      case let .success((data, response)):
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
          completion(.failure(.invalidData))
          return
        }
        let addresses = root.addresses
        completion(.success(addresses.map { Address(id: $0.id, label: $0.label, latitude: $0.latitude, longitude: $0.longitude) }) )
      case .failure:
        completion(.failure(.connection))
      }
    }
  }
}

private struct Root: Decodable{
  let addresses: [RemoteAddress]

  enum CodingKeys: String, CodingKey {
    case addresses = "features"
  }
}
