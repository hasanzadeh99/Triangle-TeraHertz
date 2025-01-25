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
#include "stm32f4xx_hal.h"

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
#define LED_Pin GPIO_PIN_13
#define LED_GPIO_Port GPIOC
#define data17_Pin GPIO_PIN_1
#define data17_GPIO_Port GPIOA
#define data18_Pin GPIO_PIN_2
#define data18_GPIO_Port GPIOA
#define data19_Pin GPIO_PIN_3
#define data19_GPIO_Port GPIOA
#define MCLK_Pin GPIO_PIN_5
#define MCLK_GPIO_Port GPIOA
#define MST_Pin GPIO_PIN_6
#define MST_GPIO_Port GPIOA
#define data16_Pin GPIO_PIN_12
#define data16_GPIO_Port GPIOB
#define data15_Pin GPIO_PIN_13
#define data15_GPIO_Port GPIOB
#define data14_Pin GPIO_PIN_14
#define data14_GPIO_Port GPIOB
#define data13_Pin GPIO_PIN_15
#define data13_GPIO_Port GPIOB
#define data12_Pin GPIO_PIN_8
#define data12_GPIO_Port GPIOA
#define data11_Pin GPIO_PIN_9
#define data11_GPIO_Port GPIOA
#define data10_Pin GPIO_PIN_10
#define data10_GPIO_Port GPIOA
#define data9_Pin GPIO_PIN_11
#define data9_GPIO_Port GPIOA
#define data8_Pin GPIO_PIN_12
#define data8_GPIO_Port GPIOA
#define data7_Pin GPIO_PIN_15
#define data7_GPIO_Port GPIOA
#define data6_Pin GPIO_PIN_3
#define data6_GPIO_Port GPIOB
#define data5_Pin GPIO_PIN_4
#define data5_GPIO_Port GPIOB
#define data4_Pin GPIO_PIN_5
#define data4_GPIO_Port GPIOB
#define data3_Pin GPIO_PIN_6
#define data3_GPIO_Port GPIOB
#define data2_Pin GPIO_PIN_7
#define data2_GPIO_Port GPIOB
#define data1_Pin GPIO_PIN_8
#define data1_GPIO_Port GPIOB
#define data0_Pin GPIO_PIN_9
#define data0_GPIO_Port GPIOB

/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
