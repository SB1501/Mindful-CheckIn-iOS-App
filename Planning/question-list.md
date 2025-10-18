# Self-Check Survey Structure

This survey uses two input types: Button Groups and Sliders. Button groups offer discrete options mapped to qualitative states (e.g., “None” to “Well rested”). Sliders measure polarity from negative to positive across a continuous scale. This part has been significantly reworked as the build of the app has come along with main changes being from Low/High to Negative/Positive on slider scaling and different button answers to suit the question for button group questions. 


## Button Group Questions

Each question presents 3–4 options that reflect a progression from negative to positive states. These options are mapped to internal logic triggers in the Survey Manager / Controller (e.g., ‘bad’, ‘neutral’, ‘good’) depending on context.

### Question Options	
**How much sleep have you had?**	
None · Barely any · Enough · Well rested	

**How much water have you had to drink?**
None · Barely any · Some · Well hydrated	

**How much have you eaten today?**
Too much · Too little · Enough · Well nourished	

**How much time have you had to rest today?**
None · A little · Enough · Fully rested	

**Have you taken care of your hygiene today?**
Not at all · Partially · Mostly · Fully	

**Have you socialised recently?**
Not at all · Very little · Some · Plenty	

**How much time have you spent outdoors lately?**
None · A little · Some · Plenty	

**Have you taken a mental break?**
None · Briefly · Some · Fully disconnected	

**Have you checked in with yourself today?**
Not yet · Briefly · Somewhat · Fully present	




## Slider Questions

Sliders measure polarity from negative to positive. Some questions use ‘higherIsBetter: false’ logic, indicating that lower values are preferable (e.g. for caffeine intake).

### Question	
How positively is your caffeine intake affecting you? (higherIsBetter: false)	

How positively is your sugar intake affecting you? (higherIsBetter: false)	

How physically at ease do you feel?	

How positively does your clothing feel?	

How positively do your eyes feel?	

How positively does the temperature feel to you?	

How positively does the lighting feel to you?	

How positively do surrounding sounds affect you?	

How positively does your space feel?	

How positively is your screen time affecting you? (higherIsBetter: false)	

How physically relaxed do you feel?	

How positively steady is your breathing rhythm?	

How positively calm is your mind right now?	

How positively manageable is your task load?	

How positively focused do you feel today?	

How positively engaged are you with important tasks?	

How positively motivated do you feel right now?	

How positively kind are you being to yourself?	

How positively aligned are you with your needs?	


