import SwiftUI
import Charts

struct StatsTab: View {
    @EnvironmentObject var statsVM: StatsVM
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    if statsVM.sessions.isEmpty {
                        ContentUnavailableView("No Data Recorded", systemImage: "chart.bar.xaxis", description: Text("Complete some rounds to aggregate dashboard charts."))
                            .padding(.top, 100)
                    } else {
                        // High score records block
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Personal Bests").font(.title2).bold()
                            
                            ForEach(GameMode.allCases) { mode in
                                HStack {
                                    Label(mode.rawValue, systemImage: mode.iconName)
                                    Spacer()
                                    Text("\(statsVM.personalBest(for: mode)) Pts").bold()
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Performance over time metrics charts
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Session Performance Progression").font(.title2).bold()
                            
                            Chart(statsVM.sessions) { session in
                                BarMark(
                                    x: .value("Date", session.timestamp, unit: .minute),
                                    y: .value("Score", session.score)
                                )
                                .foregroundStyle(by: .value("Game Mode", session.mode.rawValue))
                            }
                            .frame(height: 250)
                            .padding()
                        }
                        
                        // Feed display of historical activity logs
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Recent Games Log").font(.title2).bold()
                            
                            ForEach(statsVM.sessions.reversed().prefix(5)) { session in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(session.mode.rawValue).font(.headline)
                                        Text(session.timestamp.formatted(date: .numeric, time: .shortened))
                                            .font(.caption).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(session.score)").font(.title3).bold()
                                }
                                .padding(.vertical, 8)
                                Divider()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Analytics & Stats")
        }
    }
}
