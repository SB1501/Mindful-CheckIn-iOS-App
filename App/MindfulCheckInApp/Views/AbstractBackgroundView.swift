// SB MINDFUL CHECK IN BACKGROUND VIEW
// This is the math behind the floating blurred circles behind many views

import SwiftUI


struct AbstractBackgroundView: View { //declares a Swift struct, conforming to the View protocol - means it needs a body describing the UI
    let colors: [Color] //immuatable array of SwiftUI Colors used to tint / paint background blobs below
    let circleCount: Int //immutable integer for how many blobs to be generated
    let blurRadius: CGFloat //immutable floating point value scaled to the device controlling the blue intensity of blobs
    let seed: UInt64 //immutable 64-bit unsigned integer used to seed a random generator for reproducible blob positions and motion. A seed of 1 means the 'random' values are the same each time.

        //let means a constant, immutable means once created, not modifiable for the lifetime of each AbstractBackgroundView instance.
    
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion //Environment macro. If the system environment (device) has the accessibility setting reduce motion enabled, it tones down the view and disables animations within


    private struct BlobSpec: Identifiable { //this is a helper module, private reduces scope to just this class file. This describes ONE animated blob 'instance'. Identifiable means it can be used in SwiftUI lists and loops. Variables include:
        let id = UUID() //a unique identifier for each generated blob instance, must be included to conform to Identifiable
        let color: Color //the base colour of gradient of the blob instance
        let sizeScale: CGFloat //the blobs radius (centre to rim) as a fraction of the views shortest side ensuring they all fit within the device screen size since they're a fraction
        let phaseX: Double //initial horizontal offset and horizontal motion
        let phaseY: Double //initial vertical offset and vertical motion
        let speedX: Double //motion speed along X horizontal
        let speedY: Double //motion speed along Y vertical
    }

    
    
    
    @State private var specs: [BlobSpec] = [] //State property wrapper, the view owns and mutates this state and changes to it triggers the view to update. Private means it is restricted to this class file only. Var means it's a mutable variable, meaning it can be changed. specs is the name.
        //[BlobSpec] is a type, an array of 'BlobSpec' (the helper module above). The equals [] means initialise that to an empty array.

    
    //below is the initializer for the view. initialises each of its fields when one is called to be generated
    init(colors: [Color] = [Color(white: 0.2), Color(white: 0.35), Color(white: 0.5), Color(white: 0.7)], //initialise each of the fields defined up top in order, initial value for colors is a [Color] array (since it's a Color array type) is must be given this value, in this case, a grayscale colour.
         circleCount: Int = 4, //the number of circles, by default, 4
         blurRadius: CGFloat = 80, //specifying how blurred, 80% by default
         seed: UInt64 = 1) { //assigns a seed, default of 1
        //this {} marks the end of the parameters above. Below we now initialise these values to THIS instantiation of the object. These write to THIS instance structs properties. The right of equals is what we define above, the left of the equals is assigning it to this one off instance of the struct.
        self.colors = colors //assign the colour parameter to the stored property colors
        self.circleCount = max(1, circleCount) //ensure at least 1 circle, max one since we're initialising one instance
        self.blurRadius = blurRadius //assign blur radius to property
        self.seed = seed //assign seed to property
    }

    
    
    
    var body: some View { //a body is required for conformance to View, which returns the views UI on screen. some means View is an 'opaque' return type meaning this is a view but the exact concrete type is hidden from callers / consumers of the body. All they know is it's a View but not the type, keeping implementation details private. Basically hides the function signature but still compiles.

        TimelineView(.animation) { timeline in //this is a container thar re-renders content over time according to a schedule. The modifier .animation means  it updates in sync with the animation clock (for smooth motion)
            
            Canvas { context, size in //Canvas defines a low level drawing surface. This allows drawing using 'GraphicsContext' below, and takes in the size (below) of the available canvas (screen)
                
                let t = timeline.date.timeIntervalSinceReferenceDate //variable that gets the current time as seconds since a fixed reference data is specified. This drives time based animation such as a sine or cosine wave movement (further defined below)

                context.addFilter(.blur(radius: blurRadius)) //applies a blur filter to everything drawn after this point using the configured blurRadius we specified and initialised above
                context.opacity = 0.95 //sets global opacity to all drawings after this point to 95% allowing the background to subtly show through
                
                //START OF LOOP BODY
                for spec in specs { //for loop in a sequence, spec is the current BlobSpec object/item instantiation, specS is the ARRAY of four blobs to draw
 
                    let motionFactor = reduceMotion ? 0.0 : 1.0 //this is a constant (let), ternary to say if reduceMotion is on (@Environment macro at top of class) then disable movement by setting motion to zero, otherwise full motion, one.
                    
                    let cx = size.width  * (0.5 + 0.45 * sin(spec.phaseX + t * spec.speedX * motionFactor)) //cx is centre of the blob. size.width is the canvas width, 0.5+ centers around the middle of the width, + 0.45*sin oscilates around 45% using a sin wave pattern, spec.phaseX is the starting phase of the wave, t*spec.speedX is the time driven angular advance, scaled by speed and motion toggle (motionFactor)
                    let cy = size.height * (0.5 + 0.45 * cos(spec.phaseY + t * spec.speedY * motionFactor)) //this is the same as cx, but for y (vertical), but uses cosine and height instead of width
                    
                    let r = min(size.width, size.height) * spec.sizeScale //r is radius (centre to rim), min (based on the smallest size betwen the screen width and size available), * spec.sizeScale scales to a fraction of the screensize based on our sizeScale from BlobSpec.

                    var path = Path() //variable (mutable/changable) called path, an empty vector Path().
                    path.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)) //for path above, use Path()'s addEllipse function, CGRect adds an ellipse (a circle) inside a rectangle when width==height that fits inside the given rectangle, this one centres the circle at cx,cy, with a diameter of 2radius. the x: cx-r, y:cy-r means put the top left corner one radius up/left from the centre, width:r*2,height:r*2 makes it a circle of radius r. This defines the shape in the PATH only!

                    let gradient = Gradient(stops: [ //a constant, defines a gradient using Gradient(), stops are defined below, these are colour / position pairs...
                        .init(color: spec.color.opacity(0.85), location: 0.0), //opacity at the top (centre) is 0.85%, strong in the centre since its a circle...
                        .init(color: spec.color.opacity(0.0), location: 1.0) //fading to transparent edges...
                    ])
  
                    let shading = GraphicsContext.Shading.radialGradient( //builds a radial gradient shader centeredon the blob from 0 to r (radius), below:
                        gradient,
                        center: CGPoint(x: cx, y: cy),
                        startRadius: 0,
                        endRadius: r
                    )
                    context.fill(path, with: shading) //fills the circle using the radial gradient, context is defined up where Canvas starts - all of this so far under Canvas is on the drawing layer.
                } //END OF LOOP BODY
                
            }
            .drawingGroup() //render the Canvas (still in the Canvas above) off screen as a single composited layer. Renders off screen and composites it as one texture, better performance for blurs, ensuring all of it applies to the whole group consistently, just changes how much is rendered until the result is composed completely.
        }
        
        .onAppear { //when this view appears...
            if specs.isEmpty { specs = makeSpecs(seed: seed) } //lazily generate the BlobSpec using makeSpecs (method defined below), if not already present (isEmpty), using the determined seed (1). Lazily meaning don't compute specs until they are appearing on screen, and only if not already set.  This runs PER VIEW, not per blob. It coordinates the full array of blobs.  The seed of 1 ensures the same layout.
        }
        .ignoresSafeArea() //this draws under the system UI (edges of the screen) letting the background fill the whole screen
    }

    
    private func makeSpecs(seed: UInt64) -> [BlobSpec] { //define function makeSpecs, private only gives access to this class file, takes a seed of unsigned 64-bit integer, -> means returns in Swift, returns an array of [BlobSpec]
        
        var rng = LCG(seed: seed) //variables begin. variable creates a deterministic random number generator (LCG - defined below at bottom of class) initialised with our seed defined above (1).
        var specs: [BlobSpec] = [] //start an empty [array] to collect blob specifications
        
        //LOOP BODY BEGIN
        for i in 0..<circleCount { //loop from 0 up until but not including the circleCount defined earlier (4), each time it does.. it builds one blob
            
            let baseColor = colors.indices.contains(i) ? colors[i] : colors[i % max(colors.count, 1)] //picks a colour for this blob, using the colors array we defined above, picks by saying if i is within the colors array, use it otherwise wrapped with modulo% so colours repeat safely and avoids a div0 error, the maximum count of colours may be 1 for this blob
            let adjusted = baseColor //use the provided color palette directly, alias to baseColor, placeholder if future adjustments are ever needed, for example, we can feed something into adjusted if a particular colour needs tweaked such as for subject topic colours modifying in Resources or Mid Survey (future implementation)
            let sizeScale = CGFloat(0.20 + rng.nextUnit() * 0.20) //randomise the scale between 20% - 40% of shortest side (CGFloat), later multiplied by the views shortest side...
            let phaseX = rng.nextUnit() * .pi * 2 //...random start phases between 0 and 2PIn for oscilations for horizontal X
            let phaseY = rng.nextUnit() * .pi * 2 //...same as above for vertical Y
            let speedX = 0.10 + rng.nextUnit() * 0.10 //random seeds between 0.10 - 0.20, radians per second since sin/cos
            let speedY = 0.10 + rng.nextUnit() * 0.10 //as above but for Y
            
            specs.append(BlobSpec(color: adjusted, sizeScale: sizeScale, phaseX: phaseX, phaseY: phaseY, speedX: speedX, speedY: speedY)) //constructs a BlobSpec with the chosen parameters above and ADDS it to the array...
        } //END LOOP BODY
        
        return specs //when the loop ends, return the specs array of blob specifications
    } //end of the function makeSpecs
}

