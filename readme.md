# 🎓 InterviewPrep

A modern, high-performance interview preparation and MCQ test platform built with **ColdFusion (ColdBox)** and **BoxLang**. 

Featuring a premium dark-themed interface with glassmorphic elements and interactive data visualizations.

---

## 🚀 Features
<img width="1352" height="676" alt="image" src="https://github.com/user-attachments/assets/c6e7825c-bf74-43b3-846e-cb7d4afc007a" />
<img width="1358" height="587" alt="image" src="https://github.com/user-attachments/assets/87f83ec1-a84f-4709-9f55-74a04cb1a2fc" />
<img width="1365" height="596" alt="image" src="https://github.com/user-attachments/assets/5619911a-affb-474f-98a7-c6e445f9e107" />

- **📊 Comprehensive Dashboard**: Real-time stats, activity charts (via Chart.js), and personalized progress tracking.
- **📝 MCQ Test Engine**: Dynamic test generation with multiple categories (e.g., ColdFusion Basics).
- **🏫 Practice Mode**: Risk-free simulation for honing skills without impacting the leaderboard.
- **🏆 Global Leaderboard**: Competative ranking system to track top performers.
- **🛡️ Admin Command Center**: Robust management panel for tests, questions, and users.
- **🌌 Immersive UI**: "Elite" layout featuring a star-field animation background and responsive sidebar.

## 🛠️ Technology Stack

- **Backend**: [ColdBox HMVC](https://coldbox.org/) on [BoxLang](https://boxlang.io/) / Adobe ColdFusion.
- **Frontend**: Bootstrap 5, FontAwesome 6, Chart.js.
- **Database**: MySQL.
- **Automation**: CommandBox CLI.

## ⚙️ Prerequisites

Ensure you have the following installed:
1. [CommandBox CLI](https://commandbox.ortusbooks.com/setup/installation) (6.0+)
2. [BoxLang](https://boxlang.io/) or Adobe ColdFusion 2021+

## 📦 Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd InterviewPrep
   ```

2. **Install Dependencies**:
   ```bash
   box install
   ```

3. **Configure Environment**:
   - Copy `.env.example` to `.env` and configure your database credentials.

4. **Start the Server**:
   ```bash
   box server start
   ```
   *The app will be available at `http://localhost:8080`*

---

## 🏗️ Architecture

This project uses the **Modern ColdBox Template** structure for enhanced security:
- `/app`: Contains all application logic (Handlers, Models, Views) - *Not web-accessible*.
- `/public`: The web root containing only assets and the bootstrap entry point.
- `/lib`: Managed dependencies and modules.

---
Developed with ❤️ by Avinash
