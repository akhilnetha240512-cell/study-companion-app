#!/bin/bash
set -e
cd /workspaces/study-companion-app
if [ ! -d "study-companion-app" ]; then
  unzip -o study-companion-app*.zip
fi
cd study-companion-app
npm install
npx cap add android || true
npx cap sync android
sudo apt-get update && sudo apt-get install -y openjdk-17-jdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

if [ ! -d "$HOME/android-sdk" ]; then
  mkdir -p $HOME/android-sdk/cmdline-tools
  cd $HOME/android-sdk/cmdline-tools
  wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
  unzip -q commandlinetools-linux-11076708_latest.zip
  mv cmdline-tools latest
fi
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
yes | sdkmanager --licenses > /dev/null
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

cd /workspaces/study-companion-app/study-companion-app/android
echo "sdk.dir=$HOME/android-sdk" > local.properties

echo ""
echo "=== Setup complete. Now run: ==="
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
echo "cd /workspaces/study-companion-app/study-companion-app/android"
echo "./gradlew bundleRelease"
