//
//  SearchBar.swift
//  Bookworm
//
//  Created by Akhmed on 15.10.23.
//

import SwiftUI


struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search...", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Button(action: {
                isSearching = false
                text = ""
            }) {
                Text("Отмена")
            }
            .padding(.horizontal, 10)
        }
        .padding(.horizontal, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
