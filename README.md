# MICROPROYECTOVHDL1

En este repositorio se encuentra el desarrollo de un microproyecto propuesto para el curso de VHDL. Presentamos una solución al problema planteado aplicando estrictamente las temáticas fundamentales vistas en clase, optimizando la lógica matemática y adaptando el diseño a las restricciones físicas del hardware.

############################################################################################################################################
Proceso de planteamiento del proyecto

############################################################################################################################################

## 1. Información General del Proyecto

* **Título:** Microproyecto 1: Diseño de Temporizadores y Sistemas de Control en VHDL
* **Institución:** Universidad del Cauca, Programa de Ingeniería Electrónica y Telecomunicaciones
* **Hardware:** FPGA Altera DE0 (Cyclone III)
* **Herramienta de Síntesis:** Intel Quartus Prime
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

## 2. Definición y Alcance

* **Sistema 1 (Control de Espacio):** Monitor de ocupación con límite de 35 segundos, alarma de exceso de tiempo y contador de facturación extra.
* **Sistema 2 (Temporizador Multibotón):** Cronómetro de 0:00 a 9:59 con controles independientes de Start, Stop y Reset, visualizado en displays de 7 segmentos (SSD).
* **Sistema 3 (Temporizador Monobotón):** Cronómetro unificado donde un solo pulsador alterna el arranque/parada y ejecuta un reinicio si se mantiene presionado por más de 2 segundos, implementando un filtro antirrebote digital avanzado.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

## 3. Diseño Arquitectónico y Manejo de Relojes

* **Arquitectura Síncrona a 50 MHz:** El procesamiento lógico central, la detección de flancos y el muestreo de los botones se ejecutan directamente utilizando el reloj maestro de la FPGA (50 MHz) para garantizar una respuesta instantánea y libre de errores de desincronización (Clock Domain Crossing).
* **Base de Tiempo Exacta:** Mediante contadores matemáticos internos, el reloj de 50 MHz se divide para generar incrementos precisos de 1 segundo (50,000,000 ciclos) que gobiernan el avance de los cronómetros.
* **Módulo de Contadores BCD:** El tiempo se codifica nativamente en unidades y decenas (cascada de 0-9 y 0-5) para facilitar su conexión a los displays de 7 segmentos.
* **Separador Decimal:** Se integró el encendido estático del punto decimal (DP) en el display correspondiente a los minutos para brindar una lectura visual ergonómica en formato M.SS.
* **Módulo Decodificador 7 Segmentos:** Arquitectura de flujo de datos que traduce los valores BCD a los pines físicos (ánodo común) del hardware.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

## 4. Modelado Lógico (Enfoque Aritmético Fundamental)

Para cumplir estrictamente con los requerimientos de diseño de nivel introductorio, **se descartó el uso de Máquinas de Estados Finitos (FSM) abstractas y el almacenamiento en banderas booleanas internas (`std_logic`)**. Toda la toma de decisiones se rige puramente por lógica matemática condicional (`If/Else`) y variables de tipo entero (`integer`).

**Lógica de Control Ejercicio 1 (Control de Espacio):**

* Evaluaciones aritméticas directas sobre el sensor y los contadores BCD.
* Condición de Límite: Si el cronómetro base alcanza matemáticamente 35s (`bd=3` y `bu=5`), se bloquea y habilita el incremento del cronómetro secundario junto con el encendido de la alarma.
* Condición de Salida: Al detectar que el sensor baja a '0', si el tiempo es mayor a 0 pero no alcanzó el límite de 35, se enciende el LED de felicitación.

**Lógica de Control Ejercicio 3 (Temporizador Monobotón - Filtro Integrador):**

* **Filtro Antirrebote Matemático:** Un algoritmo de integración evalúa el estado del botón cada 1 milisegundo. Acumula el tiempo de presión en una variable entera, logrando inmunidad total contra el ruido mecánico y micro-rebotes de desconexión.
* **Ejecución al Soltar (Acción Segura):** La orden de Arranque/Pausa se ejecuta únicamente en el momento en que se suelta el pulsador, verificando matemáticamente que fue un toque intencional (>30 ms).
* **Reset por Presión Larga:** Si la variable integradora alcanza 2000 ms continuos (2 segundos), el sistema fuerza la pausa, limpia los displays a 0.00 al instante y marca una variable de "acción tomada" para evitar un arranque accidental al levantar el dedo.

## 5. Estrategia de Implementación VHDL

* **Arquitectura Estructural:** Utilizada en los archivos `Top-Level` para instanciar (conectar mediante `port map`) el reloj, el cerebro lógico y los múltiples decodificadores de display.
* **Arquitectura Comportamental:** Utilizada mediante bloques `process` síncronos al reloj maestro para describir la lógica aritmética y los incrementos de los temporizadores.
* **Arquitectura por Flujo de Datos:** Utilizada en el bloque decodificador (`case` o `with-select`) para asignar concurrentemente los bits de salida a los segmentos.

## 6. Integración y Síntesis

* **Asignación de Pines:** Uso de *Pin Planner* para mapear el reloj maestro a 50 MHz, las entradas a los switches/pulsadores y las salidas a los LEDs/Displays correspondientes, respetando la lógica activa en bajo requerida por los componentes de la tarjeta.
###################################################################################################


La Inteligencia Artificial #gemini pro 3.1" sirvió como herramienta de apoyo técnico y referencia durante el desarrollo de este Microproyecto, manteniendo el diseño, la lógica y la estructura bajo autoría propia. Su integración abarcó tres puntos clave:

Control de versiones (Git): Asistencia en la sintaxis del .gitignore para filtrar los archivos temporales de compilación de Quartus.

Estructura VHDL: Soporte sintáctico para instanciar módulos y codificar máquinas de estados bajo las arquitecturas DataFlow, Comportamental y Estructural.

Depuración (Troubleshooting): Ayuda para traducir e identificar la causa de errores de compilación, en particular la regla de "Multiple constant drivers", lo que guio la optimización de las condiciones de paro en el hardware.
