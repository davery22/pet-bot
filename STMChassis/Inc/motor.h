
#ifndef MOTOR_H_
#define MOTOR_H_

#include "stm32f0xx_hal.h"

/* -------------------------------------------------------------------------------------------------------------
 *  Global Variable and Type Declarations
 *  -------------------------------------------------------------------------------------------------------------
 */

#define LEFT_MOTOR 0
#define RIGHT_MOTOR 1
#define CENTRAL_MOTOR 2

extern volatile uint8_t current_left_motor_duty;
extern volatile uint8_t current_right_motor_duty;
extern volatile uint8_t current_central_motor_duty;
extern volatile uint8_t target_left_motor_duty;
extern volatile uint8_t target_right_motor_duty;
extern volatile uint8_t target_central_motor_duty;

/* -------------------------------------------------------------------------------------------------------------
 *  Motor Control and Initialization Functions
 * -------------------------------------------------------------------------------------------------------------
 */

// Sets up the PWM hardware
void PWM_Init(void);

// Set the duty cycle of a particular motor PWM
void PWM_set_duty_cycle(uint8_t motor_id, uint8_t duty);

// Set the _target_ duty cycle of a particular motor PWM, accepts [0,100]
void PWM_set_target_duty(uint8_t motor_id, uint8_t duty);

#endif /* MOTOR_H_ */
