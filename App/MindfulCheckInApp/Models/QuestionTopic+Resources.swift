import Foundation

public struct TopicResources {
    public let title: String
    public let summary: String
    public let whatWhy: String
    public let benefits: [String]
    public let risks: [String]
    public let tips: [String]
}

extension QuestionTopic {
    public var resources: TopicResources {
        switch self {
        case .sleep:
            return TopicResources(
                title: "Sleep",
                summary: "Sleep is your body’s primary recovery system. It restores energy, stabilises mood, supports memory, and helps regulate nearly every physical and cognitive process. When sleep is steady and sufficient, your whole system functions more smoothly.",
                whatWhy: "Good sleep helps your brain and body reset. It supports attention, emotional regulation, learning, and steady energy. Even small improvements to your routine can make a noticeable difference.",
                benefits: [
                    "More stable mood and emotional resilience",
                    "Clearer thinking and better focus",
                    "Improved energy and motivation",
                    "Stronger immune function",
                    "Easier decision‑making and emotional regulation"
                ],
                risks: [
                    "Irritability, low mood, or emotional volatility",
                    "Difficulty concentrating or remembering things",
                    "Fatigue that affects motivation and productivity",
                    "Increased stress sensitivity",
                    "Feeling mentally foggy or overwhelmed"
                ],
                tips: [
                    "Keep a consistent sleep–wake rhythm when possible",
                    "Create a calming wind‑down routine before bed",
                    "Reduce stimulating screen use close to sleep",
                    "Notice how food, caffeine, and stress affect your nights",
                    "Prioritise rest on days when sleep has been disrupted"
                ]
            )

        case .hydration:
            return TopicResources(
                title: "Hydration",
                summary: "Hydration supports energy, focus, digestion, and temperature regulation. Small changes can noticeably affect how you feel.",
                whatWhy: "Water helps your body run smoothly — from cognitive function to physical comfort. Staying hydrated supports steadier energy, clearer thinking, and overall wellbeing.",
                benefits: [
                    "More stable energy and alertness",
                    "Improved concentration and mood",
                    "Better digestion and physical comfort",
                    "Easier temperature regulation"
                ],
                risks: [
                    "Fatigue and low motivation",
                    "Headaches or difficulty focusing",
                    "Dry mouth and general discomfort",
                    "Feeling sluggish or irritable"
                ],
                tips: [
                    "Keep water visible and nearby",
                    "Sip regularly rather than waiting for strong thirst",
                    "Add gentle reminders if you tend to forget",
                    "Notice how hydration affects your mood and focus",
                    "Adjust intake with activity, heat, or dry environments"
                ]
            )
        case .food:
            return TopicResources(
                title: "Nutrition",
                summary: "Nourishing meals support steady energy, mood, and focus throughout the day.",
                whatWhy: "Balanced eating helps your body and brain run consistently. Regular meals and mindful choices can reduce energy dips and support clearer thinking.",
                benefits: [
                    "More stable energy and mood",
                    "Better concentration and memory",
                    "Improved physical comfort and digestion",
                    "Easier decision‑making and motivation"
                ],
                risks: [
                    "Energy spikes and crashes",
                    "Irritability or low mood",
                    "Trouble focusing or feeling foggy",
                    "Stomach discomfort or restlessness"
                ],
                tips: [
                    "Aim for regular meals and gentle balance",
                    "Notice how different foods affect your energy",
                    "Keep simple, nourishing options on hand",
                    "Eat slowly and check in with fullness/hunger",
                    "Plan small snacks to bridge long gaps"
                ]
            )
        case .caffeine:
            return TopicResources(
                title: "Caffeine",
                summary: "Caffeine can boost alertness, but timing and amount affect sleep, focus, and mood.",
                whatWhy: "Used thoughtfully, caffeine can support focus. Too much or late in the day can disrupt sleep and increase jitteriness.",
                benefits: [
                    "Short‑term alertness and focus",
                    "Increased motivation to start tasks",
                    "Helpful boost for low‑energy periods"
                ],
                risks: [
                    "Jitters or restlessness",
                    "Sleep disruption if taken too late",
                    "Short energy crash later in the day",
                    "Heightened stress sensitivity"
                ],
                tips: [
                    "Notice your personal sensitivity and timing",
                    "Try a caffeine cut‑off time",
                    "Alternate with water or decaf options",
                    "Pair caffeine with food to soften spikes",
                    "Experiment with smaller amounts"
                ]
            )
        case .sugar:
            return TopicResources(
                title: "Sugar",
                summary: "Sweet foods can be enjoyable, but large or frequent spikes may affect energy and mood.",
                whatWhy: "Quick sugars can lift energy briefly, then dip. Awareness helps you find a balance that supports steadier focus and comfort.",
                benefits: [
                    "Enjoyment and satisfaction in moderation",
                    "Quick energy when needed",
                    "Flexibility in social or celebratory moments"
                ],
                risks: [
                    "Energy spikes and crashes",
                    "Irritability or low mood after dips",
                    "Cravings that affect decision‑making"
                ],
                tips: [
                    "Pair sweets with protein or fiber",
                    "Notice how different amounts affect you",
                    "Keep balanced snacks around",
                    "Enjoy mindfully and without judgment",
                    "Space out sweet treats to reduce swings"
                ]
            )
        case .rest:
            return TopicResources(
                title: "Recovery & Rest",
                summary: "Gentle rest helps your body and mind reset between demands.",
                whatWhy: "Pauses allow your system to recover, lowering stress and improving focus when you return to tasks.",
                benefits: [
                    "Better focus and productivity",
                    "Lower tension or stress",
                    "More consistent energy",
                    "Improved mood and patience"
                ],
                risks: [
                    "Feeling overwhelmed or tense",
                    "Reduced concentration over time",
                    "Fatigue that builds across the day"
                ],
                tips: [
                    "Take short, regular breaks",
                    "Step away from screens briefly",
                    "Stretch or move gently",
                    "Check in with how you feel before resuming",
                    "Protect small pockets of downtime"
                ]
            )
        case .hygiene:
            return TopicResources(
                title: "Hygiene",
                summary: "Simple hygiene routines can boost comfort, confidence, and a sense of freshness.",
                whatWhy: "Feeling clean and cared for supports mental clarity and self‑assurance, which can shape motivation and mood.",
                benefits: [
                    "Increased comfort and confidence",
                    "Feeling refreshed and reset",
                    "Subtle boost to motivation",
                    "Better readiness for social or work tasks"
                ],
                risks: [
                    "Feeling uncomfortable or distracted",
                    "Lowered motivation or confidence",
                    "Hesitation to start or continue tasks"
                ],
                tips: [
                    "Keep routines simple and repeatable",
                    "Prepare essentials within easy reach",
                    "Pair routines with existing habits",
                    "Celebrate small wins (even a quick refresh)",
                    "Adjust routines to your day’s needs"
                ]
            )
        case .strain:
            return TopicResources(
                title: "Physical Strain",
                summary: "Reducing strain supports comfort, endurance, and ease of movement.",
                whatWhy: "Ergonomics and gentle mobility can lower tension and help you sustain activities more comfortably.",
                benefits: [
                    "Less discomfort and stiffness",
                    "Easier posture and movement",
                    "More consistent stamina",
                    "Improved focus without nagging pain"
                ],
                risks: [
                    "Tightness that distracts or drains energy",
                    "Posture discomfort or headaches",
                    "Reduced endurance for tasks"
                ],
                tips: [
                    "Adjust seating and screen height",
                    "Change positions periodically",
                    "Add light stretching or movement",
                    "Use supports (cushions, footrest) if helpful",
                    "Notice early signs of strain and respond"
                ]
            )
        case .clothing:
            return TopicResources(
                title: "Comfortable Clothing",
                summary: "Comfortable clothing supports ease, body temperature, and focus.",
                whatWhy: "Fabrics and fit can influence your comfort and movement. Feeling at ease helps you concentrate longer.",
                benefits: [
                    "Better temperature comfort",
                    "Less distraction from tight or itchy fabrics",
                    "Easier movement and posture",
                    "Subtle lift in mood and confidence"
                ],
                risks: [
                    "Discomfort that distracts",
                    "Overheating or feeling chilled",
                    "Irritation or itchiness"
                ],
                tips: [
                    "Choose breathable, comfortable fabrics",
                    "Adjust layers to conditions",
                    "Prioritise fit that supports movement",
                    "Keep a fallback outfit handy",
                    "Notice how clothing affects focus"
                ]
            )
        case .eyes:
            return TopicResources(
                title: "Eye Care",
                summary: "Gentle eye care supports comfort and reduces strain during screen or detail work.",
                whatWhy: "Breaks, lighting, and distance help your eyes recover, reducing fatigue and headaches.",
                benefits: [
                    "Less eye fatigue or dryness",
                    "Fewer headaches from strain",
                    "More comfortable screen time",
                    "Better sustained focus"
                ],
                risks: [
                    "Eye discomfort or dryness",
                    "Headaches or blurred focus",
                    "Shorter attention span at screens"
                ],
                tips: [
                    "Try the 20‑20‑20 rule (every 20 minutes, 20 seconds, 20 feet)",
                    "Adjust screen brightness and contrast",
                    "Ensure adequate ambient lighting",
                    "Blink intentionally during long tasks",
                    "Increase distance to screens when possible"
                ]
            )
        case .temperature:
            return TopicResources(
                title: "Temperature",
                summary: "Comfortable temperature helps your body and mind work smoothly.",
                whatWhy: "Heat or cold affects energy and concentration. A good range supports comfort and steady focus.",
                benefits: [
                    "More consistent energy and mood",
                    "Better concentration and stamina",
                    "Less physical tension"
                ],
                risks: [
                    "Discomfort that distracts",
                    "Restlessness or sluggishness",
                    "Shortened focus during tasks"
                ],
                tips: [
                    "Adjust layers, airflow, or heating",
                    "Hydrate in warm conditions",
                    "Warm up your hands or feet if cold",
                    "Take short movement breaks to reset"
                ]
            )
        case .lighting:
            return TopicResources(
                title: "Lighting",
                summary: "Supportive lighting reduces strain and helps with alertness and mood.",
                whatWhy: "Balanced light makes tasks easier on your eyes and can support your body’s natural rhythms.",
                benefits: [
                    "More comfortable reading and screen use",
                    "Fewer headaches from glare or strain",
                    "Subtle lift in alertness and mood"
                ],
                risks: [
                    "Squinting or eye fatigue",
                    "Headaches from glare or harsh light",
                    "Trouble winding down with bright evening light"
                ],
                tips: [
                    "Reduce glare and harsh contrast",
                    "Use warm light in the evening",
                    "Add task lighting where needed",
                    "Sit near natural light when possible"
                ]
            )
        case .sound:
            return TopicResources(
                title: "Sound & Noise",
                summary: "Sound shapes focus, comfort, and stress levels.",
                whatWhy: "The soundscape around you can support concentration or feel overwhelming. Adjusting it helps your brain settle.",
                benefits: [
                    "Easier focus or relaxation",
                    "Lower stress from harsh noise",
                    "Better comfort in shared spaces"
                ],
                risks: [
                    "Distraction or irritation",
                    "Tension or restlessness",
                    "Shortened attention span"
                ],
                tips: [
                    "Try headphones or gentle ambient sound",
                    "Set boundaries for noise where possible",
                    "Take brief quiet breaks",
                    "Notice what soundscapes help you focus"
                ]
            )
        case .socialising:
            return TopicResources(
                title: "Social Connection",
                summary: "Supportive connection can lift mood, resilience, and motivation.",
                whatWhy: "Even small, meaningful interactions help you feel grounded and energised. Balance matters — it’s about the right amount for you.",
                benefits: [
                    "Lift in mood and sense of belonging",
                    "Encouragement and perspective",
                    "Greater resilience during stress"
                ],
                risks: [
                    "Feeling isolated or flat",
                    "Lower motivation or energy",
                    "Overwhelm if interactions feel too frequent"
                ],
                tips: [
                    "Reach out in small ways (message, brief chat)",
                    "Balance alone time and connection",
                    "Choose supportive people and contexts",
                    "Notice what kinds of contact help you most"
                ]
            )
        case .outdoors:
            return TopicResources(
                title: "Outdoors & Nature",
                summary: "Time outdoors can refresh mood, focus, and energy.",
                whatWhy: "Natural light, fresh air, and movement support your body and mind. Even short moments can help you reset.",
                benefits: [
                    "Brighter mood and energy",
                    "Easier focus after a short break",
                    "Sense of space and perspective"
                ],
                risks: [
                    "Feeling cooped up or flat",
                    "Restlessness or tension",
                    "Lower motivation after long indoor periods"
                ],
                tips: [
                    "Step outside briefly when you can",
                    "Bring nature indoors (plants, views)",
                    "Pair short walks with daily tasks",
                    "Notice how outdoor time affects you"
                ]
            )
        case .space:
            return TopicResources(
                title: "Organizing Your Space",
                summary: "A tidy, intentional space supports clarity and ease.",
                whatWhy: "Reducing clutter and creating simple zones can help your brain settle and make tasks feel easier to start.",
                benefits: [
                    "Less visual noise and distraction",
                    "Smoother task switching",
                    "Subtle lift in calm and control"
                ],
                risks: [
                    "Feeling scattered or overwhelmed",
                    "Wasting time finding things",
                    "Hesitation to start tasks"
                ],
                tips: [
                    "Clear one small area at a time",
                    "Create simple ‘homes’ for key items",
                    "Reset your space with a 2‑minute tidy",
                    "Keep daily tools within easy reach"
                ]
            )
        case .screenTime:
            return TopicResources(
                title: "Screen Time",
                summary: "Intentional screen time supports focus, rest, and mood.",
                whatWhy: "Screens can be useful and engaging, but long sessions may affect sleep, posture, and attention. A few boundaries can help.",
                benefits: [
                    "More focused sessions with breaks",
                    "Easier winding down for sleep",
                    "Less strain and distraction"
                ],
                risks: [
                    "Restlessness or eye strain",
                    "Sleep disruption from late screens",
                    "Shortened attention span"
                ],
                tips: [
                    "Take short breaks and move regularly",
                    "Set an evening wind‑down window",
                    "Use ‘focus’ modes when needed",
                    "Keep non‑essential scrolling in check"
                ]
            )
        case .tension:
            return TopicResources(
                title: "Muscle Tension",
                summary: "Releasing tension can restore comfort and ease of movement.",
                whatWhy: "Stress and posture can create tightness. Gentle movement and awareness help your body relax.",
                benefits: [
                    "Less discomfort and stiffness",
                    "Easier breathing and posture",
                    "Better focus with fewer distractions"
                ],
                risks: [
                    "Persistent tightness or restlessness",
                    "Headaches or jaw/neck strain",
                    "Reduced comfort during tasks"
                ],
                tips: [
                    "Do light stretches throughout the day",
                    "Breathe slowly to release tightness",
                    "Adjust posture and supports",
                    "Try brief mobility breaks"
                ]
            )
        case .breathing:
            return TopicResources(
                title: "Breathing",
                summary: "Steady, relaxed breathing supports calm, clarity, and physical ease.",
                whatWhy: "Breath influences your nervous system. Gentle techniques can help you reset during busy or tense moments.",
                benefits: [
                    "More calm and focus",
                    "Lower tension and restlessness",
                    "Easier emotional regulation"
                ],
                risks: [
                    "Shallow or hurried breathing",
                    "Feeling tense or on edge",
                    "Reduced focus under stress"
                ],
                tips: [
                    "Try slow exhales (longer out‑breath)",
                    "Use box breathing (4‑4‑4‑4) briefly",
                    "Pair breath with posture resets",
                    "Practice for a minute between tasks"
                ]
            )
        case .mentalBusy:
            return TopicResources(
                title: "Mental Load",
                summary: "Lightening mental load supports clarity and steadier energy.",
                whatWhy: "When the mind is full, it’s harder to focus. Offloading and simplifying can make tasks feel more manageable.",
                benefits: [
                    "Clearer thinking and prioritising",
                    "Reduced overwhelm",
                    "Better follow‑through"
                ],
                risks: [
                    "Feeling scattered or stuck",
                    "Decision fatigue",
                    "Procrastination or avoidance"
                ],
                tips: [
                    "Jot down tasks and thoughts",
                    "Pick one small next step",
                    "Reduce optional inputs (alerts, tabs)",
                    "Group similar tasks together"
                ]
            )
        case .taskLoad:
            return TopicResources(
                title: "Task Load",
                summary: "Right‑sized task load supports momentum and calm.",
                whatWhy: "Too much or too little can disrupt motivation. Pacing and scope help you stay engaged without burning out.",
                benefits: [
                    "Smoother progress and motivation",
                    "Less stress from overload",
                    "Better quality of work"
                ],
                risks: [
                    "Overwhelm and frustration",
                    "Boredom or disengagement",
                    "Frequent context switching"
                ],
                tips: [
                    "Break work into small steps",
                    "Set gentle time blocks",
                    "Say no or defer when needed",
                    "Celebrate small wins"
                ]
            )
        case .mentalBreak:
            return TopicResources(
                title: "Mental Breaks",
                summary: "Short mental breaks refresh attention and mood.",
                whatWhy: "Pausing gives your brain space to reset. It can lift energy and reduce frustration when you return to tasks.",
                benefits: [
                    "Better focus after breaks",
                    "Lower stress and tension",
                    "More patience and creativity"
                ],
                risks: [
                    "Diminishing returns without breaks",
                    "Restlessness or irritability",
                    "Reduced motivation over time"
                ],
                tips: [
                    "Step away briefly between tasks",
                    "Change environment for a moment",
                    "Use a timer to remind yourself",
                    "Do a quick non‑screen activity"
                ]
            )
        case .focus:
            return TopicResources(
                title: "Focus",
                summary: "Supporting focus helps you do meaningful work with less friction.",
                whatWhy: "Reducing distractions and shaping your environment helps your brain stay engaged and effective.",
                benefits: [
                    "Smoother progress on tasks",
                    "Fewer interruptions in thinking",
                    "Greater sense of accomplishment"
                ],
                risks: [
                    "Frequent distraction or stress",
                    "Harder time finishing tasks",
                    "Lower confidence in your flow"
                ],
                tips: [
                    "Use focus modes or boundaries",
                    "Work in short, clear blocks",
                    "Remove one distraction at a time",
                    "Start with a very small step"
                ]
            )
        case .avoidance:
            return TopicResources(
                title: "Avoidance",
                summary: "Gentle starts reduce avoidance and build momentum.",
                whatWhy: "When tasks feel big, starting small helps you get moving without overload.",
                benefits: [
                    "More consistent follow‑through",
                    "Reduced dread around tasks",
                    "Greater confidence to continue"
                ],
                risks: [
                    "Prolonged stress from delays",
                    "Tasks piling up or feeling bigger",
                    "Lower trust in your momentum"
                ],
                tips: [
                    "Define a tiny first step",
                    "Set a short timer to begin",
                    "Pair tasks with supportive cues",
                    "Acknowledge small progress"
                ]
            )
        case .motivation:
            return TopicResources(
                title: "Motivation",
                summary: "Motivation grows with clarity, values, and small wins.",
                whatWhy: "When tasks connect to what matters to you, it’s easier to get started and keep going.",
                benefits: [
                    "More sustained effort",
                    "Clearer direction",
                    "Satisfaction from progress"
                ],
                risks: [
                    "Drifting or losing interest",
                    "Feeling stuck at the start",
                    "Lower sense of purpose"
                ],
                tips: [
                    "Link tasks to personal values",
                    "Make progress visible",
                    "Lower the barrier to starting",
                    "Reflect on what’s working"
                ]
            )
        case .selfCheckIn:
            return TopicResources(
                title: "Self Check-In",
                summary: "Regular self check-ins build awareness and supportive adjustments.",
                whatWhy: "Noticing how you feel helps you choose small changes that support your day.",
                benefits: [
                    "Better self‑understanding",
                    "More responsive choices",
                    "Improved emotional balance"
                ],
                risks: [
                    "Missing early signs of strain",
                    "Reacting late to needs",
                    "Feeling out of tune with yourself"
                ],
                tips: [
                    "Pause briefly to notice body and mood",
                    "Name one need and one next step",
                    "Keep notes or reflections if helpful",
                    "Be kind and curious with yourself"
                ]
            )
        case .selfKindness:
            return TopicResources(
                title: "Self Kindness",
                summary: "Self‑kindness supports resilience and steady motivation.",
                whatWhy: "A supportive inner voice helps you recover from setbacks and continue with care.",
                benefits: [
                    "Lower self‑criticism and stress",
                    "Greater persistence with tasks",
                    "Improved emotional balance"
                ],
                risks: [
                    "Harsh self‑talk and tension",
                    "Reduced willingness to try",
                    "Feeling stuck after mistakes"
                ],
                tips: [
                    "Speak to yourself as you would to a friend",
                    "Acknowledge feelings without judgment",
                    "Choose one gentle, helpful action",
                    "Celebrate small efforts"
                ]
            )
        case .authenticity:
            return TopicResources(
                title: "Authenticity",
                summary: "Acting in line with your values supports calm and clarity.",
                whatWhy: "When your actions reflect what matters to you, motivation and trust in yourself often improve.",
                benefits: [
                    "Greater ease and confidence",
                    "Clearer decisions",
                    "More sustainable motivation"
                ],
                risks: [
                    "Feeling conflicted or drained",
                    "Second‑guessing choices",
                    "Lower satisfaction with outcomes"
                ],
                tips: [
                    "Name what matters about a task",
                    "Adjust plans to fit your values",
                    "Check in: ‘Is this aligned for me?’",
                    "Take small steps that feel true"
                ]
            )
        }
    }
}

// Compatibility accessors for existing UI that reads simple strings
extension QuestionTopic {
    public var resourceTitle: String { resources.title }
    public var resourceSummary: String { resources.summary }
    public var resourceWhatWhy: String { resources.whatWhy }
    public var resourcePositives: String { resources.benefits.joined(separator: "\n") }
    public var resourceRisks: String { resources.risks.joined(separator: "\n") }
    public var resourceTips: String { resources.tips.joined(separator: "\n") }
}
