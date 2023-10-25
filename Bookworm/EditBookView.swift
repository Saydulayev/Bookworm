//
//  EditBookView.swift
//  Bookworm
//
//  Created by Akhmed on 25.10.23.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var book: Book

    // Состояние для полей редактирования
    @State private var updatedTitle: String = ""
    @State private var updatedAuthor: String = ""
    @State private var updatedReview: String = ""
    @State private var selectedGenre: String = ""
    @State private var updatedRating: Int = 1

    // Список жанров
    let genres = ["Антиутопия", "Биография", "Детектив", "Детская литература", "Драма", "Исторический роман", "Классика", "Магический реализм", "Научная фантастика", "Научно-популярное", "Поэзия", "Приключения", "Религиозная литература", "Роман", "Триллер", "Ужасы", "Фантастика", "Философия", "Фэнтези", "Эзотерика", "Другое"]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Название книги", text: $updatedTitle)
                    TextField("Автор", text: $updatedAuthor)

                    // Выпадающий список для жанров
                    Picker("Жанр", selection: $selectedGenre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("Отзыв", text: $updatedReview)
                }

                Section(header: Text("Рейтинг")) {
                    RatingView(rating: $updatedRating)
                        .font(.largeTitle)
                }

                Button("Сохранить") {
                    updateBook()
                }
            }
            .navigationTitle("Редактировать Книгу")
        }
        .onAppear(perform: loadBookData)
    }
    
    func loadBookData() {
        updatedTitle = book.title ?? ""
        updatedAuthor = book.author ?? ""
        selectedGenre = book.genre ?? "Фантастика"
        updatedReview = book.review ?? ""
        updatedRating = Int(book.rating)
    }
    
    func updateBook() {
        book.title = updatedTitle
        book.author = updatedAuthor
        book.genre = selectedGenre
        book.review = updatedReview
        book.rating = Int16(updatedRating)

        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
}
