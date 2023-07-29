echo off & cls & cd ..
echo building in release mode . . .
flutter build apk --split-per-abi
pause