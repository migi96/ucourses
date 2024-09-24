
#!/bin/bash

# Install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable --depth 1

export PATH="$PATH:`pwd`/flutter/bin"

# Accept Android licenses (if needed)
flutter doctor --android-licenses

# Run Flutter doctor
flutter doctor

# Enable web support
flutter config --enable-web

# Get Flutter packages
flutter pub get

# Build the Flutter web app
flutter build web --release
