import Foundation
import Combine
import SwiftUI

public struct EditableText: View {
    @StateObject private var controller: EditableTextController
    @FocusState private var fieldIsFocused: Bool
    
    public init(text: String) {
        _controller = StateObject(wrappedValue: EditableTextController(text: text))
    }

    public init(controller: EditableTextController) {
        _controller = StateObject(wrappedValue: controller)
    }

    public var body: some View {
        Group {
            if controller.isEditing {
                TextField(
                    "", 
                    text: $controller.text, 
                    onCommit: {
                        controller.isEditing = false
                    }
                )
                .focused($fieldIsFocused)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                    fieldIsFocused = true
                }
            } else {
                Text(controller.text)
                .onTapGesture {
                    controller.isEditing = true
                }
            }
        }
        .animation(.default, value: controller.isEditing)
    }
}
