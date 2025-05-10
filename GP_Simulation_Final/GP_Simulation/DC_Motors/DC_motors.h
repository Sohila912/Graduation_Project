/*
 * DC_motors.h
 *
 *  Created on: Mar 3, 2025
 *      Author: User
 */

#ifndef DC_MOTORS_DC_MOTORS_H_
#define DC_MOTORS_DC_MOTORS_H_

/*** ===================== Include Section Start =========================== ***/

#include "tm4c123gh6pm_registers.h"
#include "common_macros.h"

/*** ===================== Include Section End ============================= ***/

/*** ====================== Macros Section Start =========================== ***/
/***

 * Port E Pin 0 for IN1 (FORWARD)
 * Port E Pin 1 for IN2 (REVERSE)
 * Port E Pin 2 for ENA
 * Port D Pin 2 for IN3 (FORWARD)
 * Port D Pin 3 for IN4 (REVERSE)
 * Port D Pin 6 for ENB
 ***/
#define IN1_PIN     2
#define IN2_PIN     3
#define IN3_PIN     4
#define IN4_PIN     5
#define ENA_PIN     6
#define ENB_PIN     7

/*** ====================== Macros Section End ============================= ***/

/*** ================= Global Declaration Section Start ==================== ***/

void DC_MOTORC_INIT(void);
void DC_MOTORC_START(void);
void DC_MOTORC_STOP(void);

void DC_MOTORD_INIT(void);
void DC_MOTORD_START(void);
void DC_MOTORD_STOP(void);

/*** ================= Global Declaration Section End ====================== ***/



#endif /* DC_MOTORS_DC_MOTORS_H_ */
