import SwiftUI
import CoreLocation

struct QuizRushView: View {
    @StateObject private var viewModel = QuizRushVM()
    @EnvironmentObject var statsVM: StatsVM
    @EnvironmentObject var locationService: LocationService
    @AppStorage("quiz_rush_high") var highScore = 0
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Fetching OpenTriviaDB Payload Bundle...")
                    .scaleEffect(1.5)
            case .failed:
                VStack(spacing: 20) {
                    Image(systemName: "wifi.exclamationmark").font(.system(size: 50)).foregroundColor(.red)
                    Text("Network failure or API timeout standard exception loop.").font(.headline)
                    Button("Retry Handshake Connect") {
                        Task { await viewModel.loadQuestions() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            case .loaded(let questions):
                let currentQuestion = questions[viewModel.currentIndex]
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Question \(viewModel.currentIndex + 1) of 10").font(.subheadline)
                        Spacer()
                        Text("Streak: 🔥 \(viewModel.streak)").font(.subheadline).foregroundColor(.orange)
                    }
                    .padding()
                    
                    ProgressView(value: Double(viewModel.currentIndex + 1), total: 10)
                        .padding(.horizontal)
                    
                    Text("Current Score: \(viewModel.score)").font(.title2).bold()
                    
                    Spacer()
                    
                    Text(currentQuestion.question)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(15)
                        .padding()
                    
                    VStack(spacing: 12) {
                        ForEach(viewModel.shuffledAnswers, id: \.self) { ans in
                            Button(action: {
                                withAnimation {
                                    viewModel.submitAnswer(ans, currentQuestions: questions)
                                }
                            }) {
                                Text(ans)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple.opacity(0.15))
                                    .foregroundColor(.purple)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.purple, lineWidth: 2)
                                    )
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.loadQuestions()
        }
        .sheet(isPresented: $viewModel.isGameOver) {
            if case .loaded(let questions) = viewModel.state {
                ResultView(
                    mode: .quizRush,
                    score: viewModel.score,
                    isNewHigh: viewModel.score > highScore,
                    restartAction: {
                        Task { await viewModel.loadQuestions() }
                    }
                )
                .onAppear {
                    if viewModel.score > highScore { highScore = viewModel.score }
                    let lat = locationService.lastLocation?.coordinate.latitude ?? 6.9271
                    let lon = locationService.lastLocation?.coordinate.longitude ?? 79.8612
                    statsVM.saveSession(mode: .quizRush, score: viewModel.score, lat: lat, lon: lon)
                }
            }
        }
    }
}
