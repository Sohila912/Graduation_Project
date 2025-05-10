

/**
 * main.c
 */

/* ===================== Include Section Start =========================== */
#include "tm4c123gh6pm_registers.h"
#include "common_macros.h"
#include "UART/UART.h"
#include "DC_Motors/DC_motors.h"
#include "Ultrasonic/Ultrasonic.h"
#include "Systick_Timer/Systick_Timer.h"
#include "Buttons_and_LEDS/Buttons_and_LEDS.h"
#include <stdbool.h>
/* ===================== Include Section End ============================= */

/********************************************* global variables*****************************************************/

#define TRIGGER_PIN 4
#define ECHO_PIN    5
#define DISTANCE_THRESHOLD        8                        /* Distance threshold */


volatile unsigned long  echo_time = 0;
volatile bool echo_active = false;
volatile unsigned long  measured_distance_cm = 0;


void SystickTimer_Handler(void)
{
    if (echo_active) {
           echo_time++;
       }
}


unsigned long Ultrasonic_GetDistance(void)
{
    echo_time = 0;
    echo_active = false;

    Ultrasonic_Trigger();

    // Wait for echo to go HIGH
    while ((GPIO_PORTE_DATA_REG & (1 << ECHO_PIN)) == 0);

    echo_active = true;

    // Wait for echo to go LOW
    while ((GPIO_PORTE_DATA_REG & (1 << ECHO_PIN)) != 0);

    echo_active = false;

    // Calculate distance (echo_time * 10 us * 0.0343 cm/us) / 2
    float total_time_us = echo_time * 10.0;
    float distance = (total_time_us * 0.0343) / 2.0;

    return (unsigned long)distance;
}



void Monitor_DIST(void) {
     unsigned long measured_Distance = Ultrasonic_GetDistance();

     if (measured_Distance <= DISTANCE_THRESHOLD) {
             UART0_SendString("Near Collision\r\n");
             GPIO_PORTF_DATA_REG |= (1 << 1);  // Turn on Red LED

             // Stop motors
             DC_MOTORC_STOP();
             DC_MOTORD_STOP();
         }
         else if (measured_Distance > 35) {
             UART0_SendString("Out of Reach\r\n");

             // Resume motors if previously stopped
             DC_MOTORC_START();
             DC_MOTORD_START();

             GPIO_PORTF_DATA_REG &= ~(1 << 1); // Turn off Red LED
         }
         else {
             UART0_SendString("Distance = ");
             UART0_SendByte((measured_Distance / 10) + '0');
             UART0_SendByte((measured_Distance % 10) + '0');
             UART0_SendString(" cm\r\n");

             // Resume motors
             DC_MOTORC_START();
             DC_MOTORD_START();

             GPIO_PORTF_DATA_REG &= ~(1 << 1); // Turn off Red LED
         }
}

int main(void)
{
    unsigned char command[3];  // Array to store received string (max 2 characters + null terminator)

    //initialize all systems
    SW1_Init();
    Led_Red_Init();
    SysTick_Init();
    UART0_Init();
    Ultrasonic_Init();
    DC_MOTORC_INIT();
    DC_MOTORD_INIT();
    UART0_SendString("The system is initialized successfully............................. \r\n");

    //Taking input from user to start the system
    UART0_SendString("Please Enter ON# to start the System: ");

    while (1) {
            UART0_ReceiveString(command);  // Receive full string from user

            if (command[0] == 'O' && command[1] == 'N' && command[2] == '\0') {  // Check if input is "ON"
                UART0_SendString("System Started.....................\r\n");
                DC_MOTORC_START();
                DC_MOTORD_START();

                while (1) {
                    Monitor_DIST();  // Continuously monitor distance
                }
            }
        }
}
