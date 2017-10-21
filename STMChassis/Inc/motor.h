
#ifndef MOTOR_H_
#define MOTOR_H_

#include "stm32f0xx_hal.h"

/* -------------------------------------------------------------------------------------------------------------
 *  Global Variable and Type Declarations
 *  -------------------------------------------------------------------------------------------------------------
 */
extern volatile int8_t y_duty_cycle;    // Output PWM duty cycle
extern volatile int16_t y_target_rpm;    // Desired speed target
extern volatile int16_t y_motor_speed;   // Measured motor speed
extern volatile int16_t y_error;         // Speed error signal
extern volatile int16_t y_error_integral;// Integrated error signal
extern volatile int16_t y_pos;

extern volatile int8_t z_duty_cycle;    // Output PWM duty cycle
extern volatile int16_t z_target_rpm;    // Desired speed target
extern volatile int16_t z_motor_speed;   // Measured motor speed
extern volatile int16_t z_error;         // Speed error signal
extern volatile int16_t z_error_integral;// Integrated error signal
extern volatile int16_t z_pos;

extern volatile uint8_t Kp;            // Proportional gain
extern volatile uint8_t Ki;            // Integral gain


/* -------------------------------------------------------------------------------------------------------------
 *  Motor Control and Initialization Functions
 * -------------------------------------------------------------------------------------------------------------
 */

// Sets up the entire motor drive system
void Motor_Init(void);

// Set the duty cycle of the PWM, accepts (0,100)
void PWM_set_duty_cycle(uint32_t duty);

/* -------------------------------------------------------------------------------------------------------------
 *  Internal-Use Initialization Functions
 * -------------------------------------------------------------------------------------------------------------
 */

// Sets up the PWM and direction signals to drive the H-Bridge
void PWM_Init(void);

#endif /* MOTOR_H_ */
