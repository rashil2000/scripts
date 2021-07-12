#include <stdio.h>
#include <windows.h>

int main()
{
    SYSTEM_POWER_STATUS status;
    if (GetSystemPowerStatus(&status))
    {
        unsigned char level = status.BatteryLifePercent;
        if (level != 255) printf("%u ", level);
        unsigned char power = status.ACLineStatus;
        if (power != 255) printf("%u\n", power);
    }
}
