# Trainly – AI Personal Workout Planner

Trainly is a revolutionary AI-powered fitness companion that transforms how you plan, track, and adjust your workouts. Unlike traditional gym management systems, Trainly is designed for individuals who want a truly personalized fitness experience. Simply chat with our AI coach using natural language to describe your goals and preferences, and watch as it creates a customized, editable weekly workout plan just for you.

## 📱 App Preview

<!-- Add your screenshots here -->
<div align="center">
  <img src="assets/images/Screenshot_2025-07-08_at_3.38.44_PM-1751969328567.png" alt="Trainly Chat Interface" width="250"/>
  <br/>
  <em>Chat with Trainly - Your AI Fitness Coach</em>
</div>

*More screenshots coming soon...*


## ✨ Key Features

### 🤖 **Intelligent AI Coach**
- **Natural Conversations**: Chat naturally with Gemini 2.5 Flash API
- **Personalized Planning**: AI creates workouts based on your goals, preferences, and schedule
- **Voice Integration**: Speak your requests with built-in speech-to-text
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

## 📸 Screenshots Gallery

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="assets/images/Screenshot_2025-07-08_at_3.38.44_PM-1751969328567.png" alt="Chat Interface" width="250"/>
        <br/>
        <em>💬 AI Chat Interface</em>
      </td>
      <td align="center">
        <img src="assets/images/Screenshot_2025-07-08_at_3.42.51_PM-1751969575625.png" alt="Weekly Planner" width="250"/>
        <br/>
        <em>📅 Weekly Workout Planner</em>
      </td>
      <td align="center">
        <img src="assets/images/Screenshot_2025-07-11_at_11.50.17_AM-1752214820202.png" alt="Profile Setup" width="250"/>
        <br/>
        <em>👤 Profile & Goals Setup</em>
      </td>
    </tr>
  </table>
</div>

*Experience the power of AI-driven fitness planning with an intuitive, user-friendly interface.*

## 🧠 AI Technology

**Powered by Google Gemini 2.5 Flash API**

- **Advanced NLP**: Understands complex fitness requests and nuanced language
- **Contextual Memory**: Remembers your preferences, progress, and past conversations
- **JSON-Based Planning**: Structured workout data for seamless integration
- **Real-Time Adaptation**: Modifies plans based on your feedback and performance
- **Personalization Engine**: Learns from your interactions to improve recommendations

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

## 🛠 Technical Stack

- **Frontend**: Flutter 3.32.7 - Cross-platform native performance
- **AI Engine**: Google Gemini 2.5 Flash API - Advanced natural language processing
- **Voice Tech**: Speech-to-Text & Text-to-Speech - Multimodal interaction
- **Storage**: SharedPreferences - Secure local data persistence
- **Architecture**: Clean Architecture - Scalable and maintainable codebase

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

**Trainly understands context and adapts to your needs in real-time!**

### JSON Workout Plan Structure
```json
{
  "monday": [
    { "exercise": "Bodyweight Squats", "sets": 3, "reps": 15 },
    { "exercise": "Plank", "duration": "60s" }
  ],
  "tuesday": [
    { "exercise": "Yoga Session", "duration": "30 min" }
  ]
}
```

## 🚀 Future Roadmap

### **Version 2.0 - Enhanced AI & Analytics** *(Coming Soon)*
- **Workout Performance Tracking**: Monitor progress over time with detailed analytics
- **Smart Rest Day Recommendations**: AI analyzes fatigue patterns for optimal recovery
- **Advanced Voice Features**: Complete hands-free workout guidance
- **Progress Photography**: Before/after tracking with AI body composition insights
- **Injury Prevention AI**: Detect overtraining and suggest modifications

### **Version 2.5 - Fitness Ecosystem** *(Planned)*
- **Wearable Integration**: Sync with Apple Watch, Fitbit, and Garmin devices
- **Heart Rate Zone Training**: Real-time workout intensity monitoring
- **Sleep & Recovery Integration**: Workout planning based on sleep quality
- **Nutrition Intelligence**: AI meal planning aligned with fitness goals
- **Social Features**: Share achievements and compete with friends
- **Advanced Personalization**: Machine learning for truly adaptive workouts

*Join our journey as we revolutionize personal fitness with cutting-edge AI technology!*

## 🤝 Contributing

We welcome contributions from the fitness and tech community!

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines
- Follow Flutter/Dart best practices
- Write clear commit messages
- Test thoroughly on both Android and Web
- Update documentation for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Google Gemini Team** - For the powerful AI API
- **Flutter Community** - For the amazing framework
- **Fitness Enthusiasts** - For inspiration and feedback

## 📞 Support & Community

- **Issues**: [GitHub Issues](https://github.com/your-username/trainly/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/trainly/discussions)
- **Email**: support@trainly.app *(coming soon)*

---

<div align="center">
  <strong>Made with ❤️ for the fitness community</strong>
  <br/>
  <em>Transform your fitness journey with AI-powered personal training</em>
</div>