# Kill Real-Time Vocabulary Quiz Coding Challenge

## Overview

Develop a real-time vocabulary quiz app using a full-stack Google strategy, leveraging Flutter for the frontend and Google Cloud Platform (Cloud Run, Firestore, and Firebase Authentication) for the backend to support real-time score updates and leaderboards.

## System Design

### Architecture Diagram
![elsa-challenge drawio](https://github.com/troyvnit/elsa-real-time-quiz-app/assets/3962888/025ab7f1-8a69-40c5-b0d1-45a0f4d52d8e)

1. **Frontend**:

   - **Flutter Application**: Runs on iOS, Android, Desktop, and Web. Communicates with the backend through HTTPS and WebSocket.

2. **Backends**:

   - **Node.js Server**: Hosted on Google Cloud Run. Manages API requests, WebSocket connections, and business logic.
   - **Firestore**: Stores quiz data, user scores, and leaderboard information.
   - **Firebase Authentication**: Manages user authentication.

3. **GCP Components**:

   - **Cloud Run**: Deploys and scales the Node.js server.
   - **Firestore**: Serves as the NoSQL database.
   - **Firebase Authentication**: Provides secure user authentication.

4. **Data Flow**:
   - User joins a quiz using a unique quiz ID.
   - User submits answers via WebSocket.
   - Backend calculates the score and updates Firestore.
   - Real-time leaderboard updates are sent to all participants via WebSocket.

### Component Description

1. **Frontend**:

   - Cross-platform UI.
   - Handles user interactions, displays questions, and shows the leaderboard.

2. **Backends**:

   - **Controllers**: Handle API requests and WebSocket connections.
   - **Services**: Contains business logic (e.g., calculating scores, updating Firestore).
   - **Routes**: Defines API endpoints.

3. **GCP Components**:
   - **Cloud Run**: Executes the backend server in a containerized environment.
   - **Firestore**: Stores data in a scalable NoSQL database.
   - **Firebase Authentication**: Secures user authentication.

### Technologies and Tools

1. **Frontend**: Flutter
2. **Backend**: Node.js, Express, Socket.IO
3. **Database**: Firestore
4. **Authentication**: Firebase Authentication
5. **GCP Services**: Cloud Run, Firestore, Firebase Authentication
