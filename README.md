🚀 MediGo – Smart Autonomous Medical Delivery System

A full IoT-based solution designed to automate the transportation of medications inside hospitals using an autonomous robot.
The system connects mobile devices, robot hardware, a backend service, and cloud infrastructure, providing real-time control, monitoring, and secure delivery confirmation.

🌟 Features
✅ Autonomous Medication Delivery

The robot receives delivery commands and navigates to patient rooms based on backend instructions.

✅ Nurse Mobile Application (Flutter)

View assigned medication deliveries

Confirm deliveries using RFID scan or a mobile button

Receive alerts and robot status in real time

✅ Pharmacist Web Interface

Create and update prescriptions

Trigger medication delivery requests

Monitor delivery progress

✅ Backend API (FastAPI + MySQL)

JWT Authentication

Roles: Nurse, Pharmacist, Admin

Prescription management

Robot command dispatching

Logging & reporting

✅ Robot Embedded System (ESP8266/ESP32)

Receives commands via HTTP/MQTT

Motor control + servo system for medication compartment

Sends delivery status and alarms back to Cloud

Integrates RFID reader for delivery confirmation

✅ Azure Cloud Integration

Hosts backend

Stores all prescription and delivery data

Provides scalability & monitoring

🛠️ Tech Stack
🔹 Hardware

ESP32 / ESP8266 microcontroller

Servo Motor (compartment opening)

Motor driver (movement)

RFID Reader (RC522)

LEDs (status indicators)

Battery pack / power module

🔹 Robot Firmware

Arduino IDE (C++)

Libraries:

ESP8266WiFi / WiFi.h

ESPAsyncWebServer

MFRC522 (RFID)

Servo, Wire

MQTT client (optional)

🔹 Backend

FastAPI (Python)

JWT Authentication

SQLAlchemy ORM

MySQL database

Uvicorn ASGI Server

Cron jobs for Cloud updates

🔹 Mobile Application

Flutter (Dart)

HTTP Client with JWT Token

Provider / Riverpod state management

JSON REST API integration

🔹 Communication

HTTP for robot commands

MQTT (optional) for status updates

REST API for mobile & web clients

⚙️ Setup & Installation
✅ 1. Backend Setup (FastAPI)
Prerequisites

Python 3.10+

MySQL Server

pip installed

Installation
git clone https://github.com/your-username/your-repo-name.git
cd medigo/backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt

Environment Configuration

Create a .env file:

DATABASE_URL=mysql+mysqlconnector://user:password@localhost/medigo
SECRET_KEY=your_secret_key
ACCESS_TOKEN_EXPIRE_MINUTES=120

Run the server
uvicorn app.main:app --reload


Backend docs available at:

http://127.0.0.1:8000/docs

✅ 2. Mobile Application (Flutter)
Prerequisites

Flutter SDK installed

Android Studio / VS Code

Installation
cd medigo/mobile_app
flutter pub get
flutter run

✅ 3. Robot Firmware Installation (ESP32/ESP8266)
Prerequisites

Arduino IDE installed

ESP32/ESP8266 board packages installed

Setup

Open robot.ino in Arduino IDE

Update WiFi credentials:

const char* ssid = "your_wifi";
const char* password = "your_password";


Update backend API server IP:

String server = "http://YOUR_BACKEND_IP:8000";


Flash code to ESP32/ESP8266.

Run

Robot will automatically connect to WiFi

Awaits commands from backend

Sends delivery confirmation via RFID

✅ 4. Cloud Setup (Azure)

Components:

Azure App Service → deploy FastAPI

Azure MySQL Database server

Azure Monitor → logs & alerts

(Optional)

Azure IoT Hub → for MQTT communication

🚀 Usage Workflow

Pharmacist enters new prescription in web interface

Backend stores prescription in MySQL

Pharmacist triggers “Send to Robot”

Robot receives delivery command → moves toward patient

Nurse Mobile App shows live delivery status

Nurse scans RFID tag to confirm delivery

Robot sends confirmation to backend

Backend → Cloud → Dashboard updates status to “Delivered”

📈 Future Improvements

✅ Real-time dashboard with WebSockets
✅ Add indoor navigation (ultrasonic/map-based)
✅ Cloud logging of all robot positions
✅ Add QR code confirmation for medicine pickup
✅ Add admin dashboard for hospital management
✅ Build a multi-robot fleet management system
