// Includes
#include "motor.h"
#include "stm32f0xx_hal.h"

/* -------------------------------------------------------------------------------------------------------------
 *  Global Variable and Type Declarations
 * --------------------------------------------------------------------------------------------------------------
 */

volatile uint8_t current_left_motor_duty = 50;
volatile uint8_t current_right_motor_duty = 50;
volatile uint8_t current_central_motor_duty = 50;
volatile uint8_t target_left_motor_duty = 50;
volatile uint8_t target_right_motor_duty = 50;
volatile uint8_t target_central_motor_duty = 50;

/*
 * PINS IN USE FOR MOTOR CONTROL:
 * 
 * PB8  -  OUTPUT -  Left Motor PWM
 * PB9  -  OUTPUT -  Right Motor PWM
 * PB14 -  OUTPUT -  Central Motor PWM
 *
 */
 

// Sets up the PWM hardware/signals for each motor
void PWM_Init(void)
{
	RCC->AHBENR |= RCC_AHBENR_GPIOBEN;
	
	// Left Motor Init
	{
		// Set up a pin for PWM output (TIMER 16 CH1) - use PB8 -> AF2
		GPIOB->MODER |= 0x20000; GPIOB->MODER &= ~0x10000;
		GPIOB->AFR[1] |= 0x2; GPIOB->AFR[1] &= ~0xD;

		// Set up PWM timer
		RCC->APB2ENR |= RCC_APB2ENR_TIM16EN;
		TIM16->CR1 = 0;                                 // Clear control register

		// Set output-compare CH1 to PWM1 mode and enable CCR1 preload buffer
		TIM16->CCMR1 = (TIM_CCMR1_OC1M_2 | TIM_CCMR1_OC1M_1 | TIM_CCMR1_OC1PE);
		TIM16->CCER = TIM_CCER_CC1E;                    // Enable capture-compare channel 1
		TIM16->PSC = SystemCoreClock/1000000 - 1;       // Run timer on 1Mhz
		TIM16->ARR = 3000;                              // PWM at 333Hz (3ms period)
		TIM16->BDTR |= TIM_BDTR_MOE;
		
		PWM_set_duty_cycle(LEFT_MOTOR, current_left_motor_duty);    // Initialize PWM duty cycle

		TIM16->CR1 |= TIM_CR1_CEN;                      // Enable timer
	}

    // Right Motor Init
    {
		// Set up a pin for PWM output (TIMER 17 CH1) - use PB9 -> AF2
		GPIOB->MODER |= 0x80000; GPIOB->MODER &= ~0x40000;
		GPIOB->AFR[1] |= 0x20; GPIOB->AFR[1] &= ~0xD0;

		// Set up PWM timer
		RCC->APB2ENR |= RCC_APB2ENR_TIM17EN;
		TIM17->CR1 = 0;                                 // Clear control register

		// Set output-compare CH1 to PWM1 mode and enable CCR1 preload buffer
		TIM17->CCMR1 = (TIM_CCMR1_OC1M_2 | TIM_CCMR1_OC1M_1 | TIM_CCMR1_OC1PE);
		TIM17->CCER = TIM_CCER_CC1E;                    // Enable capture-compare channel 1
		TIM17->PSC = SystemCoreClock/1000000 - 1;       // Run timer on 1Mhz
		TIM17->ARR = 3000;                              // PWM at 333Hz (3ms period)
		TIM17->BDTR |= TIM_BDTR_MOE;
		
		PWM_set_duty_cycle(RIGHT_MOTOR, current_right_motor_duty);  // Initialize PWM duty cycle

		TIM17->CR1 |= TIM_CR1_CEN;                      // Enable timer
    }

    // Central Motor Init
    {
		// Set up a pin for PWM output (TIMER 15 CH1) - use PB14 -> AF1
		GPIOB->MODER |= 0x20000000; GPIOB->MODER &= ~0x10000000;
		GPIOB->AFR[1] |= 0x1000000; GPIOB->AFR[1] &= ~0xE000000;

		// Set up PWM timer
		RCC->APB2ENR |= RCC_APB2ENR_TIM15EN;
		TIM15->CR1 = 0;                                 // Clear control register

		// Set output-compare CH1 to PWM1 mode and enable CCR1 preload buffer
		TIM15->CCMR1 = (TIM_CCMR1_OC1M_2 | TIM_CCMR1_OC1M_1 | TIM_CCMR1_OC1PE);
		TIM15->CCER = TIM_CCER_CC1E;                    // Enable capture-compare channel 1
		TIM15->PSC = SystemCoreClock/1000000 - 1;       // Run timer on 1Mhz
		TIM15->ARR = 3000;                              // PWM at 333Hz (3ms period)
		TIM15->BDTR |= TIM_BDTR_MOE;
		
		PWM_set_duty_cycle(CENTRAL_MOTOR, current_central_motor_duty);  // Initialize PWM duty cycle

		TIM15->CR1 |= TIM_CR1_CEN;                      // Enable timer
    }
}

void PWM_set_target_duty(uint8_t motor_id, uint8_t duty) {
	// Validate bounds
	if (duty > 100) {
		return;
	}
	
	// Adjust target duty cycle for motor
	switch(motor_id) {
		case LEFT_MOTOR:
			target_left_motor_duty = duty;
			break;
		case RIGHT_MOTOR:
			target_right_motor_duty = duty;
			break;
		case CENTRAL_MOTOR:
			target_central_motor_duty = duty;
			break;
		default:
			break;
	}
}

void PWM_set_duty_cycle(uint8_t motor_id, uint8_t duty) {
    // Set the motor's PWM duty cycle
    switch(motor_id) {
        case LEFT_MOTOR:
						current_left_motor_duty = duty;
            TIM16->CCR1 = (duty * TIM16->ARR)/100; // Use linear transform to produce CCR1 value
            break;
        case RIGHT_MOTOR:
						current_right_motor_duty = duty;
            TIM17->CCR1 = (duty * TIM17->ARR)/100; // Use linear transform to produce CCR1 value
            break;
        case CENTRAL_MOTOR:
						current_central_motor_duty = duty;
            TIM15->CCR1 = (duty * TIM15->ARR)/100; // Use linear transform to produce CCR1 value
            break;
        default:
            break;
    }
}
