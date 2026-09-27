# MICROPROYECTOVHDL1
en este repositorio encontraremos un microproyecto propuesto en el curso de VHDL, daremos una propuesta de solución al problema planteado con las temáticas vistas en clase 
############################################################################################################################################
proceso de planteamiento del proyecto                                                                                                     ##
############################################################################################################################################

## 1. Información General del Proyecto
* Título:** Microproyecto 1: Diseño de Temporizadores y Sistemas de Control en VHDL
* Institución:** Universidad del Cauca, Programa de Ingeniería Electrónica y Telecomunicaciones
* Hardware :** FPGA Cyclone III
* Herramienta de Síntesis:Intel Quartus Prime
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
## 2. Definición y Alcance
* Sistema 1 (Control de Espacio): Monitor de ocupación con límite de 35 segundos, alarma de exceso de tiempo y contador de facturación extra.
* Sistema 2 (Temporizador Multibotón): Cronómetro de 0:00 a 9:59 con controles independientes de Start, Stop y Reset, visualizado en displays de 7 segmentos (SSD).
* Sistema 3 (Temporizador Monobotón): Cronómetro unificado donde un solo pulsador alterna el arranque/parada y ejecuta un reinicio si se mantiene presionado por más de 2 segundos.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
## 3. Diseño Arquitectónico 
* Módulo Divisor de Frecuencia:** Toma el reloj maestro de la FPGA (ej. 50 MHz) y genera pulsos exactos de 1 Hz mediante un contador interno.
* Módulo de Control (FSM / Lógica central):** Procesa las entradas físicas (botones/sensores) y gestiona los contadores internos.
* Módulo de Contadores BCD:** Divide el tiempo en unidades y decenas (cascada de 0-9 y 0-5) para facilitar la visualización hasta los 9 minutos y 59 segundos.
* Módulo Decodificador 7 Segmentos:** Arquitectura de flujo de datos que traduce los valores BCD a los pines físicos (ánodo/cátodo común) del hardware.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
## 4. Modelado Lógico y Máquinas de Estados (FSM)
FSM Ejercicio 1 (Control de Espacio):
* Estado LIBRE:** Sistema en reposo, contadores en cero. Transición a *OCUPADO_LIMITE* al detectar un '1' en el sensor.
* Estado OCUPADO_LIMITE:** Conteo hasta 35s.
* Condición A: Si el sensor baja a '0', enciende LED de felicitación y retorna a *LIBRE*.
* Condición B:Si el contador llega a 35, pasa a *EXCESO_TIEMPO*.
* Estado EXCESO_TIEMPO: Enciende alarma permanente, inicia contador de facturación. Retorna a *LIBRE* cuando el sensor baja a '0'.
Lógica de Control Ejercicio 2 (Un Botón):
* Evaluación de flancos y tiempo:Un temporizador interno cuenta la duración de la presión del botón.
* Toggle (Start/Stop): Se activa al detectar un flanco de bajada (botón soltado) si el tiempo de presión superó el umbral anti-rebote pero fue menor a 2 segundos.
* Reset Asíncrono:Se activa automáticamente si el contador de presión alcanza el equivalente exacto a 2 segundos continuos.

## 5. Estrategia de Implementación VHDL
* Arquitectura Estructural: Utilizada en los archivos `Top-Level` para instanciar (conectar mediante `port map`) el reloj, el cerebro lógico y los múltiples decodificadores de display.
* Arquitectura Comportamental: Utilizada mediante bloques `process` síncronos al reloj para describir las transiciones de las máquinas de estados y los incrementos de los temporizadores.
* Arquitectura por Flujo de Datos: Utilizada en el bloque decodificador (`case` o `with-select`) para asignar concurrentemente los bits de salida a los segmentos.
## 6. Integración y Síntesis
* Asignación de Pines:** Uso de *Pin Planner* para mapear las entradas a los switches/pulsadores y las salidas a los LEDs/Displays correspondientes.
############################################################################################################################################################
La Inteligencia Artificial sirvió como herramienta de apoyo técnico y referencia durante el desarrollo de este Microproyecto, manteniendo el diseño, la lógica y la estructura bajo autoría propia. Su integración abarcó tres puntos clave:

Control de versiones (Git): Asistencia en la sintaxis del .gitignore para filtrar los archivos temporales de compilación de Quartus.

Estructura VHDL: Soporte sintáctico para instanciar módulos y codificar máquinas de estados bajo las arquitecturas DataFlow, Comportamental y Estructural.

Depuración (Troubleshooting): Ayuda para traducir e identificar la causa de errores de compilación, en particular la regla de "Multiple constant drivers", lo que guio la optimización de las condiciones de paro en el hardware.
