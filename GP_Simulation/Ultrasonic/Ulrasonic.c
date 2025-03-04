/*
 * Ulrasonic.c
 *
 *  Created on: Mar 3, 2025
 *      Author: Rawan Nabih
 */

#include "Ultrasonic.h"

/* ===================== Global Variables Section Start ====================== */
volatile unsigned long pulse_start = 0;
volatile unsigned long pulse_end = 0;
volatile unsigned int measured_time = 0;
volatile unsigned long measured_distance = 0;
/* ===================== Global Variables Section End ======================== */

#define NUMBER_OF_ITERATIONS_PER_ONE_MICRO_SECOND  0.364  // Adjust if needed

static void Delay_US(unsigned long long n);

void Delay_US(unsigned long long n) {
    volatile unsigned long long count = 0;
    while(count++ < (NUMBER_OF_ITERATIONS_PER_ONE_MICRO_SECOND * n));
}

void Ultrasonic_Init(void)
{
    // Enable the clock for Port E
    SYSCTL_RCGCGPIO_REG |= (1 << 4);
    while ((SYSCTL_PRGPIO_REG & 0x05) == 0);                        /* Wait for GPIO Port E to be ready */

    GPIO_PORTE_AMSEL_REG = 0x00;                                   /* Disable analog mode on all pins of Port D */
    GPIO_PORTE_PCTL_REG = 0xFF00FFFF;                              /* Set PCTL to 0 GPIO functionality on all pins*/
    GPIO_PORTE_AFSEL_REG &= ~((1<<4)|(1<<5));                      /* Disable alternative function on PE4 & PE5 */
    GPIO_PORTE_DEN_REG   |= ((1<<4)|(1<<5));                       /* Enable Digital I/O on PE4 & PE5 */
    GPIO_PORTF_DIR_REG   &= ~(1<<5);                               /* Configure PE5 (Echo pin) as input pin */
    GPIO_PORTF_DIR_REG   |= (1<<4);                                /* Configure PE4 (Trigger pin) as output pin */
}


void Ultrasonic_Trigger(void)
{
    GPIO_PORTE_DATA_REG &= ~(1<<4);
    Delay_US(10);
    GPIO_PORTE_DATA_REG |= (1<<4);
    Delay_US(10);
    GPIO_PORTE_DATA_REG &= ~(1<<4);
}


unsigned long Ultrasonic_GetDistance(void)
{
    unsigned long measured_distance = 0;
    unsigned long measured_time = 0;
    Ultrasonic_Trigger();

    //return measured_distance;
    while (GET_BIT(GPIO_PORTE_DATA_REG, 5) == 0);
    while (GET_BIT(GPIO_PORTE_DATA_REG, 5) != 0)
    {
        measured_time++;
        Delay_US(10);
    }
    measured_distance = (measured_time * 340.0)/(2*1000); //to convert to cm
    return measured_distance;

}



void Monitor_DIST(void)
{
    unsigned long measured_Distance = Ultrasonic_GetDistance();
    if (measured_Distance < DISTANCE_THRESHOLD) {
        UART0_SendString("Near Collision");
        GPIO_PORTF_DATA_REG |= (1<<1);                //turn on the Red LED
        DC_MOTORA_STOP();
        DC_MOTORB_STOP();
        DC_MOTORC_STOP();
        DC_MOTORD_STOP();
    }
}


