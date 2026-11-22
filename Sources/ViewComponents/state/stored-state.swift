import SwiftUI

/// View-local state without the `@State` macro.
///
/// From the macOS 27 SDK on, `@State` is an attached macro (`SwiftUIMacros.StateMacro`) whose
/// plugin only ships with Xcode, so Command Line Tools builds fail with "plugin for module
/// 'SwiftUIMacros' not found". This wrapper stores a plain `State<Value>` value, which SwiftUI
/// still installs as a nested `DynamicProperty`, and builds on either toolchain.
@propertyWrapper
public struct StoredState<Value>: DynamicProperty {
    private let storage: State<Value>

    public init(wrappedValue: Value) {
        self.storage = State(initialValue: wrappedValue)
    }

    public init(initialValue: Value) {
        self.storage = State(initialValue: initialValue)
    }

    public var wrappedValue: Value {
        get { storage.wrappedValue }
        nonmutating set { storage.wrappedValue = newValue }
    }

    public var projectedValue: Binding<Value> {
        storage.projectedValue
    }
}

public extension StoredState where Value: ExpressibleByNilLiteral {
    init() {
        self.init(wrappedValue: nil)
    }
}
