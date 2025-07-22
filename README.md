# Trainly – AI Personal Workout Planner

Trainly is a revolutionary AI-powered fitness companion that transforms how you plan, track, and adjust your workouts. Unlike traditional gym management systems, Trainly is designed for individuals who want a truly personalized fitness experience. Simply chat with our AI coach using natural language to describe your goals and preferences, and watch as it creates a customized, editable weekly workout plan just for you.


## ✨ Key Features

### 🤖 **Intelligent AI Coach**
- **Natural Conversations**: Chat naturally with Gemini 2.5 Flash API
- **Personalized Planning**: AI creates workouts based on your goals, preferences, and schedule
- **Smart Adjustments**: Real-time workout modifications based on your feedback
- **Contextual Understanding**: AI remembers your progress and adapts recommendations

### � **Smart Weekly Planner**
- **Visual Calendar**: Clean Monday-Sunday layout with workout overview
- **Flexible Editing**: Add, modify, or remove exercises manually
- **Exercise Tracking**: Monitor sets, reps, duration, and intensity
- **Seamless Sync**: Chat modifications automatically update your planner
- **Progress Indicators**: Visual cues for completed workouts and rest days

### 👤 **Personalized Setup**
- **Comprehensive Onboarding**: One-time setup that learns about you
- **Health Metrics**: Age, weight, height, fitness level assessment
- **Goal Setting**: Weight loss, strength building, flexibility, or general fitness
- **Schedule Integration**: Configure your available workout days
- **Preference Learning**: Choose from Yoga, Calisthenics, Cardio, Strength training

## 🎯 Perfect For

- **Fitness Beginners**: Get started with AI-guided workout plans
- **Busy Professionals**: Quick, efficient workouts that fit your schedule
- **Home Fitness Enthusiasts**: No gym required - bodyweight and minimal equipment options
- **Goal-Oriented Individuals**: Whether it's weight loss, strength, or flexibility
- **Tech-Savvy Users**: Love the convenience of voice and chat interactions

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.10
- Dart ≥ 3.0
- Gemini API Key

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd trainly
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Get your Gemini API Key**
   - Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
   - Create a new API key
   - Copy the key for the next step

4. **Setup environment variables**
   - Copy `env.example.json` to `env.json`
   - Replace `your-gemini-api-key-here` with your actual API key in `env.json`

5. **Run the app with API key**
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your-gemini-api-key
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --dart-define=GEMINI_API_KEY=your-gemini-api-key
```

**Web Build:**
```bash
flutter build web --dart-define=GEMINI_API_KEY=your-gemini-api-key
```

## App Architecture

The app follows a clean architecture pattern with the following structure:

- **Presentation Layer**: UI screens and widgets
- **Services Layer**: API integrations (Gemini, Speech, TTS)
- **Models Layer**: Data models for workout plans and user profiles
- **Core Layer**: Common utilities and theme configuration

## 🌐 Platform Support

- ✅ **Android** - Full native support with material design
- ✅ **Web** - Progressive Web App with responsive design
- ❌ **iOS** - Not supported in current version (focused on Android + Web)

## 💬 Example Conversations

**Ask Trainly anything about fitness:**
- *"Create a 3-day workout plan focused on strength training"*
- *"Add 30 minutes of yoga to Tuesday's routine"*
- *"I couldn't workout yesterday, can you move it to today?"*
- *"Remove squats from my Monday workout - my knee hurts"*
- *"What's my workout plan for this week?"*
- *"I want to focus more on cardio, can you adjust my plan?"*


## 🚀 Future Roadmap

### **Version 2.0 - Enhanced AI & Analytics** *(Planned)*
- **Workout Performance Tracking**: Monitor progress over time with detailed analytics
- **Smart Rest Day Recommendations**: AI analyzes fatigue patterns for optimal recovery
- **Advanced Voice Features**: Complete hands-free workout guidance
- **Progress Photography**: Before/after tracking with AI body composition insights
- **Injury Prevention AI**: Detect overtraining and suggest modifications

### **Version 3.0 - Fitness Ecosystem** *(Planned)*
- **Wearable Integration**: Sync with Apple Watch, Fitbit, and Garmin devices
- **Heart Rate Zone Training**: Real-time workout intensity monitoring
- **Sleep & Recovery Integration**: Workout planning based on sleep quality
- **Nutrition Intelligence**: AI meal planning aligned with fitness goals
- **Social Features**: Share achievements and compete with friends
- **Advanced Personalization**: Machine learning for truly adaptive workouts



<div align="center">
  <strong>Made with ❤️ for the fitness community</strong>
  <br/>
  <em>Transform your fitness journey with AI-powered personal training</em>
</div>
