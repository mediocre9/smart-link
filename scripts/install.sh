# change app architecture from here
# according to your needs . . .
app_architecture="app-armeabi-v7a-release.apk"

X86_64="x86_64"
ARM_V7="armeabi-v7a"
ARM64_V8="arm64-v8a"

adb install -r "../build/app/outputs/flutter-apk/$app_architecture"
read