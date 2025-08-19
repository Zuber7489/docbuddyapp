# 🏥 DocBuddy - Healthcare Appointment Management System

A comprehensive Flutter application for managing healthcare appointments with role-based access control for patients, doctors, and administrators.

## 📱 Features

### 🔐 Authentication System
- **Multi-role Login**: Patients, Doctors, and Super Admin
- **Secure Authentication**: Role-based access control
- **User Registration**: New patient signup functionality

### 👨‍⚕️ Doctor Management
- **5 Pre-configured Doctors** with different specializations
- **Admin Panel**: Doctors can manage their appointments
- **Appointment Approval**: Approve/reject patient requests
- **Availability Management**: Set working hours and schedules

### 👑 Super Admin Panel
- **System Overview**: Dashboard with statistics
- **Doctor Management**: View all registered doctors
- **Account Credentials**: Access to all doctor login details
- **System Analytics**: Appointment breakdown and insights

### 📅 Appointment System
- **Booking Workflow**: Request → Pending → Approved/Rejected → Completed
- **Status Tracking**: Real-time appointment status updates
- **Patient Management**: View and manage appointments

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (3.0 or higher)
- Android Studio / VS Code
- Android Device or Emulator
- USB Debugging enabled (for physical device)

### Step 1: Clone and Setup
```bash
# Navigate to project directory
cd docbuddy_app

# Install dependencies
flutter pub get

# Clean previous builds
flutter clean
```

### Step 2: Build and Install
```bash
# For Android APK
flutter build apk --release

# For Android App Bundle (recommended for Play Store)
flutter build appbundle --release

# Install on connected device
flutter install
```

### Step 3: Troubleshooting USB Issues
If you're experiencing issues with old APK showing after USB disconnect:

```bash
# 1. Uninstall existing app
adb uninstall com.example.docbuddy_app

# 2. Clean Flutter cache
flutter clean

# 3. Get dependencies again
flutter pub get

# 4. Build fresh APK
flutter build apk --release

# 5. Install new APK
flutter install
```

## 🔑 Login Credentials

### Super Admin
- **Username**: `admin`
- **Password**: `admin123`

### Doctors (5 Pre-configured Accounts)

| Doctor | Specialization | Username | Password |
|--------|---------------|----------|----------|
| Dr. Sarah Johnson | Cardiologist | `dr.sarah` | `cardio123` |
| Dr. Michael Chen | Dermatologist | `dr.michael` | `derma456` |
| Dr. Emily Rodriguez | Pediatrician | `dr.emily` | `pediatric789` |
| Dr. James Wilson | Orthopedic Surgeon | `dr.james` | `ortho012` |
| Dr. Lisa Thompson | Neurologist | `dr.lisa` | `neuro345` |

### Patients
- New patients can register through the signup screen
- Use email and password for login

## 📋 System Architecture

### Models
- `User`: Authentication and user management
- `Doctor`: Doctor profiles and specializations
- `Appointment`: Appointment booking and management

### Services
- `AuthService`: User authentication and role management
- `AppointmentService`: Appointment CRUD operations

### Screens
- `LoginScreen`: Multi-role authentication
- `HomeScreen`: Patient dashboard
- `DoctorsScreen`: Find and book doctors
- `AppointmentsScreen`: Manage appointments
- `DoctorAdminScreen`: Doctor's admin panel
- `SuperAdminScreen`: System administration

## 🔧 Development

### Project Structure
```
lib/
├── models/
│   ├── user.dart
│   ├── doctor.dart
│   └── appointment.dart
├── services/
│   ├── auth_service.dart
│   └── appointment_service.dart
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── doctors_screen.dart
│   ├── appointments_screen.dart
│   ├── doctor_admin_screen.dart
│   └── super_admin_screen.dart
└── main.dart
```

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  shared_preferences: ^2.0.0
  intl: ^0.18.0
```

## 🐛 Common Issues & Solutions

### 1. Old APK Showing After USB Disconnect
**Problem**: Device shows old version after USB disconnect
**Solution**:
```bash
# Uninstall completely
adb uninstall com.example.docbuddy_app

# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
flutter install
```

### 2. Build Errors
**Problem**: Compilation errors
**Solution**:
```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Check for issues
flutter doctor

# Rebuild
flutter build apk
```

### 3. Device Not Detected
**Problem**: Flutter can't find device
**Solution**:
```bash
# Check connected devices
flutter devices

# Enable USB debugging on device
# Settings > Developer Options > USB Debugging

# Restart ADB
adb kill-server
adb start-server
```

### 4. Permission Issues
**Problem**: App crashes due to permissions
**Solution**: Ensure these permissions in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## 📱 App Features Walkthrough

### For Patients
1. **Login/Signup**: Create account or login
2. **Find Doctors**: Browse available specialists
3. **Book Appointments**: Request appointments
4. **Track Status**: Monitor appointment status
5. **Manage Profile**: Update personal information

### For Doctors
1. **Login**: Use assigned credentials
2. **View Appointments**: See pending requests
3. **Approve/Reject**: Manage appointment requests
4. **Update Status**: Mark appointments as completed
5. **View Patient Info**: Access patient details

### For Super Admin
1. **System Overview**: Dashboard with statistics
2. **Doctor Management**: View all registered doctors
3. **Account Access**: Access doctor credentials
4. **System Analytics**: Monitor appointment trends

## 🔒 Security Features

- **Role-based Access Control**: Different permissions for each user type
- **Secure Authentication**: Password-protected login
- **Data Validation**: Input validation and error handling
- **Session Management**: Proper logout functionality

## 📊 Data Persistence

- **SharedPreferences**: Local storage for user sessions
- **In-Memory Storage**: Mock data for development
- **JSON Serialization**: Data model serialization

## 🎨 UI/UX Features

- **Modern Design**: Material Design 3 components
- **Gradient Themes**: Beautiful purple gradient theme
- **Responsive Layout**: Works on all screen sizes
- **Smooth Animations**: Professional transitions
- **Status Indicators**: Color-coded appointment statuses

## 🚀 Deployment

### For Production
```bash
# Build release APK
flutter build apk --release

# Build App Bundle (Play Store)
flutter build appbundle --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
# Bundle location: build/app/outputs/bundle/release/app-release.aab
```

### For Testing
```bash
# Debug build
flutter build apk --debug

# Profile build
flutter build apk --profile
```

## 📞 Support

If you encounter any issues:

1. **Check Flutter Doctor**: `flutter doctor`
2. **Clean and Rebuild**: `flutter clean && flutter pub get`
3. **Check Device Connection**: `flutter devices`
4. **Review Error Logs**: Check console output

## 🔄 Version History

- **v1.0.0**: Initial release with basic functionality
- **v1.1.0**: Added authentication system
- **v1.2.0**: Added admin panels
- **v1.3.0**: Added appointment approval system
- **v1.4.0**: UI/UX improvements and bug fixes

---

**Note**: This is a development version. For production use, implement proper backend services, database integration, and security measures. 