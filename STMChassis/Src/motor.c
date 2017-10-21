// Includes
#include "motor.h"
#include "stm32f0xx_hal.h"

/* -------------------------------------------------------------------------------------------------------------
 *  Global Variable and Type Declarations
 * --------------------------------------------------------------------------------------------------------------
 */

#define ARM_DOWN (5500)
#define ARM_UP (0)
#define ARM_LEFT (5500)
#define ARM_RIGHT (0)

volatile int8_t  y_duty_cycle;    	// Output PWM duty cycle
volatile int16_t y_target_rpm;    	// Desired speed target
volatile int16_t y_motor_speed;   	// Measured motor speed
volatile int16_t y_error;         	// Speed error signal
volatile int16_t y_error_integral;	// Error integral
volatile int16_t y_pos = ARM_DOWN;	// Initial Position

volatile int8_t  z_duty_cycle;    	// Output PWM duty cycle
volatile int16_t z_target_rpm;    	// Desired speed target
volatile int16_t z_motor_speed;   	// Measured motor speed
volatile int16_t z_error;         	// Speed error signal
volatile int16_t z_error_integral;	// Error integral
volatile int16_t z_pos = ARM_RIGHT;	// Initial position

volatile uint8_t Kp;              // Proportional gain
volatile uint8_t Ki;              // Integral gain

/* -------------------------------------------------------------------------------------------------------------
 *  Motor Control and Initialization Functions
 * -------------------------------------------------------------------------------------------------------------
 */


 /*
  *	PINS IN USE FOR MOTOR CONTROL:
  * 
  * PB8  -  OUTPUT -  Motor Y Enable (PWM)
  * PC4  -  OUTPUT -  Motor Y Direction A
  * PC5  -  OUTPUT -  Motor Y Direction B
  * PB4  -  INPUT  -  Motor Y Encoder In 1
  * PB5  -  INPUT  -  Motor Y Encoder In 2
  * 
  * PB9  -  OUTPUT -  Motor Z Enable (PWM)
  * PC10 -  OUTPUT -  Motor Z Direction A
  * PC11 -  OUTPUT -  Motor Z Direction B
  * PA5  -  INPUT  -  Motor Z Encoder In 1
  * PB3  -  INPUT  -  Motor Z Encoder In 2
  *
  */
 

// Sets up the entire motor drive system
void Motor_Init(void)
{
	Kp = 27;     // Set default proportional gain
	Ki = 6;     // Set default integral gain
	
	PWM_Init();
}


// Sets up the PWM and direction signals to drive the H-Bridge
void PWM_Init(void)
{
	RCC->AHBENR |= RCC_AHBENR_GPIOBEN;
	
	// Motor Y Init
	{
		// Set up a pin for H-bridge PWM output (TIMER 16 CH1) - use PB8 -> AF2
		GPIOB->MODER |= 0x20000; GPIOB->MODER &= ~0x10000;
		GPIOB->AFR[1] |= 0x2; GPIOB->AFR[1] &= ~0xD;

		// Set up PWM timer
		RCC->APB2ENR |= RCC_APB2ENR_TIM16EN;
		TIM16->CR1 = 0;                                 // Clear control register

		// Set output-compare CH1 to PWM1 mode and enable CCR1 preload buffer
		TIM16->CCMR1 = (TIM_CCMR1_OC1M_2 | TIM_CCMR1_OC1M_1 | TIM_CCMR1_OC1PE);
		TIM16->CCER = TIM_CCER_CC1E;                    // Enable capture-compare channel 1
		TIM16->PSC = SystemCoreClock/1000000 - 1;       // Run timer on 1Mhz
		TIM16->ARR = 3000;                              // PWM at .02kHz (50ms period)
		TIM16->CCR1 = 0;                                // Start PWM at 0% duty cycle
		TIM16->BDTR |= TIM_BDTR_MOE;
		
		PWM_set_duty_cycle(50); // jk earlier...

		TIM16->CR1 |= TIM_CR1_CEN;                      // Enable timer
	}
}

void PWM_set_duty_cycle(uint32_t duty) {
	// Validate bounds
	if (duty > 100) {
		return;
	}
	
	TIM16->CCR1 = (duty * TIM16->ARR)/100; // Use linear transform to produce CCR1 value
}
