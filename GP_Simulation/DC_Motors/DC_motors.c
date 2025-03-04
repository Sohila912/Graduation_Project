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


void DC_MOTORA_INIT(void){
    /***
     * Port B Pin 2 for IN1 (FORWARD)
     * Port B Pin 3 for IN2 (REVERSE)
     * Port B Pin 6 for ENA
     ***/
    //Enable clock for PortB and wait for clock to start
    SYSCTL_RCGCGPIO_REG |= (1<<1);
    while((GET_BIT(SYSCTL_PRGPIO_REG,1) == 0));

    GPIO_PORTB_AMSEL_REG &= ~((1<<IN1_PIN) | (1<<IN2_PIN) | (1<<ENA_PIN));       /* Disable Analog on PB2, PB3 and PB6 */
    GPIO_PORTB_PCTL_REG  &= 0xF0FF00FF;                                          /* Clear PMCx bits for PB2, PB3 and PB6 to use it as GPIO pin */
    GPIO_PORTB_DIR_REG   |= ((1<<IN1_PIN) | (1<<IN2_PIN) | (1<<ENA_PIN));        /* Configure PB2, PB3 and PB6 as output pin */
    GPIO_PORTB_AFSEL_REG &= ~((1<<IN1_PIN) | (1<<IN2_PIN) | (1<<ENA_PIN));       /* Disable alternative function on PB2, PB3 and PB6 */
    GPIO_PORTB_DEN_REG   |= ((1<<IN1_PIN) | (1<<IN2_PIN) | (1<<ENA_PIN));        /* Enable Digital I/O on PB2, PB3 and PB6 */
    GPIO_PORTB_DATA_REG  &= ~((1<<IN1_PIN) | (1<<IN2_PIN));       /* Clear bit 2, 3 and 6 in Data register to turn off DC Motor*/

    GPIO_PORTB_DATA_REG |= (1<<ENA_PIN); //To enable the H-Bridge
}



void DC_MOTORA_START(void){
    //INPUT1 (PB2)= 1 && INPUT2 (PB3) = 0 -> FPRWARD
    //INPUT1 (PB2) = 0 && INPUT2 (PB3) = 1 -> BACKWARD
    GPIO_PORTB_DATA_REG |= (1<<IN1_PIN);    //IN1 = 1 (Forward on)
    GPIO_PORTB_DATA_REG &= ~ (1<<IN2_PIN);  //IN2 = 0 (Reverse off)

}


void DC_MOTORA_STOP(void){
    //To avoid high voltage resulting in back emf
    GPIO_PORTB_DATA_REG |= (1<<IN1_PIN);    //IN1 = 1
    GPIO_PORTB_DATA_REG |= (1<<IN2_PIN);    //IN2 = 1
    GPIO_PORTB_DATA_REG |= (1<<ENA_PIN);    //ENA = 1
    Delay_MS(100);
    //To stop MOTOR A IN1 = 0, IN2 = 0
    //GPIO_PORTB_DATA_REG &= ~ (1<<ENA_PIN);
    GPIO_PORTB_DATA_REG &= ~ (1<<IN1_PIN);    //IN1 = 0 (Forward off)
    GPIO_PORTB_DATA_REG &= ~ (1<<IN2_PIN);    //IN2 = 0 (Reverse off)
}


void DC_MOTORB_INIT(void){
    /***
     * Port B Pin 4 for IN3 (FORWARD)
     * Port B Pin 5 for IN4 (REVERSE)
     * Port B Pin 7 for ENB
     ***/
    //Enable clock for PortB and wait for clock to start
    SYSCTL_RCGCGPIO_REG |= (1<<1);
    while((GET_BIT(SYSCTL_PRGPIO_REG,1) == 0));

    GPIO_PORTB_AMSEL_REG &= ~((1<<IN3_PIN) | (1<<IN4_PIN) | (1<<ENB_PIN));       /* Disable Analog on PB4, PB5 and PB7 */
    GPIO_PORTB_PCTL_REG  &= 0x0F00FFFF;                                          /* Clear PMCx bits for PB4, PB5 and PB7 to use it as GPIO pin */
    GPIO_PORTB_DIR_REG   |= ((1<<IN3_PIN) | (1<<IN4_PIN) | (1<<ENB_PIN));        /* Configure PB4, PB5 and PB7 as output pin */
    GPIO_PORTB_AFSEL_REG &= ~((1<<IN3_PIN) | (1<<IN4_PIN) | (1<<ENB_PIN));       /* Disable alternative function on PB4, PB5 and PB7 */
    GPIO_PORTB_DEN_REG   |= ((1<<IN3_PIN) | (1<<IN4_PIN) | (1<<ENB_PIN));        /* Enable Digital I/O on PB4, PB5 and PB7 */
    GPIO_PORTB_DATA_REG  &= ~((1<<IN3_PIN) | (1<<IN4_PIN));       /* Clear bit 4, 5 and 7 in Data register to turn off DC Motor*/

    GPIO_PORTB_DATA_REG |= (1<<ENB_PIN); //To enable the H-Bridge
}


void DC_MOTORB_START(void){
    //INPUT3 = 1 && INPUT4 = 0 -> FPRWARD
    //INPUT3 = 0 && INPUT4 = 1 -> BACKWARD

    GPIO_PORTB_DATA_REG |= (1<<IN3_PIN);    //IN3 = 1 (Forward on)
    GPIO_PORTB_DATA_REG &= ~ (1<<IN4_PIN);  //IN4 = 0 (Reverse off)

}


void DC_MOTORB_STOP(void){
    //To avoid high voltage resulting in back emf
    GPIO_PORTB_DATA_REG |= (1<<IN3_PIN);    //IN1 = 1
    GPIO_PORTB_DATA_REG |= (1<<IN4_PIN);    //IN2 = 1
    GPIO_PORTB_DATA_REG |= (1<<ENB_PIN);    //ENA = 1
    Delay_MS(100);
    //To stop MOTOR B IN3 = 0, IN4 = 0
    //GPIO_PORTB_DATA_REG &= ~ (1<<ENB_PIN);
    GPIO_PORTB_DATA_REG &= ~ (1<<IN3_PIN);    //IN3 = 0 (Forward off)
    GPIO_PORTB_DATA_REG &= ~ (1<<IN4_PIN);    //IN4 = 0 (Reverse off)
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

/*** ================= Motor D Functions (Using PORT D) ================= ***/
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
