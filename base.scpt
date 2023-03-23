set vpn_name to "mercurio-vpn-prod"
tell application "System Events"
	set opExec to "/usr/local/bin/op"
	set opOTP to do shell script opExec & " item get " & vpn_name & " --otp"
	set the clipboard to opOTP
end tell
tell application "Tunnelblick"
	connect vpn_name
	set secondsLeft to 5
	# проверяем что окно появилось
	tell application "System Events"
		repeat until window "Tunnelblick: Login Required" of process "Tunnelblick" exists
			tell me to log "Does not open"
			if secondsLeft is 0 then
				error "Failed to bring up Tunnelblick login"
			end if
			set secondsLeft to secondsLeft - 1
			delay 1
		end repeat
		delay 1
		# вставляем OTP код
		keystroke (opOTP as string)
		delay 1
		keystroke return
		delay 1
	end tell
	get state of first configuration where name = vpn_name
	repeat until result = "CONNECTED"
		delay 3
		get state of first configuration where name = vpn_name
	end repeat
end tell