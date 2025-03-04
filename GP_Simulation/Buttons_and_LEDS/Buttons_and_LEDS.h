/*
 * Buttons_and_LEDS.h
 *
 *  Created on: Mar 3, 2025
 *      Author: User
 */

#ifndef BUTTONS_AND_LEDS_BUTTONS_AND_LEDS_H_
#define BUTTONS_AND_LEDS_BUTTONS_AND_LEDS_H_

//ports used: PF4 & PF1

/* ===================== Include Section Start =========================== */
#include "tm4c123gh6pm_registers.h"
#include "common_macros.h"
#include "UART/UART.h"
#include "DC_Motors/DC_motors.h"
/* ===================== Include Section End ============================= */

/*interrupts related macros*/
/* Enable Exceptions ... This Macro enable IRQ interrupts, Programmable Systems Exceptions and Faults by clearing the I-bit in the PRIMASK. */
#define Enable_Exceptions()    __asm(" CPSIE I ")

/* Disable Exceptions ... This Macro disable IRQ interrupts, Programmable Systems Exceptions and Faults by setting the I-bit in the PRIMASK. */
#define Disable_Exceptions()   __asm(" CPSID I ")

/* Enable Faults ... This Macro enable Faults by clearing the F-bit in the FAULTMASK */
#define Enable_Faults()        __asm(" CPSIE F ")

/* Disable Faults ... This Macro disable Faults by setting the F-bit in the FAULTMASK */
#define Disable_Faults()       __asm(" CPSID F ")

/*interrupt configuration macros for portF*/
#define GPIO_PORTF_PRIORITY_MASK          0x00E00000
#define GPIO_PORTF_PRIORITY_BITS_POS      21
#define GPIO_PORTF_INTERRUPT_PRIORITY     2


/* ================= Global Declaration Section Start ==================== */
void SW1_Init(void);
void Led_Red_Init(void);
void GPIOPortF_Handler(void);
/* ================= Global Declaration Section End ====================== */



#endif /* BUTTONS_AND_LEDS_BUTTONS_AND_LEDS_H_ */
