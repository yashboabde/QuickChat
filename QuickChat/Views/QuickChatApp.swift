import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct QuickChatApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // ✅ Declare state variable here
    @State private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            SignupView(isLoggedIn: $isLoggedIn) // ✅ Pass binding
        }
    }
}

