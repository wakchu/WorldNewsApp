# WorldNewsApp

## Overview

WorldNewsApp is a mobile application that allows users to explore the latest news headlines by selecting countries on an interactive map. Stay informed about global events and dive into country-specific news with ease.

## Features

*   **Interactive Map:** Visually select countries to view their news.
*   **Latest News:** Get up-to-date news headlines for chosen countries.
*   **User Authentication:** Secure user registration and login.
*   **Favorite Countries:** Save your preferred countries for quick access to their news.
*   **Bookmark News:** Bookmark your preferred news for reading it later.

## Technologies Used

### Backend (newsmap-backend)

*   **Framework:** Spring Boot
*   **Language:** Java
*   **Build Tool:** Maven
*   **Security:** Spring Security (JWT)
*   **Database Interaction:** Spring Data JPA

### Frontend (newsmap-frontend)

*   **Platform:** iOS
*   **Language:** Swift
*   **Framework:** SwiftUI
*   **Networking:** URLSession
*   **Authentication:** Keychain for secure token storage

### Database (newsmap-database)

*   **Type:** SQL (script provided)

## Project Structure

*   `newsmap-backend/`: Contains the Spring Boot backend application.
*   `newsmap-frontend/`: Contains the iOS frontend application.
*   `newsmap-database/`: Contains the SQL script for setting up the database.

## Setup Instructions

To get the WorldNewsApp up and running on your local machine, follow these steps:

### 1. Database Setup

1.  Ensure you have a PostgreSQL (or compatible) database server installed and running.
2.  Create a new database for the application (e.g., `worldnews_db`).
3.  Execute the `newsmap-database/Database_WorldNewsApp.sql` script against your newly created database to set up the necessary tables and initial data.

### 2. Backend Setup (newsmap-backend)

1.  Navigate to the `newsmap-backend` directory:
    ```bash
    cd newsmap-backend
    ```
2.  Configure your database connection:
    *   Copy `src/main/resources/application-example.properties` to `src/main/resources/application.properties`.
    *   Edit `application.properties` with your database credentials and settings.
3.  Build the backend application using Maven:
    ```bash
    ./mvnw clean install
    ```
4.  Run the backend application:
    ```bash
    ./mvnw spring-boot:run
    ```
    The backend will typically run on `http://localhost:8080`.

### 3. Frontend Setup (newsmap-frontend)

1.  Navigate to the `newsmap-frontend` directory:
    ```bash
    cd newsmap-frontend
    ```
2.  Open the `newsmap-frontend.xcodeproj` file using Xcode.
3.  Configure the backend API URL:
    *   Open `newsmap-frontend/Resources/Config.plist`.
    *   Update the `API_BASE_URL` entry to point to your backend (e.g., `http://localhost:8080`).
4.  Select a target device or simulator in Xcode.
5.  Build and run the application from Xcode.

## How to Use

1.  **Register/Login:** Upon launching the app, register a new account or log in with existing credentials.
2.  **Explore Map:** Once logged in, you will see an interactive map. Tap on any country to view its latest news.
3.  **Favorites:** Mark countries as favorites to quickly access their news from a dedicated section.

Enjoy staying updated with WorldNewsApp!
