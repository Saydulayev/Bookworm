//
//  ContentView.swift
//  Bookworm
//
//  Created by Akhmed on 05.10.23.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.date, ascending: true),
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    @State private var isSearching = false
    @State private var searchText: String = ""
    @State private var isInterfaceHidden = false

    
    @State private var isEditMode: EditMode = .inactive
    
    
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return Array(books)
        } else {
            return books.filter { $0.title?.lowercased().contains(searchText.lowercased()) == true || $0.author?.lowercased().contains(searchText.lowercased()) == true }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredBooks) { book in
                    NavigationLink(destination: DetailView(book: book, isInterfaceHidden: $isInterfaceHidden)) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                                Text(book.genre ?? "Unknown Genre")
                                    .foregroundColor(.gray)
                                
                                if book.genre == nil || book.genre == "Unknown Genre" {
                                    Image("default_genre")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
                .onMove(perform: move)
            }
            .navigationBarTitle(isInterfaceHidden ? "" : "Книжный червь")
            .environment(\.editMode, $isEditMode)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation {
                            isEditMode = isEditMode == .active ? .inactive : .active
                        }
                    }) {
                        Text(isEditMode == .active ? "Готово" : "Изменить")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        if isSearching {
                            SearchBar(text: $searchText, isSearching: $isSearching)
                        } else {
                            Button(action: {
                                isSearching = true
                            }) {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                        
                        Button(action: {
                            showingAddScreen.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen, content: {
                AddBookView()
            })
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var booksArray = Array(books)
        booksArray.move(fromOffsets: source, toOffset: destination)
        
        var reorderDate = Date()
        for book in booksArray {
            book.date = reorderDate
            reorderDate = Calendar.current.date(byAdding: .second, value: 1, to: reorderDate) ?? Date()
        }
        try? moc.save()
    }
}




extension Book {
    var bookTitle: String {
        title ?? "Unknown Title"
    }
    
    var bookAuthor: String {
        author ?? "Unknown Author"
    }
    
    var bookGenre: String {
        genre ?? "Unknown Genre"
    }
}


#Preview {
    ContentView()
}
