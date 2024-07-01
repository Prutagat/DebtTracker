//
//  UserSearchView.swift
//  DebtTracker
//
//  Created by Алексей Голованов on 30.06.2024.
//

import SwiftUI

struct UserSearchView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedUser: Profile?
    @Binding var isPresented: Bool
    
    @State private var searchQuery: String = ""
    @State private var searchResults: [Profile] = []
    @State private var searchByEmail: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchQuery)
                    .customTextFieldStyle()
                    .onChange(of: searchQuery) { _, newValue in
                        searchUsers()
                    }
                
                Picker("Search by", selection: $searchByEmail) {
                    Text("Email").tag(true)
                    Text("Name").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: searchByEmail) { _, _ in
                    searchUsers()
                }
                
                List(searchResults, id: \.id) { profile in
                    Button(action: {
                        selectedUser = profile
                        isPresented = false
                    }) {
                        let preview
                        = searchByEmail ? "\(profile.email) (\(profile.name))" : "\(profile.name) (\(profile.email))"
                        Text(preview)
                    }
                }
            }
            .navigationBarTitle("Search borrower", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
    
    func searchUsers() {
        guard !searchQuery.isEmpty else {
            searchResults = []
            return
        }
        
        let searchMethod
            = searchByEmail ? appState.userService.search(byEmailPart:completion:) : appState.userService.search(byNamePart:completion:)
        
        let textSearch = searchByEmail ? searchQuery.lowercased() : searchQuery
        
        searchMethod(textSearch) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    searchResults = users
                case .failure(let error):
                    appState.showAlert(with: error.localizedDescription)
                }
            }
        }
    }
}
