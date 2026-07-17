import SwiftUI

enum LightUpLevel: Int, CaseIterable {
    case L1 = 1
    case L2 = 2
    case L3 = 3
    case L4 = 4

    /// Elapsed-time window (in seconds) during which this level is active
    var durationRange: Range<TimeInterval> {
        switch self {
        case .L1: return 0..<15
        case .L2: return 15..<35
        case .L3: return 35..<60
        case .L4: return 60..<TimeInterval.greatestFiniteMagnitude
        }
    }

    var cardCount: Int {
        switch self {
        case .L1: return 6
        case .L2: return 9
        case .L3: return 12
        case .L4: return 16
        }
    }

    var concurrentLitCards: Int {
        switch self {
        case .L1: return 1
        case .L2: return 2
        case .L3: return 2
        case .L4: return 3
        }
    }

    var litDuration: TimeInterval {
        switch self {
        case .L1: return 1.2
        case .L2: return 1.0
        case .L3: return 0.8
        case .L4: return 0.6
        }
    }

    var glowColor: Color {
        switch self {
        case .L1: return .blue
        case .L2: return .green
        case .L3: return .orange
        case .L4: return .red
        }
    }

    var columns: [GridItem] {
        let count = (self == .L1 || self == .L2) ? 3 : 4
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }
}
