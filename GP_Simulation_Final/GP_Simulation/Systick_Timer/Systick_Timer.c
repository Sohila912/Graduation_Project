/*
 * Systick_Timer.c
 *
 *  Created on: Mar 18, 2025
 *      Author: User
 */
#include "Systick_Timer.h"
/* Enable the SystTick Timer to run using the System Clock with Frequency 16Mhz and Count 10 microsecond */
void SysTick_Init(void)
{
    SYSTICK_CTRL_REG    = 0;              /* Disable the SysTick Timer by Clear the ENABLE Bit */
    SYSTICK_RELOAD_REG  = RElOAD_VALUE;       /* Set the Reload value with 159 to count 10 microsecond */
    SYSTICK_CURRENT_REG = 0;              /* Clear the Current Register value */
    /* Configure the SysTick Control Register
     * Enable the SysTick Timer (ENABLE = 1)
     * enable SysTick Interrupt (INTEN = 1)
     * Choose the clock source to be System Clock (CLK_SRC = 1) */
    SYSTICK_CTRL_REG   |= 0x07;
}




