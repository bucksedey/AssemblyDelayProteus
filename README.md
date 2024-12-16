# AssemblyDelayProteus
Programa en ensamblador para DSPIC33FJ32MC202 que genera retardos de 350 ms, 500 ms y 100 µs, con animaciones de 8 bits mostradas en Proteus: shift right, shift left y blink. Las matrices y retardos se controlan por registros, manipulando PORTB para las salidas visuales y PORTA para selección de opciones.

Este programa en ensamblador para el DSPIC33FJ32MC202 implementa retardos programables y animaciones de 8 bits que se muestran en un circuito de Proteus. Incluye retardos de 350 ms, 500 ms y 100 µs, y permite seleccionar entre tres tipos de animaciones: shift right, shift left y blink.

## Detalles del Funcionamiento
Retardos Configurables

Los retardos son seleccionados a través de un registro (W0), con valores específicos:
W0 = 1: Retardo de 500 ms.
W0 = 2: Retardo de 350 ms.
W0 = 3: Retardo de 100 µs.
Los retardos son implementados mediante bucles de decremento para ajustar los tiempos de ejecución.
Animaciones de 8 bits

Las animaciones son seleccionadas a través de otro registro (W1):
W1 = 1: Blink - Intercambio de encendido y apagado en el puerto B.
W1 = 2: Shift Left - Desplazamiento de un bit hacia la izquierda con reinicio al alcanzar el límite.
W1 = 3: Shift Right - Desplazamiento de un bit hacia la derecha con reinicio al alcanzar el límite.
Los puertos del microcontrolador (PORTB) controlan la salida para mostrar estas animaciones.
Puertos Utilizados

PORTB: Controla las salidas de las animaciones.
PORTA: Entrada para configurar las selecciones de retardos y animaciones.
Organización del Código
Selección de Retardos y Animaciones

Un switch_case evalúa el contenido de los registros (W0 y W1) para seleccionar el retardo y la animación correspondiente.
Implementación de Retardos

Se emplean bucles de decremento anidados para generar los tiempos requeridos, considerando los ciclos de instrucción del microcontrolador.
Animaciones

Blink: Invierte el estado de PORTB para encender y apagar los LEDs conectados.
Shift Left: Desplaza un bit a la izquierda y reinicia al llegar al límite (0x200).
Shift Right: Desplaza un bit a la derecha y reinicia al llegar al límite (0x1).
Configuración del Circuito en Proteus
## Componentes

LEDs conectados al puerto PORTB para visualizar las animaciones.
Interruptores para seleccionar retardo y animación a través de PORTA.
Interacción

Cambiar los valores de PORTA permite seleccionar la combinación deseada de retardo y animación.
El circuito muestra en tiempo real el resultado de las animaciones con los retardos configurados.
