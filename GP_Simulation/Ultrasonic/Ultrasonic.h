/*
 * Ultrasonic.h
 *
 *  Created on: Mar 3, 2025
 *      Author: Rawan Nabih
 */

//ports used: PE4 & PE5

#ifndef ULTRASONIC_ULTRASONIC_H_
#define ULTRASONIC_ULTRASONIC_H_

/* ===================== Include Section Start =========================== */
#include "tm4c123gh6pm_registers.h"
#include "common_macros.h"
#include "UART/UART.h"
#include "DC_Motors/DC_motors.h"

/* ===================== Include Section End ============================= */

/* ====================== Macros Section Start =========================== */
#define DISTANCE_THRESHOLD        5                        /* Distance threshold */

/* ====================== Macros Section End ============================= */


/* ================= Global Declaration Section Start ==================== */
void Ultrasonic_Init(void);
void Ultrasonic_Trigger(void);
unsigned long Ultrasonic_GetDistance(void);
void Monitor_DIST(void);
/* ================= Global Declaration Section End ====================== */



#endif /* ULTRASONIC_ULTRASONIC_H_ */
