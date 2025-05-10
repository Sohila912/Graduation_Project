/*
 * Systick_Timer.h
 *
 *  Created on: Mar 18, 2025
 *      Author: User
 */

#ifndef SYSTICK_TIMER_SYSTICK_TIMER_H_
#define SYSTICK_TIMER_SYSTICK_TIMER_H_

/* ===================== Include Section Start =========================== */
#include "tm4c123gh6pm_registers.h"
#include "common_macros.h"

/* ===================== Include Section End ============================= */


#define RElOAD_VALUE 159 //per 10susec

void SysTick_Init(void);


#endif /* SYSTICK_TIMER_SYSTICK_TIMER_H_ */
