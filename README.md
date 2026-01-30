# LÖVE 2D Game Suite: Modular Architecture Study
### LÖVE Engine | Lua | OOP Refactoring

![Engine](https://img.shields.io/badge/Engine-LÖVE%202D-pink?style=flat&logo=lua)
![Language](https://img.shields.io/badge/Language-Lua-blue?style=flat&logo=lua)
![Status](https://img.shields.io/badge/Status-Educational%20Refactor-purple)

> **Engineering Context:** This repository serves as a study in **Code Refactoring** and **State Management**. It takes multiple distinct gameplay prototypes and unifies them into a single executable suite using a custom Object-Oriented architecture.

---

## 🎓 Attribution & Ethical Disclosure
**Core Game Design & Assets:**
This project is built upon the foundational curriculum provided by **Kyle Schaub**. The original game mechanics, sprite assets, and initial logic were developed following his course:
* **Course:** [Lua and LÖVE 2D Game Development (Udemy)](https://www.udemy.com/course/lua-love)
* **Instructor:** Kyle Schaub

**Developer Contribution:**
While the core gameplay logic is derived from the tutorial, my contribution focused on **Software Architecture**:
1.  **Suite Integration:** Merging independent game prototypes into a single unified application.
2.  **OOP Refactoring:** Converting procedural tutorial code into modular Classes and Objects.
3.  **State Management:** Implementing a "Main Menu" system to switch contexts dynamically.

---

## 🔧 Engineering Features

### 1. Object-Oriented Refactoring (AI-Assisted)
The original procedural code was refactored into a scalable Object-Oriented patterns using **Classic.lua** (or similar class libraries).
-   **Encapsulation:** Game entities (Enemies, Players) are encapsulated in dedicated classes rather than global tables.
-   **AI-Augmented Workflow:** Utilized **ChatGPT** to analyze procedural blocks and propose modular class structures, accelerating the transition to OOP standards.

### 2. State Machine Architecture
-   **Module Switching:** Implemented a `GameState` manager that handles loading/unloading of resources when switching between the Main Menu, Platformer, and Top-Down Shooter modes.
-   **Dynamic Resolution:** The window manager adjusts resolution and scaling based on the requirements of the active module.

### 3. Testing & Validation
-   **Unit Testing:** Integrated **Luna Test** to verify logic stability during the refactoring process.

---

## 📂 Project Structure

```text
Love_suite/
├── main.lua          # Entry point & State Manager
├── conf.lua          # LÖVE Configuration
├── modules/
│   ├── menu/         # Custom Main Menu Logic
│   ├── game1/        # Refactored Platformer
│   └── game2/        # Refactored Shooter
├── lib/
│   ├── classic/      # OOP Library
│   └── lunatest/     # Unit Testing Framework
└── assets/           # Sprite & Audio Resources (Credit: Kyle Schaub)
```

---

🚀 How to Run
Note: This repository contains source code only. No compiled binaries are provided.

1. Install LÖVE 2D.
2. Clone this repository.
3. Drag the project folder onto the love.exe executable (or run love . in terminal).

---

👤 Author (Refactoring & Suite Logic)
Christopher Jepson Technical Artist & Software Engineer [LinkedIn](https://www.linkedin.com/in/christopher-jepson-310a84308) | [Email](mailto:christopher.j.jepson@gmail.com)
