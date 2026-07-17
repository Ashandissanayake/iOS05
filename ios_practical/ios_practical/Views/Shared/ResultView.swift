import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) var dismiss
    let mode: GameMode
    let score: Int
    let isNewHigh: Bool
    let restartAction: () -> Void
    
    // One line ShareLink content template string as explicitly requested in requirements
    var shareText: String {
        "I just scored \(score) points playing \(mode.rawValue) on PlayHub! Beat that score if you can!"
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Game Over").font(.system(size: 45, weight: .black)).foregroundColor(.red)
            
            VStack(spacing: 10) {
                Text("Final Compiled Score").font(.headline).foregroundColor(.secondary)
                Text("\(score)")
                    .font(.system(size: 80, weight: .heavy, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            if isNewHigh {
                Text("🎉 NEW MODE HIGH RECORD!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
            }
            
            Spacer()
            
            // Native ShareLink initialization engine layout
            ShareLink(item: shareText) {
                Label("Share Score Metrics", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Button(action: {
                dismiss()
                restartAction()
            }) {
                Text("Play Again Loop")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Button("Return to Home Core Shell") {
                dismiss()
            }
            .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
    }
}
