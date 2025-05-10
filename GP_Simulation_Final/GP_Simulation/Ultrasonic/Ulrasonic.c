/*
 * Ultrasonic.c
 *
 *  Created on: Mar 3, 2025
 *      Author: Rawan Nabih
 */

#include "Ultrasonic.h"


void Ultrasonic_Init(void)
{
    // Enable the clock for Port E
    SYSCTL_RCGCGPIO_REG |= (1 << 4);
    while ((SYSCTL_PRGPIO_REG & (1 << 4)) == 0);  // Wait until Port E is ready

    GPIO_PORTE_AMSEL_REG &= ~((1 << 4) | (1 << 5));        // Disable analog on PE4, PE5
    GPIO_PORTE_AFSEL_REG &= ~((1 << 4) | (1 << 5));        // Disable alternate function on PE4, PE5
    GPIO_PORTE_PCTL_REG  &= ~((0xF << 16) | (0xF << 20));   // Clear PCTL for PE4, PE5 to select GPIO
    GPIO_PORTE_DEN_REG   |= (1 << 4) | (1 << 5);           // Enable digital on PE4, PE5
    GPIO_PORTE_DIR_REG   |= (1 << 4);                      // PE4 as output (Trigger)
    GPIO_PORTE_DIR_REG   &= ~(1 << 5);                     // PE5 as input (Echo)
}

void Ultrasonic_Trigger(void)
{
    GPIO_PORTE_DATA_REG |= (1 << TRIGGER_PIN);
    volatile int i =0;
    for (i= 0; i < 160; i++);  // 10 µs delay (at 16 MHz, 1 cycle = 62.5 ns)
    GPIO_PORTE_DATA_REG &= ~(1 << TRIGGER_PIN);
}


