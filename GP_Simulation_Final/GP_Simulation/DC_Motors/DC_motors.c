/*
 * DC_motors.c
 *
 *  Created on: Mar 3, 2025
 *      Author: Rawan Nabih
 */

#include "DC_motors.h"

#define NUMBER_OF_ITERATIONS_PER_ONE_MILI_SECOND    364
static void Delay_MS(unsigned long long n);

void Delay_MS(unsigned long long n){
    volatile unsigned long long count = 0;
    while(count++ < (NUMBER_OF_ITERATIONS_PER_ONE_MILI_SECOND * n));
}


void DC_MOTORC_INIT(void){
    /***
     * Port E Pin 0 for IN1 (FORWARD)
     * Port E Pin 1 for IN2 (REVERSE)
     * Port E Pin 2 for ENA
     ***/
    SYSCTL_RCGCGPIO_REG |= (1<<4); // Enable clock for Port E
    while((GET_BIT(SYSCTL_PRGPIO_REG,4) == 0)); // Wait for clock to stabilize

    GPIO_PORTE_AMSEL_REG &= ~((1<<0) | (1<<1) | (1<<2));  /* Disable Analog on PE0, PE1, PE2 */
    GPIO_PORTE_PCTL_REG  &= 0xFFFFFF00;                   /* Clear PMCx bits to use as GPIO */
    GPIO_PORTE_DIR_REG   |= ((1<<0) | (1<<1) | (1<<2));   /* Configure PE0, PE1, PE2 as output */
    GPIO_PORTE_AFSEL_REG &= ~((1<<0) | (1<<1) | (1<<2));  /* Disable alternate function */
    GPIO_PORTE_DEN_REG   |= ((1<<0) | (1<<1) | (1<<2));   /* Enable digital I/O */
    GPIO_PORTE_DATA_REG  &= ~((1<<0) | (1<<1));           /* Turn off motor */

    GPIO_PORTE_DATA_REG |= (1<<2); // Enable H-Bridge
}

void DC_MOTORC_START(void){
    GPIO_PORTE_DATA_REG |= (1<<0);    // IN1 = 1 (Forward ON)
    GPIO_PORTE_DATA_REG &= ~(1<<1);   // IN2 = 0 (Reverse OFF)
}

void DC_MOTORC_STOP(void){
    GPIO_PORTE_DATA_REG |= (1<<0) | (1<<1) | (1<<2); // Set IN1, IN2, and ENA HIGH to avoid back EMF
    Delay_MS(100);

    GPIO_PORTE_DATA_REG &= ~(1<<0);   // IN1 = 0 (Forward OFF)
    GPIO_PORTE_DATA_REG &= ~(1<<1);   // IN2 = 0 (Reverse OFF)
}


void DC_MOTORD_INIT(void){
    /***
     * Port D Pin 2 for IN3 (FORWARD)
     * Port D Pin 3 for IN4 (REVERSE)
     * Port D Pin 6 for ENB
     ***/
    SYSCTL_RCGCGPIO_REG |= (1<<3); // Enable clock for Port D
    while((GET_BIT(SYSCTL_PRGPIO_REG,3) == 0)); // Wait for clock to stabilize

    GPIO_PORTD_AMSEL_REG &= ~((1<<2) | (1<<3) | (1<<6));  /* Disable Analog on PD2, PD3, PD6 */
    GPIO_PORTD_PCTL_REG  &= 0xF0FFFFFF;                   /* Clear PMCx bits to use as GPIO */
    GPIO_PORTD_DIR_REG   |= ((1<<2) | (1<<3) | (1<<6));   /* Configure PD2, PD3, PD6 as output */
    GPIO_PORTD_AFSEL_REG &= ~((1<<2) | (1<<3) | (1<<6));  /* Disable alternate function */
    GPIO_PORTD_DEN_REG   |= ((1<<2) | (1<<3) | (1<<6));   /* Enable digital I/O */
    GPIO_PORTD_DATA_REG  &= ~((1<<2) | (1<<3));           /* Turn off motor */

    GPIO_PORTD_DATA_REG |= (1<<6); // Enable H-Bridge
}

void DC_MOTORD_START(void){
    GPIO_PORTD_DATA_REG |= (1<<2);    // IN3 = 1 (Forward ON)
    GPIO_PORTD_DATA_REG &= ~(1<<3);   // IN4 = 0 (Reverse OFF)
}

void DC_MOTORD_STOP(void){
    GPIO_PORTD_DATA_REG |= (1<<2) | (1<<3) | (1<<6); // Set IN3, IN4, and ENB HIGH to avoid back EMF
    Delay_MS(100);

    GPIO_PORTD_DATA_REG &= ~(1<<2);   // IN3 = 0 (Forward OFF)
    GPIO_PORTD_DATA_REG &= ~(1<<3);   // IN4 = 0 (Reverse OFF)
}
