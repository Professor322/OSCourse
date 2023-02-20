/*
 * Institute for System Programming of the Russian Academy of Sciences
 * Copyright (C) 2020 ISPRAS
 *
 * This document is considered confidential and proprietary,
 * and may not be reproduced or transmitted in any form 
 * in whole or in part, without the express written permission
 * of ISPRAS.
 */

#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H


#if defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
    #define FRAMEBUFFER_BIG_ENDIAN
#elif defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
    #define FRAMEBUFFER_LITTLE_ENDIAN
#else
    #error "Undefined endianness!"
#endif

#define MILLISECOND             1000000ULL
#define SECOND                  1000000000ULL
#define SCREEN_BYTES_PER_PIXEL  4U

#include <inc/types.h>


typedef enum FRAMEBUFFER_PIXEL_COLOUR_
{
    FRAMEBUFFER_PIXEL_COLOUR_BLACK = 0x00000000U,
    FRAMEBUFFER_PIXEL_COLOUR_WHITE = 0xFFFFFFFFU,
} FRAMEBUFFER_PIXEL_COLOUR;

typedef enum FRAMEBUFFER_PIXEL_FORMAT_
{
    FRAMEBUFFER_RGBA8888,
    FRAMEBUFFER_BGRA8888,
    FRAMEBUFFER_ARGB8888,
    FRAMEBUFFER_ABGR8888,
} FRAMEBUFFER_PIXEL_FORMAT;

typedef enum FRAMEBUFFER_OPERATION_
{
    FRAMEBUFFER_OPERATION_FILL,
    FRAMEBUFFER_OPERATION_COPY,
    FRAMEBUFFER_OPERATION_COPY_REVERSE,
    FRAMEBUFFER_OPERATION_CLEAR,
} FRAMEBUFFER_OPERATION;

typedef struct FRAMEBUFFER_CONTEXT_
{
    uint32_t                    width;
    uint32_t                    height;
    FRAMEBUFFER_PIXEL_FORMAT  format;
    uint32_t                  bits_per_pixel;
    uint32_t                  size;
    void *                    front;
    void *                    back;
} FRAMEBUFFER_CONTEXT;


/**
  Инициализировать фреймбуфер с заданными параметрами.
  Контекст фреймбуфера должен содержать результат выполнения
  успешного выполнения функции FramebufferRequest.
   
  С момента успешной инициализации контекст фреймбуфера доступен пользователю
  только для чтения, включая поле private, которое может использоваться
  реализацией для хранения служебной информации.

  @param[in,out] context           Контекст фреймбуфера.

  @retval RET_EOK при успешной инициализации.
  @retval RET_EAGAIN если устройство не готово.
  @retval RET_INVALID_MODE при ошибке. 
**/
int FramebufferInit(FRAMEBUFFER_CONTEXT *context);

/**
  Запросить у фреймбуфера свободный кадр из очереди на отрисовку.

  При успешном завершении вызывающий становится "владельцем" данного кадра,
  что означает невозможность манипуляций над этим кадром со стороны фреймбуфера.

  При многократном вызове данной функции должно возвращаться одно и то же
  значением (например, реализация может держать его в контексте).

  При параметре cleanup = TRUE гарантируется возврат RET_NOT_AVAILABLE
  исключительно в случае, когда очередь состоит из одного кадра, и данный
  кадр находится на стадии отрисовки (не может быть изменён). Также если в
  очереди уже есть кадры, готовые к отображению, но пока ещё не отображённые,
  они должны быть исключены из очереди.

  Примечание: возвращённый адрес может указывать непосредственно на видеопамять,
  и, как следствие, данная область может иметь выключенное кэширование.

  @param[in,out] context            Контекст фреймбуфера.
  @param[in]     cleanup            Очистить очередь ожидающих кадров перед возвратом.
  @param[out]    surface            Адрес на свободный кадр в очереди фреймбуфера (опционально).
  
  @retval RET_EOK при успешной подготовке кадра и возврате в параметре surface, если он не NULL.
  @retval RET_EOK при успешной подготовке кадра, если параметр surface == NULL.
  @retval RET_NOT_AVAILABLE при переполненной очереди.
  @retval RET_INVALID_MODE при ошибке.
**/
int FramebufferRequestSurface(FRAMEBUFFER_CONTEXT *context, bool cleanup, void **surface);