// Simple helper deterministic Pseudo-Random-Number-Generator for reproducible layouts
private struct LCG { //LCG is a Linear Congruential Generator, visible only in this file (private)

    private var state: UInt64 //internal 64-bit unsigned integer holding current generator state. Every time we ask for a random number, it updates state using the formula below. Shows the current random number.
    
    //NOTE the long numbers below notated in yellow are specific constraints (called multiplier A and increment C) and are known to produce decent statistical properties under modulo 2^n. These particular constants are commonly used in 64-big LCG Random Number Generators //
    
    //OVERFLOW is if a calculation exceeds the maximum value type it can hold, it overflows. an error unless specified. Unsigned 64-bit integers have a maximum of 2^64-1. The &* and &+ below tells Swift if this goes past the limit, wrap around to the beginning. //

    init(seed: UInt64) { self.state = seed &* 6364136223846793005 &+ 1 } //starts the generator using our provided seed defined above (1). The &* and &+ operators wrap around automatically, so if they overflow, they effectively act like modulo 2^64. The 1 above is the increment (c).
    
    mutating func next() -> UInt64 { //next produces the next pseudo-random 64-bit number and advances the state... mutating because if modifies the state variable since it replaced the last random number...
        state = 2862933555777941757 &* state &+ 3037000493 //this formula says new state equals a * old state + c (with wrapping as above with &* and &+)...
        return state //then the new number is returned, giving back an updated state as the random number, ending the next function. //the second number 3037000493 is the increment (c)
    }
    
    mutating func nextUnit() -> Double { //returns a random double between 0 and 1
        Double(next()) / Double(UInt64.max) //calls next() to get a big integer, divides the maximum possible UInt64 to sale it into [0,1]
    }
}


struct PreviewHarness: View {
    var body: some View {
        AbstractBackgroundView()
            .frame(width: 400, height: 800)
    }
}

