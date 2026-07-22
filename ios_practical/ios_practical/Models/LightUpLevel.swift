import SwiftUI

enum LightUpLevel: Int, CaseIterable {
    case L1 = 1
    case L2 = 2
    case L3 = 3
    case L4 = 4

    /// Elapsed-time window (seconds) this level is active for.
    /// L1: 0–15s · L2: 15–30s · L3: 30–45s · L4: 45s–end
    var durationRange: Range<TimeInterval> {
        switch self {
        case .L1: return 0..<15
        case .L2: return 15..<30
        case .L3: return 30..<45
        case .L4: return 45..<TimeInterval.greatestFiniteMagnitude
        }
    }

    /// Number of cards on the grid at this level.
    /// L1: 3 (row) · L2: 4 · L3: 6 (2×3) · L4: 9 (3×3)
    var cardCount: Int {
        switch self {
        case .L1: return 3
        case .L2: return 4
        case .L3: return 6
        case .L4: return 9
        }
    }

    /// How long a lit card stays lit before it goes dark.
    var litDuration: TimeInterval {
        switch self {
        case .L1: return 1.5
        case .L2: return 1.2
        case .L3: return 1.0
        case .L4: return 0.8
        }
    }

    /// How many cards are lit simultaneously. Only L4 lights 2 at once.
    var concurrentLitCards: Int {
        switch self {
        case .L1, .L2, .L3: return 1
        case .L4: return 2
        }
    }

    /// Distinct glow colour per level, matching the level-progression slide.
    var glowColor: Color {
        switch self {
        case .L1: return .green
        case .L2: return .blue
        case .L3: return .yellow
        case .L4: return .red
        }
    }

    /// Grid column count. L1 = single row of 3. L3/L4 = 3 columns (2×3, 3×3).
    var columns: [GridItem] {
        let count: Int
        switch self {
        case .L1: count = 3
        case .L2: count = 2
        case .L3: count = 3
        case .L4: count = 3
        }
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }
}
