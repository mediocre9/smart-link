echo "Host IP Address: "
read val

adb tcpip 5555
adb connect $val
Sleep 1000
read