

/**
 * main.c
 */

/* ===================== Include Section Start =========================== */
#include "tm4c123gh6pm_registers.h"
#include "common_macros.h"
#include "UART/UART.h"
#include "DC_Motors/DC_motors.h"
#include "Ultrasonic/Ultrasonic.h"
#include "Buttons_and_LEDS/Buttons_and_LEDS.h"
/* ===================== Include Section End ============================= */

int main(void)
{
    unsigned char command[3];  // Array to store received string (max 2 characters + null terminator)

    //initialize all systems
    SW1_Init();
    Led_Red_Init();
    DC_MOTORA_INIT();
    DC_MOTORB_INIT();
    DC_MOTORC_INIT();
    DC_MOTORD_INIT();
    UART0_Init();
    Ultrasonic_Init();

    //Taking input from user to start the system
    UART0_SendString("Please Enter ON to start the System .\n");

    while (1) {
            UART0_ReceiveString(command);  // Receive full string from user

            if (command[0] == 'O' && command[1] == 'N' && command[2] == '\0') {  // Check if input is "ON"
                UART0_SendString("System Started...\n");

                while (1) {
                    Monitor_DIST();  // Continuously monitor distance
                }
            }
        }
}
