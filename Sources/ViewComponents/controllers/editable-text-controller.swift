import SwiftUI
import Combine

public class EditableTextController: ObservableObject {
    @Published public var text: String
    @Published public var isEditing: Bool = false

    public init(text: String) {
        self.text = text
    }
}

