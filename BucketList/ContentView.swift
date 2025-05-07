//
//  ContentView.swift
//  BucketList
//
//  Created by Zoltan Vegh on 06/05/2025.
//

import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false
        
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked!")
            } else {
                Button("Unlock") {
                }
            }
        }
        .onAppear(perform: authenthicate)
    }
    
    func authenthicate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
}

#Preview {
    ContentView()
}
