/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f0xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

void HAL_TIM_MspPostInit(TIM_HandleTypeDef *htim);

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define data16_Pin GPIO_PIN_0
#define data16_GPIO_Port GPIOA
#define data15_Pin GPIO_PIN_1
#define data15_GPIO_Port GPIOA
#define data14_Pin GPIO_PIN_2
#define data14_GPIO_Port GPIOA
#define data13_Pin GPIO_PIN_3
#define data13_GPIO_Port GPIOA
#define MST_Pin GPIO_PIN_4
#define MST_GPIO_Port GPIOA
#define data8_Pin GPIO_PIN_5
#define data8_GPIO_Port GPIOA
#define Mclk_Pin GPIO_PIN_6
#define Mclk_GPIO_Port GPIOA
#define data9_Pin GPIO_PIN_7
#define data9_GPIO_Port GPIOA
#define data10_Pin GPIO_PIN_1
#define data10_GPIO_Port GPIOB
#define data11_Pin GPIO_PIN_9
#define data11_GPIO_Port GPIOA
#define data12_Pin GPIO_PIN_10
#define data12_GPIO_Port GPIOA

/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
