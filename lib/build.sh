
#!/bin/bash

# Check if Flutter SDK is already cached
if [ ! -d "flutter" ]; then
  echo "Cloning Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

export PATH="$PATH:`pwd`/flutter/bin"

# Enable web support
flutter config --enable-web

# Get Flutter packages
flutter pub get

# Build the Flutter web app
flutter build web --release

