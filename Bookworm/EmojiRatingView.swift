//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Akhmed on 11.10.23.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16

    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(ratingColor(for: Int(rating)))

                VStack {
                    switch rating {
                    case 1:
                        Text("1")
                    case 2:
                        Text("2")
                    case 3:
                        Text("3")
                    case 4:
                        Text("4")
                    default:
                        Text("5")
                    }

                    // Добавляем смайлики звезды под каждой цифрой рейтинга
                    
                }
            }
            Text(String(repeating: "⭐️", count: Int(rating)))
                .font(.system(size: 7))
        }
    }

    func ratingColor(for rating: Int) -> Color {
        switch rating {
        case 1:
            return .red
        case 2:
            return .orange
        case 3:
            return .yellow
        case 4:
            return .init(#colorLiteral(red: 0.774243772, green: 1, blue: 0, alpha: 1))
        default:
            return . green
        }
    }
}

#Preview {
    EmojiRatingView(rating: 3)
}
