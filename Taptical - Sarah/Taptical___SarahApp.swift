//___FILEHEADER___

import SwiftUI

@main
struct Taptical___Sarah: App {
    
    init() {
           AudioManager.shared.playBackgroundMusic()
       }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
