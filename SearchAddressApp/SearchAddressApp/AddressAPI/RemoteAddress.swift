//
//  RemoteAddress.swift
//  SearchAddressApp
//
//  Created by Stanislav Dimitrov on 7.10.23.
//

import Foundation

struct RemoteAddress: Decodable {
  let id: String
  let label: String
  let latitude: Double
  let longitude: Double

  private enum CodingKeys: CodingKey {
    case geometry
    case properties
  }

  private enum GeometryCodingKeys: CodingKey {
    case coordinates
  }

  private enum PropertiesCodingKeys: CodingKey {
    case id
    case label
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let geometry = try container.nestedContainer(keyedBy: GeometryCodingKeys.self, forKey: .geometry)
    let coordinates = try geometry.decode([Double].self, forKey: .coordinates)
    self.latitude = coordinates[0]
    self.longitude = coordinates[1]

    let properties = try container.nestedContainer(keyedBy: PropertiesCodingKeys.self, forKey: .properties)
    self.id = try properties.decode(String.self, forKey: .id)
    self.label = try properties.decode(String.self, forKey: .label)
  }
}
