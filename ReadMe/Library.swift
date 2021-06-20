//
//  Library.swift
//  ReadMe
//
//  Created by bogdanov on 16.06.21.
//

import Combine
import class UIKit.UIImage

enum Section {
    case readMe
    case finished
}

final class Library: ObservableObject {
    var sortedBooks: [Book] { booksCache }

    var manuallySortedBooks: [Section: [Book]] {
        Dictionary(grouping: booksCache, by: \.readMe)
            .mapKeys(Section.init)
    }

    /// Add a new book at the start of the library's manually-sorted books.
    func addNewBook(_ book: Book, image: UIImage?) {
        booksCache.insert(book, at: 0)
        uiImages[book] = image
    }

    @Published var uiImages: [Book: UIImage] = [:]

    @Published private var booksCache: [Book] = [
        .init(title: "War and Peace", author: "Leo Tolstoy", microReview: "describes oak on 5 pages"),
        .init(title: "Anna Karenina", author: "Leo Tolstoy"),
        .init(title: "Crime and Punishment", author: "Fyodor Dostoevsky"),
        .init(title: "The Master and Margarita", author: "Mikhail Bulgakov", microReview: "my favourite"),
        .init(title: "Life and Fate", author: "Vasily Grossman"),
        .init(title: "The Brothers Karamazov and Magic Sword", author: "Fyodor Dostoevsky"),
        .init(title: "Dead Souls", author: "Nikolai Gogol"),
        .init(title: "Eugene Onegin", author: "Aleksandr Pushkin"),
        .init(title: "Lolita", author: "Vladimir Nabokov"),
        .init(title: "Doctor Zhivago", author: "Boris Pasternak")
    ]
}

// MARK: - private

private extension Section {
    init(readMe: Bool) {
        self = readMe ? .readMe : .finished
    }
}

private extension Dictionary {
    /// Same values, corresponding to `map`ped keys.
    ///
    /// - Parameter transform: Accepts each key of the dictionary as its parameter
    ///   and returns a key for the new dictionary.
    /// - Postcondition: The collection of transformed keys must not contain duplicates.
    func mapKeys<Transformed>(_ transform: (Key) throws -> Transformed) rethrows -> [Transformed: Value] {
        .init(uniqueKeysWithValues: try map { (try transform($0.key), $0.value) })
    }
}
