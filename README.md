# 🐻 Login Screen with Rive Animation

## ✨ Project Overview

This project implements a modern login screen in Flutter, featuring a responsive, interactive animation powered by Rive. The main functionality is to manage user input fields (email and password) and trigger different animation states (e.g., idle, success, failure) based on the input validation and simulated login process. This dramatically enhances the user experience by providing dynamic visual feedback during interaction.

## 🚀 What is Rive & State Machine?

**Rive** is a cutting-edge real-time interactive design tool that allows designers and developers to create complex vector animations that can be integrated directly into applications. It eliminates the need for exporting large image sequences or writing complex code for motion, ensuring high performance and cross-platform consistency.

A **State Machine** in Rive is the core logic system used to control the flow and behavior of an animation. It defines different animation states (e.g., "Idle," "Typing," "Success," "Error") and the conditions (inputs like "boolean," "number," or "trigger") that transition the animation from one state to another. This is crucial for creating interactive animations that respond dynamically to user actions within the app, such as a character reacting to input validation.

## 💻 Tech Stack

* **Framework:** Flutter (Dart)
* **Animation Tool:** Rive
* **Package:** `rive: ^0.13.0` (Use the latest stable version)

## 📁 Project Structure (Basic Structure & Key Files)

The project follows the standard Flutter structure, with the main logic encapsulated in specific files for better organization. The key files inside the `lib/` directory are:

lib/ ├── main.dart # Main entry point of the application. ├── screens/ │ └── login_screen.dart # Contains the main UI, form handling, and the Rive animation implementation. ├── widgets/ │ ├── custom_text_field.dart # Reusable widget for styled form inputs. │ └── rive_animation_player.dart # Widget dedicated to loading and controlling the Rive file and its State Machine inputs. └── utils/ └── validators.dart # Utility class for form field validation logic (e.g., checking email format).

### 📦 Base Project Creation in Flutter

The project was initialized using the standard `flutter create` command. The main directories and their purposes, as discussed in class, are:

* **`lib/`**: Contains all the application's Dart source code. This is where development takes place.
* **`android/`** and **`ios/`**: Contain the platform-specific wrapper code necessary to run the Flutter engine on each platform.
* **`test/`**: Used for unit and widget testing code.
* **`pubspec.yaml`**: The configuration file that manages project dependencies (like the Rive package), assets (like the Rive file), and project metadata.

## 🛠️ Code Development

This section details the essential steps taken to construct the application, integrating the Rive animation with Flutter's form handling.

1.  **Dependency Setup:** The `rive` package was added to `pubspec.yaml`, and the Rive asset file was added to the `assets` folder and declared in `pubspec.yaml`.
2.  **Rive Controller Initialization:** In `login_screen.dart`, a `RiveAnimationController` was initialized, specifically targeting the required **State Machine** within the Rive file (e.g., "Login Machine").
3.  **Input Handling & State Management:** Form fields (email and password) were set up using `TextEditingController`s. The `onChanged` and `onSubmitted` callbacks were used to grab user input.
4.  **Connecting Flutter to Rive:** Key **State Machine Inputs** (e.g., `isEmailValid` boolean, `triggerLogin` trigger) were retrieved from the Rive controller. When a user action occurs (e.g., validation fails or the login button is pressed), the corresponding Rive input is set or triggered, making the animation react.


## 🎬 Demo

A GIF demonstrating the complete functionality, including the interaction with the input fields and the resulting Rive state changes (e.g., successful or failed login animation), should be placed here.

![Login Screen Demo](assets/GIF GAXIOLA 2.gif)

## 🧠 Conclusions and Reflections

[**Insert detailed explanation and reflection here.**]
* *Example topics to cover:* How Rive simplified complex animations, challenges encountered with state management between Flutter and the Rive State Machine, and the overall benefit of dynamic feedback on user experience.

## 🎓 Credits & Acknowledgments

This project was developed as an academic exercise and utilizes a publicly available Rive asset for demonstration.

* **Course Name (Materia):** **Graficación**
* **Teacher's Name (Docente):** **Rodrigo Fidel Gaxiola Sosa**
* **Rive Animation Creator:** **Rive - JcToon**
