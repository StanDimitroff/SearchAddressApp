//
//  AddressesListView.swift
//  SearchAddressApp
//
//  Created by Stanislav Dimitrov on 7.10.23.
//

import SwiftUI

struct AddressesListView: View {

  @ObservedObject private var model: AddressesModel

  @State private var searchKeyword: String = ""
  @State private var alertPresented: Bool = false

  init(model: AddressesModel) {
    self.model = model
  }

  var body: some View {
    NavigationView {
      List {
        ForEach(model.addresses, id: \.id) { address in
          AddressRow(text: address.label)
        }
      }
      .listStyle(.plain)
      .refreshable {
        model.loadAddresses()
      }
      .searchable(text: $searchKeyword)
      .alert(isPresented: $alertPresented, error: model.loadError, actions: {
        Text("OK")
      })
      .navigationTitle(Text("Address Search"))
      .navigationBarTitleDisplayMode(.inline)
      .onChange(of: searchKeyword) { newValue in
        model.loadAddresses(matching: newValue)
      }
      .onChange(of: model.loadError) { error in
        if error != nil {
          alertPresented.toggle()
        }
      }
    }
  }
}

private struct AddressRow: View {
  let text: String

  var body: some View {
    HStack {
      Text(text)
    }
  }
}

