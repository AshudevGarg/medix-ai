class Config {
  // Local FastAPI backend - Backend is running at http://localhost:8000
  // For Android Emulator use 10.0.2.2
  // For iOS Simulator use localhost
  // For Real Device use your computer's IP address (192.168.0.7)

  // IMPORTANT: This is auto-updated by setup-ip.sh - modify the .env file to change
  static const String apiBaseUrl =
      'http://10.95.55.131:8000'; // Real device (YOUR IP)

  // API Endpoints - Updated for new modular backend
  static const String patientsEndpoint = '$apiBaseUrl/patients';
  static const String queueEndpoint = '$apiBaseUrl/queue';
  static const String uploadAudioEndpoint = '$apiBaseUrl/upload/audio';
  static const String uploadImageEndpoint = '$apiBaseUrl/upload/image';
  static const String notesEndpoint = '$apiBaseUrl/notes';
  static const String historyEndpoint = '$apiBaseUrl/history';
  static const String statsEndpoint = '$apiBaseUrl/stats';

  // App Info
  static const String appName = 'Medix AI';
  static const String appVersion = '1.0.0';
  static const String nurseName = 'Nurse Rekha';
}
