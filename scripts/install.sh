# change app architecture from here
# according to your needs . . .
app_architecture="app-release.apk"
package="com.mediocre.smartlink"

adb install -r "../build/app/outputs/flutter-apk/$app_architecture"
adb shell am start -n $package/.MainActivity