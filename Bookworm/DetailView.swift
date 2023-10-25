//
//  DetailView.swift
//  Bookworm
//
//  Created by Akhmed on 11.10.23.
//

import SwiftUI
import CoreData


struct DetailView: View {
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    @State private var isToolbarHidden = false
    @State private var showingEditScreen = false
    
    @Binding var isInterfaceHidden: Bool
    
    
    
    
    
    // DateFormatter для форматирования даты
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            Text(book.title ?? "Unknown Book")
                .font(.title).bold()
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? .black : .white)
                        .shadow(color: .yellow, radius: 3, x: 0, y: 0)
                )
                .padding(.vertical)
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Фантастика")
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                //                    .overlay(Capsule().stroke(Color.yellow, lineWidth: 1))
                    .offset(x: -5, y: -5)
            }
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)
            
            if let date = book.date {
                Text("Добавлено: \(formatter.string(from: date))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
            
            Text(book.review ?? "No review")
                .padding()
            
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        //        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isInterfaceHidden)
        .alert("Удалить книгу", isPresented: $showingDeleteAlert) {
            Button("Удалить", role: .destructive, action: deleteBook)
            Button("Отменить", role: .cancel) { }
        } message: {
            Text("Вы уверены?")
        }
        .toolbar {
            if !isToolbarHidden && !isInterfaceHidden {
                HStack {
                    Button(action: shareScreenshot) {
                        Label("Share this view", systemImage: "square.and.arrow.up")
                    }
                    Button(action: { showingEditScreen.toggle() }) {
                            Label("Редактировать книгу", systemImage: "pencil")
                        }
                    
                    Spacer()
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Label("Delete this book", systemImage: "trash")
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditScreen) {
            // Передача текущей книги в качестве параметра, чтобы убедиться, что мы редактируем правильный объект
            EditBookView(book: book)
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        try? moc.save()
        dismiss()
    }
    func shareBook() {
        let text = "\(book.title ?? "Unknown Title") by \(book.author ?? "Unknown Author"): \(book.review ?? "No review")"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(av, animated: true, completion: nil)
        }
    }
    func captureScreenshot() -> UIImage? {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.screenshot()
        }
        return nil
    }
    func shareScreenshot() {
        isToolbarHidden = true
        isInterfaceHidden = true
        
        // Добавьте небольшую задержку, чтобы дать SwiftUI время на обновление представления
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let image = captureScreenshot() else {
                // Если не удалось захватить скриншот, не забудьте снова показать интерфейс.
                self.isToolbarHidden = false
                self.isInterfaceHidden = false
                return
            }
            
            let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            av.completionWithItemsHandler = { (_, _, _, _) in
                // Этот блок вызывается после того, как пользователь закончил взаимодействие с UIActivityViewController.
                // Возвращаем тулбар и интерфейс обратно после того, как окно для деления закрыто
                self.isToolbarHidden = false
                self.isInterfaceHidden = false
            }
            
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(av, animated: true, completion: nil)
            }
        }
    }
}


extension UIWindow {
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
