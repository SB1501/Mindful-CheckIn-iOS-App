import SwiftUI

struct AbstractBackgroundView: View {
    let colors: [Color]
    let circleCount: Int
    let blurRadius: CGFloat
    let seed: UInt64

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct BlobSpec: Identifiable {
        let id = UUID()
        let color: Color
        let sizeScale: CGFloat   // fraction of the shortest side
        let phaseX: Double
        let phaseY: Double
        let speedX: Double
        let speedY: Double
    }

    @State private var specs: [BlobSpec] = []

    init(colors: [Color] = [Color.red, Color.blue, Color.green, Color.orange],
         circleCount: Int = 4,
         blurRadius: CGFloat = 80,
         seed: UInt64 = 1) {
        self.colors = colors
        self.circleCount = max(1, circleCount)
        self.blurRadius = blurRadius
        self.seed = seed
        // specs are initialized in onAppear using the provided seed
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let t = timeline.date.timeIntervalSinceReferenceDate

                context.addFilter(.blur(radius: blurRadius))
                context.opacity = 0.9

                for spec in specs {
                    let motionFactor = reduceMotion ? 0.0 : 1.0
                    let cx = size.width  * (0.5 + 0.45 * sin(spec.phaseX + t * spec.speedX * motionFactor))
                    let cy = size.height * (0.5 + 0.45 * cos(spec.phaseY + t * spec.speedY * motionFactor))
                    let r = min(size.width, size.height) * spec.sizeScale

                    var path = Path()
                    path.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))

                    let gradient = Gradient(stops: [
                        .init(color: spec.color.opacity(0.7), location: 0.0),
                        .init(color: spec.color.opacity(0.0), location: 1.0)
                    ])
                    let shading = GraphicsContext.Shading.radialGradient(
                        gradient,
                        center: CGPoint(x: cx, y: cy),
                        startRadius: 0,
                        endRadius: r
                    )
                    context.fill(path, with: shading)
                }
            }
            .drawingGroup()
        }
        .onAppear {
            if specs.isEmpty { specs = makeSpecs(seed: seed) }
        }
        .ignoresSafeArea()
    }

    private func makeSpecs(seed: UInt64) -> [BlobSpec] {
        var rng = LCG(seed: seed)
        var specs: [BlobSpec] = []
        for i in 0..<circleCount {
            let baseColor = colors.indices.contains(i) ? colors[i] : colors[i % max(colors.count, 1)]
            let adjusted = baseColor // use the provided color palette directly
            let sizeScale = CGFloat(0.18 + rng.nextUnit() * 0.18) // 18% - 36% of shortest side
            let phaseX = rng.nextUnit() * .pi * 2
            let phaseY = rng.nextUnit() * .pi * 2
            let speedX = 0.08 + rng.nextUnit() * 0.08 // 0.08 - 0.16
            let speedY = 0.08 + rng.nextUnit() * 0.08 // 0.08 - 0.16
            specs.append(BlobSpec(color: adjusted, sizeScale: sizeScale, phaseX: phaseX, phaseY: phaseY, speedX: speedX, speedY: speedY))
        }
        return specs
    }
}

// Simple deterministic PRNG for reproducible layouts
private struct LCG {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed &* 6364136223846793005 &+ 1 }
    mutating func next() -> UInt64 {
        state = 2862933555777941757 &* state &+ 3037000493
        return state
    }
    mutating func nextUnit() -> Double {
        Double(next()) / Double(UInt64.max)
    }
}

