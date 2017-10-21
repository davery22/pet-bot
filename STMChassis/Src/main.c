// Includes
#include "main.h"
#include "stm32f0xx_hal.h"
#include "motor.h"

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
void Error_Handler(void);

void LED_Init(void);
void PWM_calibrate(void);

/*
 * PINS IN USE FOR MAIN APPLICATION:
 *
 * PC6  -  OUTPUT -  Red LED
 * PC7  -  OUTPUT -  Blue LED
 * PC8  -  OUTPUT -  Orange LED
 * PC9  -  OUTPUT -  Green LED
 *
 * PA0  -  OUTPUT -  User Button
 *
 * PA9  -  INPUT  -  USART1 Rx
 * PA10 -  OUTPUT -  USART1 Tx
 * 
 */


/* Main Program Code -----------------------------------------------*/
int main(void) {
    HAL_Init();  // Reset of all peripherals, Initializes the Flash interface and the Systick. 
    SystemClock_Config();  // Configure the system clock 

    //Init peripherals, blinks PC9 LED in loop as heartbeat.
    LED_Init();
    Motor_Init();
    
    while(1) {
			  PWM_calibrate();
    }
}


/* Runs a simple test of the PWM calibration:
 *   mid -> max -> min -> max -> min -> mid
 * i.e.
 *   stopped -> forward -> reverse -> forward -> reverse -> stopped
 * LED's flash to mimic the LED's on the motor driver.
 */
void PWM_calibrate(void) {
	// 6,7,8,9 - Red,Blue,Orange,Green
	GPIOC->ODR |= GPIO_ODR_8;  // Orange ON; holding middle
	HAL_Delay(2048);
	GPIOC->ODR &= ~GPIO_ODR_8; // Orange OFF; beginning calibration...
	
	int i, j, duty = 50;
	for (i = 0; i < 2; i++) {
		// Go up to max
		for (j = 0; j < 17; j++) {
			GPIOC->ODR ^= GPIO_ODR_9;
			PWM_set_duty_cycle(++duty);
			HAL_Delay(128);
		}
		
		GPIOC->ODR |= GPIO_ODR_9;
		HAL_Delay(1024); // Hold at max a little longer
		
		// Go down to mid
		for (j = 0; j < 17; j++) {
			GPIOC->ODR ^= GPIO_ODR_9;
			PWM_set_duty_cycle(--duty);
			HAL_Delay(128);
		}
		
		GPIOC->ODR &= ~GPIO_ODR_9;
		
		// Go down to min
		for (j = 0; j < 17; j++) {
			GPIOC->ODR ^= GPIO_ODR_6;
			PWM_set_duty_cycle(--duty);
			HAL_Delay(128);
		}
		
		GPIOC->ODR |= GPIO_ODR_6;
		HAL_Delay(1024); // Hold at min a little longer
		
		// Go up to mid
		for (j = 0; j < 17; j++) {
			GPIOC->ODR ^= GPIO_ODR_6;
			PWM_set_duty_cycle(++duty);
			HAL_Delay(128);
		}
		
		GPIOC->ODR &= ~GPIO_ODR_6;
	}
}


void LED_Init(void) {
    // Set up clock
    RCC->AHBENR |= RCC_AHBENR_GPIOCEN;
	
    // Initalize LED pins  - PC6,PC7,PC8,PC9
		GPIOC->MODER |= 0x55000; GPIOC->MODER &= ~0xAA000;
		GPIOC->OTYPER &= ~0x3C0;
		GPIOC->OSPEEDR &= ~0xFF000;
		GPIOC->PUPDR &= ~0xFF000;

    GPIOC->ODR &= ~0x3C0;		// Shut them all off initially
}


/** System Clock Configuration */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct;
  RCC_ClkInitTypeDef RCC_ClkInitStruct;

    /**Initializes the CPU, AHB and APB busses clocks 
    */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = 16;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_NONE;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

    /**Initializes the CPU, AHB and APB busses clocks 
    */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_HSI;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0) != HAL_OK)
  {
    Error_Handler();
  }

    /**Configure the Systick interrupt time 
    */
  HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/1000);

    /**Configure the Systick 
    */
  HAL_SYSTICK_CLKSourceConfig(SYSTICK_CLKSOURCE_HCLK);

  /* SysTick_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(SysTick_IRQn, 0, 0);
}


/**
  * @brief  This function is executed in case of error occurrence.
  * @param  None
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler */
  /* User can add his own implementation to report the HAL error return state */
  while(1) 
  {
  }
  /* USER CODE END Error_Handler */ 
}

