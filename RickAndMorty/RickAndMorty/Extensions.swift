//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/29/24.
//

import UIKit
import Combine

extension UISearchTextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UISearchTextField)?.text ?? "" }
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
