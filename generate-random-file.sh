#!/bin/bash

if [[ -z "$OSTYPE" || "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
	echo "Running on Windows"
#   $base64 = [System.Convert]::ToBase64String((New-Object -TypeName Byte[] 1000))
#   $base64.Substring(0, 1000) | Out-File -FilePath src/file.txt
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Running on a Mac"
	dd if=/dev/random bs=1 count=1000 >src/file.txt
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	if type "apt-get" >/dev/null; then
		echo "Running on Ubuntu/Debian-based Linux"
		base64 /dev/urandom | head -c 1000 >src/file.txt
	else
		echo "Unsupported Linux distribution"
	fi
else
	echo "Unsupported operating system"
fi
