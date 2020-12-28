//
//  SearchNavigation.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/28/20.
//

import SwiftUI

// originated from https://medium.com/@yugantarjain/implement-native-search-bar-in-swiftui-664a6b944538
struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var content: () -> Content

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true

        context.coordinator.searchController.searchBar.delegate = context.coordinator

        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text)
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)

        init(content: Content, searchText: Binding<String>) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController

            _text = searchText
        }

        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
        }
    }
}
