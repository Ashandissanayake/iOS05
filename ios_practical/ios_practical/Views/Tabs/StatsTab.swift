import SwiftUI
import Charts

struct StatsTab: View {
    @EnvironmentObject var statsVM: StatsVM
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.08, blue: 0.12)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Overall totals
                        HStack(spacing: 16) {
                            StatSummaryCard(title: "Games Played", value: "\(statsVM.totalGamesPlayedAllModes)")
                            StatSummaryCard(title: "Avg Score", value: String(format: "%.0f", statsVM.averageScoreAllModes))
                        }
                        .padding(.horizontal)
                        
                        // Personal bests
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Personal Bests")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ForEach(GameMode.allCases) { mode in
                                HStack {
                                    Label(mode.rawValue, systemImage: mode.iconName)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(statsVM.personalBest(for: mode))")
                                        .bold()
                                        .foregroundColor(mode.accentColor)
                                }
                                .padding()
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Per-mode chart
                        ForEach(GameMode.allCases) { mode in
                            let modeSessions = statsVM.sessions(for: mode)
                            if !modeSessions.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("\(mode.rawValue) — Score History")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Chart {
                                        ForEach(Array(modeSessions.reversed().enumerated()), id: \.element.id) { index, session in
                                            BarMark(
                                                x: .value("Game", index + 1),
                                                y: .value("Score", session.score)
                                            )
                                            .foregroundStyle(mode.accentColor.gradient)
                                        }
                                    }
                                    .frame(height: 160)
                                    .padding()
                                    .background(Color.white.opacity(0.06))
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Recent games list
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Games")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if statsVM.recentSessions.isEmpty {
                                Text("No games played yet.")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(statsVM.recentSessions) { session in
                                    HStack {
                                        Image(systemName: session.mode.iconName)
                                            .foregroundColor(session.mode.accentColor)
                                        VStack(alignment: .leading) {
                                            Text(session.mode.rawValue)
                                                .foregroundColor(.white)
                                            Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text("\(session.score)")
                                            .bold()
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.06))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Stats")
        }
    }
}

struct StatSummaryCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title).bold()
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.06))
        .cornerRadius(14)
    }
}
