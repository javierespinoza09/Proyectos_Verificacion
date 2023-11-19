# Modulos
## Driver
### Funciones
- Conexión con DUT para generar estímulos
- Recibir items e interpretarlos para generar señales al DUT
- Cargar datos en una cola de entrada
- Informar al SB sobre paquetes que han sido enviados
## Agente
Contiene arreglo de Drivers y secuenciadores para comunicar los datos según sea la prueba
Genera un mapeo de drivers a su corespndiente fila y columna
### Funciones
- Contener el arreglo de Drivers, monitores y secueciadores
- Conectar los distintos Drivers a su correspondiente secuenciador
## Secuencia
Se le asigna un valor especifico relacionado con el driver al que corresponde, este valor de agrega al Item para validar el destino.
### Funciones
- Evaluar el caso de prueba
- Activar y desactivar restricciones en el item 
- Aleatorizar los items 
- Cargarlos en la secuenciador




