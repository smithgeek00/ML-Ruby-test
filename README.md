Automatización Mercado Libre - PlayStation 5 (Android)
Proyecto de automatización de pruebas móviles para búsqueda de PlayStation 5 en Mercado Libre Android usando Ruby y Appium.

**Descripción**
Este proyecto automatiza el siguiente flujo en la app móvil de Mercado Libre:

1. Abrir aplicación de Mercado Libre en Android
2. Buscar "PlayStation 5"
3. Obtener los primeros 5 productos
4. Imprimir títulos en consola
5. Generar screenshots de cada paso

Nota: Los filtros (Nuevos, CDMX, ordenamiento) están pendientes de implementación debido a la complejidad en la identificación de elementos dinámicos en la interfaz móvil.

--- Tecnologías ---

Ruby v3.4.0
Appium v2.x
UiAutomator2 (Android)
Android SDK
Appium Inspector (para debugging)


Estructura del Proyecto

ML-Ruby-Test/
*mercado_test.rb           # Script principal
*mercado_test_simple.rb    # Versión con búsqueda manual
DIR- *screenshots/              # Capturas automáticas
* Gemfile                   # Dependencias Ruby
-> README.md

** Instalación
Requisitos Previos

-Ruby 3.4+
-Node.js 18+
-Android Studio (para SDK y emulador)
-Java JDK 11+

Pasos de Instalación
1. Clonar el repositorio
bashgit clone https://github.com/TU_USUARIO/ML-Ruby-Test.git
cd ML-Ruby-Test
2. Instalar Ruby (Windows)
bash# Descargar desde: https://rubyinstaller.org/
ruby --version
3. Instalar Appium
bashnpm install -g appium
appium driver install uiautomator2
appium --version
4. Instalar dependencias Ruby
bashbundle install
5. Configurar Android
bash# Verificar dispositivo conectado
adb devices

# Instalar Mercado Libre en el emulador
# (desde Google Play Store)

▶️ Ejecución
Ejecutar el test
1. Iniciar Appium Server (en terminal separada)
bashappium
2. Iniciar emulador Android
bash# Desde Android Studio o:
emulator -avd Pixel_4_API_30
3. Ejecutar el test
bash ruby mercado_test.rb
Ejecutar versión simplificada (manual)

# Sigue las instrucciones en pantalla

** Resultados
Consola
El test imprime en consola los productos encontrados:

PRIMEROS 5 PRODUCTOS:
═══════════════════════════════════════════════════════════
1. PRODUCTO
2. PRODUCTO
3. PRODUCTO
4. PRODUCTO
5. PRODUCTO

PRUEBA EXITOSA - Se encontraron los primeros 5 productos
═══════════════════════════════════════════════════════════
Screenshots
Los screenshots se guardan automáticamente en screenshots/:


** Características Implementadas

* Conexión con emulador Android
* Apertura automática de Mercado Libre
* Búsqueda de "PlayStation 5"
* Extracción de títulos de productos
* Screenshots automáticos



*Limitaciones Conocidas
Pendientes de implementación:

 -Filtro por condición "Nuevos"
 -Filtro por ubicación "CDMX"


# Actualizar en el código si es diferente
Error: "Element not found"
bash# Usar Appium Inspector para identificar elementos
# Config JSON en Inspector:
{
  "platformName": "Android",
  "appium:deviceName": "emulator-5554",
  "appium:appPackage": "com.mercadolibre",
  "appium:appActivity": "com.mercadolibre.navigation.activities.BottomBarActivity",
  "appium:noReset": true
}
Error: "UiAutomator2 server crashed"
bash# Reinstalar driver
appium driver uninstall uiautomator2
appium driver install uiautomator2


** Notas

-El test está configurado para emulator-5554 (cambiar si usas otro dispositivo)
Requiere que Mercado Libre esté instalado previamente
Tiempo aproximado: 30-45 segundos
Los selectores pueden cambiar si la app se actualiza


**Proceso de Desarrollo
Este proyecto implicó:

Investigación: Configuración de entorno Appium + Ruby + Android
Debugging: Identificación de Activities y elementos correctos
Iteración: Múltiples versiones para mejorar estabilidad
Documentación: Registro del proceso y soluciones

**Aprendizajes clave:
-Uso de Appium Inspector para identificar elementos
-Importancia de waits explícitos en apps móviles
-Manejo de crashes del servidor UiAutomator2
-Documentación técnica clara


**Autor: BARCENAS RESENDIZ LUIS ALBERTO

GitHub: @smithgeek00
Email: nyangeek@gmail.com


**Licencia
Proyecto desarrollado como prueba técnica para Claro Video - Hitss.
Fecha de creación: Noviembre 2025
Versión: 1.0.0
