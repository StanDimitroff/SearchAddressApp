//
//  ContentView.swift
//  SearchAddressApp
//
//  Created by Stanislav Dimitrov on 7.10.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      AddressesListView(model: .init(loader: AddressLoader(url: URL(string: "https://api-adresse.data.gouv.fr/search/")!, client: .init())))
    }
}

#Preview {
    ContentView()
}
