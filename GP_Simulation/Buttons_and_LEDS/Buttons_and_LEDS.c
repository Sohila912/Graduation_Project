/*
 * Buttons_and_LEDS.c
 *
 *  Created on: Mar 3, 2025
 *      Author: User
 */
/* ===================== Include Section Start =========================== */
#include "Buttons_and_LEDS.h"
/* ===================== Include Section End ============================= */
/* Enable PF4 (SW1) */
void SW1_Init(void)
{
    GPIO_PORTF_AMSEL_REG &= ~(1<<4);      /* Disable Analog on PF0 */
    GPIO_PORTF_PCTL_REG  &= 0xFFF0FFFF;   /* Clear PMCx bits for PF0 to use it as GPIO pin */
    GPIO_PORTF_DIR_REG   &= ~(1<<4);      /* Configure PF0 as input pin */
    GPIO_PORTF_AFSEL_REG &= ~(1<<4);      /* Disable alternative function on PF0 */
    GPIO_PORTF_PUR_REG   |= (1<<4);       /* Enable pull-up on PF0 */
    GPIO_PORTF_DEN_REG   |= (1<<4);       /* Enable Digital I/O on PF0 */

    /*adding the edge triggered configuration for SW1 on PF4 and SW2 on PF0 */
    GPIO_PORTF_IS_REG    &= ~(1<<4);      /* PF4  detect edges */
    GPIO_PORTF_IBE_REG   &= ~(1<<4);      /* PF4 will detect a certain edge */
    GPIO_PORTF_IEV_REG   &= ~(1<<4);      /* PF4 will detect a falling edge */
    GPIO_PORTF_ICR_REG   |= (1<<4);       /* Clear Trigger flag for PF4  (Interrupt Flag) */
    GPIO_PORTF_IM_REG    |= (1<<4);       /* Enable Interrupt on PF4 pin */

    /* Set GPIO PORTF priority as 2 by set Bit number 21, 22 and 23 with value 2 */
    NVIC_PRI7_REG = (NVIC_PRI7_REG & ~GPIO_PORTF_PRIORITY_MASK) | (GPIO_PORTF_INTERRUPT_PRIORITY<<GPIO_PORTF_PRIORITY_BITS_POS);
    NVIC_EN0_REG         |= 0x40000000;   /* Enable NVIC Interrupt for GPIO PORTF by set bit number 30 in EN0 Register */

}

/* Enable PF1 (RED LED) */
void Led_Red_Init(void)
{
    GPIO_PORTF_AMSEL_REG &= ~(1<<1);      /* Disable Analog on PF1 */
    GPIO_PORTF_PCTL_REG  &= 0xFFFFFF0F;   /* Clear PMCx bits for PF1 to use it as GPIO pin */
    GPIO_PORTF_DIR_REG   |= (1<<1);       /* Configure PF1 as output pin */
    GPIO_PORTF_AFSEL_REG &= ~(1<<1);      /* Disable alternative function on PF1 */
    GPIO_PORTF_DEN_REG   |= (1<<1);       /* Enable Digital I/O on PF1 */
    GPIO_PORTF_DATA_REG  &= ~(1<<1);      /* Clear bit 1 in Data register to turn off the led */
}


void GPIOPortF_Handler(void)
{
    if (GET_BIT(GPIO_PORTF_RIS_REG, 4) == 1) { /* Check if SW0 on PF4 is pressed */
        DC_MOTORA_STOP();
        DC_MOTORB_STOP();
        DC_MOTORC_STOP();
        DC_MOTORD_STOP();

        UART0_SendString("Brakes are pressed");

        /* Wait for button release */
        while (GET_BIT(GPIO_PORTF_DATA_REG, 4) == 0);

        DC_MOTORA_START();
        DC_MOTORB_START();
        DC_MOTORC_START();
        DC_MOTORD_START();

        GPIO_PORTF_ICR_REG |= (1 << 4);       /* Clear interrupt flag */
    }

}
