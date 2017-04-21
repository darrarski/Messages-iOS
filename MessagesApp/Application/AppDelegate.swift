import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let messagesService = DemoMessagesService()
        let messagesViewController = MessagesViewController(messagesService: messagesService)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = messagesViewController
        window?.makeKeyAndVisible()
        return true
    }

}
