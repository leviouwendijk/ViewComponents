import Foundation
import SwiftUI

public struct ControlledNotificationBanner: View {
    @ObservedObject public var controller: NotificationBannerController

    public init(
        controller: NotificationBannerController
    ) {
        self._controller = ObservedObject(wrappedValue: controller)
    }

    public var body: some View {
        NotificationBanner(
            type: controller.style,
            message: controller.message
        )
        .hide(when: controller.hide)
    }
}
