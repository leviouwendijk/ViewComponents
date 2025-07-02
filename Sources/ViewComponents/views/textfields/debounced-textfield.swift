import SwiftUI

struct DebouncedField: View {
    let label: String
    let placeholder: String
    @State private var buffer: String
    let ms: Int
    let onCommit: (String) -> Void

    @State private var workItem: DispatchWorkItem?

    init(
        label: String,
        text: String,
        placeholder: String = "",
        debounce ms: Int = 150,
        onCommit: @escaping (String) -> Void
    ) {
        self.label       = label
        self.placeholder = placeholder
        self.ms          = ms
        self.onCommit    = onCommit
        self._buffer     = State(initialValue: text)
    }

    var body: some View {
        StandardTextField(label, text: $buffer, placeholder: placeholder)
        .onChange(of: buffer) { newValue in
            workItem?.cancel()

            let task = DispatchWorkItem {
                onCommit(newValue)
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(ms), execute: task)
        }
    }
}
