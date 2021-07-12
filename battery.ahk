; Battery charge notification
; Slightly modified version of https://github.com/Hurstwood/Battery-Charge-Alert
;
; When the battery is charged upto `maxCharge`, a notification
; will appear to tell the user to remove the charger
;
; When the battery is below `minCharge`, a notification
; will appear to tell the user to plug in the charger

SetTitleMatchMode 2

percentage := "%"
sleepTime := 300 * 1000 ; Delay in milliseconds
maxCharge := 85 ; Maximum charging percentage
; minCharge := 10 ; Minimum charging percentage

Loop{ ; Loop forever

  ; Grab the current data.
  ; https://docs.microsoft.com/en-us/windows/win32/api/winbase/ns-winbase-system_power_status
  VarSetCapacity(powerstatus, 12) ;1+1+1+1+4+4
  success := DllCall("kernel32.dll\GetSystemPowerStatus", "uint", &powerstatus)

  acLineStatus:=ExtractValue(&powerstatus,0) ; Charger connected
  batteryChargePercent:=ExtractValue(&powerstatus,2) ; Battery charge level

  if (batteryChargePercent > maxCharge){ ; Is the battery charged higher than `maxCharge`
    if (acLineStatus == 1){ ; Only alert if the power lead is connected
      if (batteryChargePercent != 255){	; and if the battery is not disconnected
        output=Unplug the charger.`nBattery Charge Level: %batteryChargePercent%%percentage%
        notifyUser(output)
      }
    }
  }

	/*
  if (batteryChargePercent < minCharge){ ; Is the battery charged less than `minCharge`
    if (acLineStatus == 0){ ; Only alert if the power lead is not connected
      output=Plug the charger.`nBattery Charge Level: %batteryChargePercent%%percentage%
      notifyUser(output)
    }
  }
  */

  sleep, sleepTime
}

; Alert user visually and audibly
notifyUser(message){
  SoundBeep, 1500, 200
  MsgBox, , Battery, %message%,
}

; Format the value from the structure
ExtractValue(p_address, p_offset){
  loop, 1
    value := 0+( *( ( p_address+p_offset )+( a_Index-1 ) ) << ( 8* ( a_Index-1 ) ) )
  return, value
}