/**
  Выполнить операцию рисовки на текущий кадр. Вызов данной функции
  кроме как после успешного FramebufferRequestSurface и до FramebufferSubmitSurface
  должен приводить к ошибке.

  Прямой доступ к пикселям (через surface) не должен смешиваться с FramebufferBlit
  в рамках одной пары FramebufferRequestSurface и FramebufferSubmitSurface
  (за исключением явных расширений реализаций).

  @param[in,out] context            Контекст фреймбуфера.
  @param[in]     buffer             Буфер с входными пикселями.
  @param[in]     operation          Операция рисовки:
                                    - FRAMEBUFFER_OPERATION_FILL (заполнить кадр цветом 1 пикселя в буфере)
                                    - FRAMEBUFFER_OPERATION_COPY (скопировать содержимое)
                                    - FRAMEBUFFER_OPERATION_CLEAR (заполнить кадр черным цветом; быстрее, чем FRAMEBUFFER_OPERATION_FILL)
  @param[in]     sourceX            Начальная координата по оси X в исходном изображении (buffer),
                                    только для FRAMEBUFFER_OPERATION_COPY.
  @param[in]     sourceY            Начальная координата по оси Y в исходном изображении (buffer),
                                    только для FRAMEBUFFER_OPERATION_COPY.
  @param[in]     sourcePitch        Количество байт в каждой строке исходного изображения (buffer),
                                    только для FRAMEBUFFER_OPERATION_COPY.
  @param[in]     destinationX       Начальная координата по оси X в конечном изображении.
  @param[in]     destinationY       Начальная координата по оси Y в конечном изображении.
  @param[in]     width              Ширина копируемого или заполняемого блока.
  @param[in]     height             Высота копируемого или заполняемого блока.
  
  @retval RET_EOK при успешном заполнении.
  @retval RET_NOT_AVAILABLE при неподдерживаемой операции.
  @retval RET_INVALID_MODE при ошибке. 
**/
int FramebufferBlit(FRAMEBUFFER_CONTEXT *context, void *buffer,
                         FRAMEBUFFER_OPERATION operation,
                         uint32_t sourceX, uint32_t sourceY, uint32_t sourcePitch,
                         uint32_t destinationX, uint32_t destinationY,
                         uint32_t width, uint32_t height);

/**
  Пометить кадр как готовый к отображению. Вызов
  FramebufferSubmitSurface без ранее успешного вызова
  FramebufferRequestSurface является ошибкой.
  
  Если фреймбуферу требуется преобразование кадра в специальный
  формат для целевого устройства, по возможности оно будет выполнено
  в данной функции. Также в рамках данной операции может производиться
  передача кадра в графическую память или композитор.

  Примечание: если cleanup установлен в TRUE, то имеющиеся в очереди кадры,
  которые ещё не отправлены в устройство, могут быть заменены текущим кадром.

  @param[in,out] context            Контекст фреймбуфера.
  @param[in]     cleanup            Очистить очередь ожидающих кадров в момент отправки.

  @retval RET_EOK кадр помещён в очередь.
  @retval RET_INVALID_MODE при ошибке. 
**/
int FramebufferSubmitSurface(FRAMEBUFFER_CONTEXT *context);

/**
  Отобразить самый старый кадр в очереди и исключить его из очереди.

  Реализация должна обеспечивать максимально быструю реализацию
  данного метода. Кадр должен быть отображён на экран не позднее,
  чем через период обновления экрана.

  Пользователь должен обеспечивать вызов этой функции не реже, чем с используемой
  частотой кадров. Например, для 30 FPS каждые 33.3(3) мс. В случае необходимости
  непостоянной частоты кадров, например, с целью отрисовки статичной картинки,
  пользователь имеет возможность использовать функцию FramebufferSetTimeout.

  В случае работы с композитором отрисовка кадра может начаться с момента вызова
  функции FramebufferSubmitSurface, не дожидаясь вызова функции FramebufferFlip.
  Своевременный вызов FramebufferFlip является обязательным требованием для
  взаимодействия с композитором.

  @param[in,out] context            Контекст фреймбуфера.

  @retval RET_EOK кадр помечен как готовый к отображению.
  @retval RET_NOT_AVAILABLE очередь пуста.
  @retval RET_INVALID_MODE при ошибке.
**/
void FramebufferFlip(FRAMEBUFFER_CONTEXT *context);

#endif // FRAMEBUFFER_H
