Refer this link for presentation video
https://drive.google.com/file/d/1p7vVOliyrKjreuE18YjIdy7J5dthekgs/view?usp=drive_link
---
The file below is the zip file's drive link
https://drive.google.com/file/d/1W9dNDBywywMRMwrXQ7Zl4a7HqSJdjSkf/view?usp=sharing
# 📡 SMITH.IO - Advanced Smith Chart Simulator

A premium, interactive RF engineering tool built with Flutter. Featuring high-speed AI assistance powered by **Groq (Llama 3.1)** and **Google Gemini**, an analytic matching solver, and a responsive 3-panel professional dashboard.

[![Deployed to Vercel](https://img.shields.io/badge/Vercel-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://vercel.com)
[![Deployed to Netlify](https://img.shields.io/badge/Netlify-00C7B7?style=for-the-badge&logo=netlify&logoColor=white)](https://netlify.com)

---

## 🚀 Quick Start (Local)

1. **Install Flutter**: Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. **Clone the Repo**:
   ```bash
   git clone <your-repo-url>
   cd smith_chart
   ```
3. **Run the App**:
   ```bash
   flutter run -d chrome --dart-define=GROQ_KEY=your_key --dart-define=GEMINI_KEY=your_key
   ```

---

## 🌍 Global Deployment (Vercel/Netlify)

### 1. Build Command
To build the production-ready web application securely:
```bash
flutter build web --release \
  --dart-define=GROQ_KEY=YOUR_GROQ_KEY \
  --dart-define=GEMINI_KEY=YOUR_GEMINI_KEY
```

### 2. Netlify (Drag & Drop)
Simply drag the `build/web` folder into the Netlify manual deploy area.

### 3. Vercel (GitHub integration)
1. Push this project to GitHub.
2. Connect to Vercel.
3. Vercel will automatically detect the `vercel.json` and start the build.
4. **Environment Variables**: Use Vercel's UI to add `GROQ_KEY` and `GEMINI_KEY` values.

---

## 🛠 Features
- **3-Panel Dashboard**: Components, Chart, and Results all visible at once.
- **AI Expert Chat**: Integrated RF engineering consultancy.
- **Analytic Solver**: Automatic single-stub matching calculations.
- **Glassmorphism UI**: Modern, sleek aesthetics for engineers.
- **Mobile Optimized**: Fully responsive layout for all screen sizes.

---

## 📄 Documentation
- [Engineering Walkthrough](file:///C:/Users/dheep/.gemini/antigravity/brain/29b1ebc1-1ed6-4070-b1e7-68d1de8920f6/engineering_walkthrough.md)
- [Mobile Deployment Guide](file:///C:/Users/dheep/.gemini/antigravity/brain/29b1ebc1-1ed6-4070-b1e7-68d1de8920f6/deployment_guide.md)
- [Web Deployment Guide](file:///C:/Users/dheep/.gemini/antigravity/brain/29b1ebc1-1ed6-4070-b1e7-68d1de8920f6/web_deployment_guide.md)



