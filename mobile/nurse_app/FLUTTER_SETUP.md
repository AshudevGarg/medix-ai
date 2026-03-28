# Flutter Version Setup Guide for Nurse App

## Issue
Current Dart SDK: 3.6.1
Required: ^3.6.2 (pubspec.yaml)
Recommended Flutter: 3.41.6

## Solution: Use Flutter Version Manager (FVM)

### Windows Setup (MINGW64)

#### Option 1: Automatic Setup (Recommended)
Run the setup script:
```bash
cd mobile/nurse_app
bash setup_fvm.sh
```

#### Option 2: Manual Setup

1. **Install FVM** (if not already installed)
   ```bash
   npm install -g fvm@latest
   ```

2. **Install Flutter 3.41.6** in the project
   ```bash
   cd mobile/nurse_app
   fvm install 3.41.6
   ```

3. **Set as project default**
   ```bash
   fvm use 3.41.6
   ```

4. **Run flutter commands through FVM**
   ```bash
   fvm flutter run
   fvm flutter build apk
   ```

### Configure Your IDE

Add to your `.vscode/settings.json`:
```json
{
  "dart.flutterSdkPath": "./mobile/nurse_app/.fvm/flutter_sdk"
}
```

Or use the VS Code command:
- Press `Ctrl+Shift+P`
- Search "Flutter: Change Device or SDK"
- Select the FVM-managed Flutter SDK

### Verify Setup
```bash
fvm which flutter
fvm flutter --version
```

### mprocs Integration
The `.fvmrc` file is already configured to use Flutter 3.41.6 automatically.

To run in mprocs:
```yaml
mobile:
  shell: "bash"
  shell_args: ["-c"]
  command: "fvm flutter run -d windows"  # or -d all for all devices
  cwd: "./mobile/nurse_app"
```

### Troubleshooting

If `fvm` command is not found:
1. Ensure npm is in PATH: `npm -v`
2. Reinstall: `npm install -g fvm@latest --force`
3. Add to PATH if needed (usually automatic)

If still having issues:
```bash
# Use flutter directly with newer version installed globally
flutter upgrade
flutter run
```
