import SwiftUI

// originated from https://medium.com/@yugantarjain/implement-native-search-bar-in-swiftui-664a6b944538
struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var labelsOnly: Binding<Bool>?
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
        Coordinator(content: content(), searchText: $text, labelsOnly: labelsOnly)
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var _labelsOnly: Binding<Bool>?
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)

        private var toggled: Bool = false

      init(content: Content, searchText: Binding<String>, labelsOnly: Binding<Bool>?) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController

          _labelsOnly = labelsOnly
          if (_labelsOnly != nil) {
            searchController.searchBar.showsBookmarkButton = true
            searchController.searchBar.setImage(UIImage(systemName: "tag"), for: .bookmark, state: .normal)
          }

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

        func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
          toggled.toggle()

          let img = UIImage(systemName: toggled ? "tag.fill" : "tag")
          searchBar.setImage(img, for: .bookmark, state: .normal)
          
          if (_labelsOnly != nil) {
            _labelsOnly!.wrappedValue = toggled
          }
        }
    }
}
