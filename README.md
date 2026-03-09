<div align="center">

# 🏋️ NutraX

### AI-Powered Fitness & Nutrition Tracking Platform


</div>

---

## ✨ Features

### 🤸 Pose Analysis Engine
- Real-time **body pose estimation** using ML Kit's pose detection
- Tracks reps, sets, and form quality for exercises like squats, push-ups, and curls
- Instant feedback on **posture correction** to prevent injury

### 🔥 Calorie Estimation
- Estimates **calories burned** based on detected movement intensity and user biometrics
- Food intake estimation via **image recognition** — just snap a photo of your meal
- Tracks **nutritional intake** (protein, carbs, fats) automatically

### 🤖 Automated ML Workflows (n8n)
- Real-time health data processed through **automated ML pipelines**
- Intelligent, personalized **fitness insights** delivered daily
- Anomaly detection for unusual health patterns

### 📊 Biometric Analytics Dashboard
- Visual breakdown of **daily, weekly, and monthly** health trends
- Progress tracking with smart goal recommendations
- Sleep, hydration, and activity correlation analysis

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Flutter (Android & iOS) |
| **Backend / ML** | Python, FastAPI |
| **Computer Vision** | Google ML Kit, OpenCV |
| **ML Automation** | n8n Workflows |
| **Database & Auth** | Firebase Firestore, Firebase Auth |
| **Storage** | Firebase Cloud Storage |
| **Notifications** | Firebase Cloud Messaging |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Python `>=3.9`
- Firebase project set up
- n8n instance (local or cloud)

### Installation

#### 1. Clone the repository
```bash
git clone https://github.com/manish08k/nutrax.git
cd nutrax
```

#### 2. Flutter App Setup
```bash
# Install Flutter dependencies
flutter pub get

# Configure Firebase
# Add your google-services.json (Android) and GoogleService-Info.plist (iOS)
# to the respective platform folders

# Run the app
flutter run
```

#### 3. Python Backend Setup
```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set environment variables
cp .env.example .env
# Fill in your Firebase credentials and API keys in .env

# Start the server
uvicorn main:app --reload
```

#### 4. n8n Workflow Setup
```bash
# Run n8n locally
npx n8n

# Import the workflow
# Go to n8n dashboard → Import → upload workflows/nutrax_pipeline.json
```

---

## 📁 Project Structure

```
nutrax/
├── lib/                    # Flutter app source
│   ├── screens/            # UI screens
│   ├── widgets/            # Reusable components
│   ├── models/             # Data models
│   ├── services/           # Firebase & API services
│   └── utils/              # Helpers & constants
├── backend/                # Python ML backend
│   ├── pose_engine/        # Pose analysis module
│   ├── calorie_engine/     # Calorie estimation module
│   ├── api/                # FastAPI routes
│   └── requirements.txt
├── workflows/              # n8n automation workflows
└── README.md
```

---

## 🧠 How It Works

```
User Camera Feed
      │
      ▼
ML Kit Pose Detection ──► Pose Analysis Engine (Python)
      │                           │
      │                    Rep Counting + Form Score
      ▼                           │
Calorie Estimation Engine ◄───────┘
      │
      ▼
n8n Automation Pipeline
      │
      ├──► Firebase Firestore (store metrics)
      │
      └──► Personalized Insights ──► Flutter Dashboard
```

---

## 🔧 Environment Variables

Create a `.env` file in `/backend`:

```env
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_PRIVATE_KEY=your_private_key
FIREBASE_CLIENT_EMAIL=your_client_email
N8N_WEBHOOK_URL=your_n8n_webhook_url
```

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/AmazingFeature`
3. Commit your changes: `git commit -m 'Add AmazingFeature'`
4. Push to the branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Manish Nalumachu**


