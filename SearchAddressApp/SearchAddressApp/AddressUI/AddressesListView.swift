//
//  AddressesListView.swift
//  SearchAddressApp
//
//  Created by Stanislav Dimitrov on 7.10.23.
//

import SwiftUI
import MapKit

struct AddressesListView: View {

  @ObservedObject private var model: AddressesModel

  @State private var searchKeyword: String = ""
  @State private var alertPresented: Bool = false

  @State var region = MKCoordinateRegion()

  @State var mapPresented = false

  init(model: AddressesModel) {
    self.model = model
  }

  var body: some View {
    NavigationView {
      List {
        ForEach(model.addresses, id: \.id) { address in
          AddressRow(text: address.label)
            .onTapGesture {
              region = .init(center: .init(latitude: address.latitude, longitude: address.longitude), span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2))
              mapPresented.toggle()
            }
        }
      }
      .listStyle(.plain)
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
      .sheet(isPresented: $mapPresented) {
        Map(coordinateRegion: $region, interactionModes: .pan)
          .edgesIgnoringSafeArea(.all)
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

