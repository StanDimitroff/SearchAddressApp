//
//  AddressesModel.swift
//  SearchAddressApp
//
//  Created by Stanislav Dimitrov on 7.10.23.
//

import Foundation

final class AddressesModel: ObservableObject {

  private let loader: AddressLoader

  @Published public private(set) var addresses = [Address]()
  @Published public private(set) var loadError: AddressLoader.Error?

  init(loader: AddressLoader) {
    self.loader = loader
  }

  func loadAddresses(matching addressName: String = "") {
    var items = [URLQueryItem]()

    items.append(.init(name: "q", value: addressName))
    items.append(.init(name: "type", value: "housenumber"))

    loader.load(query: items) { [weak self] result in
      guard let self else { return }

      DispatchQueue.main.async {
        switch result {
        case let .success(addresses):
          self.addresses = addresses
        case let .failure(error):
          self.loadError = error
        }
      }
    }
  }
}
