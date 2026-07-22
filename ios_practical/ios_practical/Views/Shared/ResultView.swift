import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    
    let mode: GameMode
    let score: Int
    let isNewHigh: Bool
    var onPlayAgain: () -> Void
    var onExit: () -> Void = {}
    
    private var shareText: String {
        "I just scored \(score) on \(mode.rawValue) — beat that!"
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Text("GAME OVER")
                .font(.largeTitle).bold()
                .foregroundColor(.red)
            
            ScoreBadge(mode: mode, score: score, isNewHigh: isNewHigh)
            
            VStack(spacing: 12) {
                Button(action: {
                    dismiss()
                    onPlayAgain()
                }) {
                    Text("Play Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                ShareLink(item: shareText) {
                    Label("Share Score", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    dismiss()
                    onExit()
                }) {
                    Text("Exit to Menu")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(40)
        .background(Color(red: 0.15, green: 0.17, blue: 0.22))
        .cornerRadius(20)
        .shadow(radius: 20)
        .padding(30)
    }
}
