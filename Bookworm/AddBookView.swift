//
//  AddBookView.swift
//  Bookworm
//
//  Created by Akhmed on 11.10.23.
//



    
    import SwiftUI

    struct AddBookView: View {
        @Environment(\.managedObjectContext) var moc
        @Environment(\.dismiss) var dismiss

        @State private var title = ""
        @State private var author = ""
        @State private var rating = 3
        @State private var genre = ""
        @State private var review = ""

        let genres = ["Антиутопия", "Биография", "Детектив", "Детская литература", "Драма", "Исторический роман", "Классика", "Магический реализм", "Научная фантастика", "Научно-популярное", "Поэзия", "Приключения", "Религиозная литература", "Роман", "Триллер", "Ужасы", "Фантастика", "Философия", "Фэнтези", "Эзотерика", "Другое"]

        var body: some View {
            NavigationView {
                Form {
                    Section {
                        TextField("Name of book", text: $title)
                        TextField("Author's name", text: $author)

                        Picker("Genre", selection: $genre) {
                            ForEach(genres, id: \.self) {
                                Text($0)
                            }
                        }
                    }

                    Section {
                        TextEditor(text: $review)
                        RatingView(rating: $rating)
                    } header: {
                        Text("Write a review")
                    }

                    Section {
                        Button("Save") {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.rating = Int16(rating)
                            newBook.review = review
                            newBook.genre = genre
                            newBook.date = Date()

                            try? moc.save()
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Add Book")
            }
        }
    }

#Preview {
    AddBookView()
}
