# DocBuddy - Doctor Appointment Booking App

A basic Flutter application for booking doctor appointments with a clean, modern UI and essential features.

## Features

### 🏠 Home Screen
- Welcome dashboard with quick access to main features
- Overview of upcoming appointments
- Navigation to different sections

### 👨‍⚕️ Doctor Search & Booking
- Browse available doctors by specialization
- Search functionality for doctors, specializations, and locations
- Detailed doctor profiles with ratings, experience, and availability
- Real-time availability checking based on doctor schedules

### 📅 Appointment Management
- Book appointments with date and time selection
- Form validation for patient information
- Optional notes for special requirements
- Appointment confirmation with success dialog

### 📋 Appointment History
- View all appointments with filtering options
- Separate tabs for All, Upcoming, and Past appointments
- Appointment status tracking (Confirmed, Pending, Cancelled)
- Cancel appointments with confirmation dialog

### 💾 Data Persistence
- Local storage using SharedPreferences
- Appointments persist between app sessions
- Mock doctor data for demonstration

## Technical Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── doctor.dart          # Doctor data model
│   └── appointment.dart     # Appointment data model
├── screens/
│   ├── home_screen.dart     # Main dashboard
│   ├── doctors_screen.dart  # Doctor listing and search
│   ├── doctor_detail_screen.dart # Doctor profile
│   ├── book_appointment_screen.dart # Booking form
│   └── appointments_screen.dart # Appointment management
├── services/
│   └── appointment_service.dart # Business logic and data management
└── widgets/                 # Reusable UI components
```

### Key Technologies
- **Flutter**: Cross-platform mobile development
- **Provider**: State management
- **SharedPreferences**: Local data persistence
- **intl**: Date formatting and localization

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. **Clone or navigate to the project directory**
   ```bash
   cd docbuddy_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

The app uses the following main dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  intl: ^0.18.1          # Date formatting
  provider: ^6.0.5       # State management
  shared_preferences: ^2.2.0  # Local storage
```

## App Flow

1. **Home Screen**: Users see the main dashboard with navigation options
2. **Find Doctors**: Browse and search for available doctors
3. **Doctor Details**: View doctor information and availability
4. **Book Appointment**: Fill out booking form with patient details
5. **Confirmation**: Receive booking confirmation
6. **Manage Appointments**: View, filter, and cancel appointments

## Mock Data

The app includes sample doctor data for demonstration:

- **Dr. Sarah Johnson** - Cardiologist (4.8★, 15 years exp.)
- **Dr. Michael Chen** - Dermatologist (4.6★, 12 years exp.)
- **Dr. Emily Rodriguez** - Pediatrician (4.9★, 8 years exp.)
- **Dr. James Wilson** - Orthopedic Surgeon (4.7★, 20 years exp.)

Each doctor has:
- Profile information (name, specialization, rating, experience)
- Location details
- Available days and time slots
- Professional image (placeholder)

## Features in Detail

### Doctor Search
- Real-time search filtering
- Search by doctor name, specialization, or location
- Clean card-based UI with doctor information

### Appointment Booking
- Date picker with availability validation
- Time slot selection based on doctor's schedule
- Form validation for required fields
- Optional notes field for special requirements

### Appointment Management
- Tabbed interface for different appointment views
- Status-based filtering and color coding
- Cancel functionality with confirmation
- Detailed appointment information display

### Data Persistence
- Appointments saved locally using SharedPreferences
- JSON serialization for data storage
- Automatic loading of saved appointments on app start

## UI/UX Design

### Design Principles
- **Material Design 3**: Modern, clean interface
- **Responsive Layout**: Works on different screen sizes
- **Intuitive Navigation**: Clear navigation flow
- **Visual Feedback**: Loading states, success messages, error handling

### Color Scheme
- Primary: Blue (#2196F3)
- Success: Green
- Warning: Orange
- Error: Red
- Background: Light gray tones

### Components
- Cards for information display
- Elevated buttons for primary actions
- Outlined buttons for secondary actions
- Chips for tags and status indicators
- Icons for visual enhancement

## Future Enhancements

Potential improvements for a production app:

1. **Backend Integration**
   - Real API endpoints for doctors and appointments
   - User authentication and profiles
   - Push notifications for appointment reminders

2. **Advanced Features**
   - Video consultations
   - Prescription management
   - Medical history tracking
   - Payment integration

3. **Enhanced UI**
   - Dark mode support
   - Custom themes
   - Animations and transitions
   - Accessibility improvements

4. **Data Management**
   - Cloud synchronization
   - Offline support
   - Data backup and restore

## Troubleshooting

### Common Issues

1. **Flutter not found**
   - Ensure Flutter is installed and added to PATH
   - Run `flutter doctor` to check installation

2. **Dependencies not found**
   - Run `flutter pub get` to install dependencies
   - Check `pubspec.yaml` for correct dependency versions

3. **Build errors**
   - Clean and rebuild: `flutter clean && flutter pub get`
   - Check Flutter and Dart SDK versions

4. **App not running**
   - Ensure emulator/device is connected
   - Check for port conflicts
   - Verify device compatibility

## Contributing

This is a basic implementation for learning purposes. For production use, consider:

- Adding proper error handling
- Implementing unit and widget tests
- Adding accessibility features
- Optimizing performance
- Implementing security best practices

## License

This project is for educational purposes. Feel free to use and modify as needed. 