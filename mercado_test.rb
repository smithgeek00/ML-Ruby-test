require 'appium_lib'
require 'fileutils'

def caps
  {
    caps: {
      platformName: 'Android',
      deviceName: 'emulator-5554',
      appPackage: 'com.mercadolibre',
      appActivity: 'com.mercadolibre.navigation.activities.BottomBarActivity',
      automationName: 'UiAutomator2',
      newCommandTimeout: 3600,
      noReset: true,
      dontStopAppOnReset: true,
      skipDeviceInitialization: false,
      skipServerInstallation: false
    },
    appium_lib: {
      server_url: 'http://127.0.0.1:4723',
      wait: 10
    }
  }
end

def screenshot(driver, nombre)
  FileUtils.mkdir_p('screenshots')
  path = "screenshots/#{nombre}.png"
  driver.screenshot(path)
  puts " #{nombre}.png"
rescue => e
  puts " Error screenshot: #{e.message}"
end

driver = nil

begin
  puts "\n INICIO - Mercado Libre Test"
  puts "=" * 50
  
  # Iniciar driver
  puts "Iniciando Appium..."
  driver = Appium::Driver.new(caps, true)
  driver.start_driver
  puts " Driver iniciado\n"
  
  # Verificar que estamos en Mercado Libre
  sleep 5
  paquete = driver.current_package
  puts " App: #{paquete}"
  
  if paquete != 'com.mercadolibre'
    puts "⚠ No estamos en Mercado Libre. Reactivando app..."
    driver.activate_app('com.mercadolibre')
    sleep 3
  end
  
  screenshot(driver, "01_inicio")
  
  # PASO 1: Buscar y hacer clic en campo de búsqueda
  puts "\n PASO 1: Buscar campo de búsqueda"
  
  campo = nil
  3.times do |intento|
    begin
      puts "Intento #{intento + 1}..."
      campo = driver.find_element(:id, 'com.mercadolibre:id/ui_components_toolbar_title_toolbar')
      break if campo.displayed?
    rescue
      sleep 2
    end
  end
  
  raise " Campo no encontrado" unless campo
  
  puts " Campo encontrado"
  screenshot(driver, "02_campo_encontrado")
  
  # Hacer clic
  puts "Haciendo clic..."
  campo.click
  sleep 3
  screenshot(driver, "03_despues_click")
  
  # Buscar EditText
  puts "Buscando EditText..."
  edit = nil
  
  begin
    edit = driver.find_element(:class_name, 'android.widget.EditText')
  rescue
    puts " EditText no encontrado, buscando por ID..."
    edit = driver.find_element(:id, 'com.mercadolibre:id/search_input') rescue nil
  end
  
  raise " EditText no encontrado" unless edit
  
  puts "✅ EditText encontrado"
  
  # Escribir
  puts "Escribiendo 'PlayStation 5'..."
  edit.clear rescue nil
  edit.send_keys('PlayStation 5')
  sleep 2
  screenshot(driver, "04_texto_ingresado")
  
  # Enviar búsqueda
  puts "Enviando búsqueda (Enter)..."
  driver.press_keycode(66)
  
  puts "Esperando resultados..."
  sleep 10
  screenshot(driver, "05_resultados")
  
  # PASO 2: Obtener productos
  puts "\n PASO 2: Obtener productos"
  
  # Hacer scroll
  puts "Haciendo scroll..."
  driver.swipe(start_x: 500, start_y: 1500, end_x: 500, end_y: 500, duration: 800) rescue nil
  sleep 2
  
  # Buscar títulos
  puts "Buscando títulos de productos..."
  titulos = []
  
  # Intentar con diferentes IDs
  ids_producto = [
    'com.mercadolibre:id/item_title',
    'com.mercadolibre:id/title',
    'com.mercadolibre:id/ui_search_result_title'
  ]
  
  ids_producto.each do |id|
    begin
      puts "  Probando: #{id}"
      elementos = driver.find_elements(:id, id)
      
      elementos.each do |elem|
        texto = elem.text.strip rescue ""
        # Filtrar menú y textos cortos
        next if texto.empty?
        next if texto.length < 10
        next if ['Inicio', 'Favoritos', 'Carrito', 'Clips', 'Mi cuenta'].include?(texto)
        
        titulos << texto
      end
      
      break if titulos.size >= 5
    rescue => e
      puts "   #{e.message}"
    end
  end
  
  # Si no encontramos, listar todos los TextView grandes
  if titulos.size < 5
    puts "\n Buscando con método alternativo..."
    
    todos = driver.find_elements(:class_name, 'android.widget.TextView')
    todos.each do |tv|
      texto = tv.text.strip rescue ""
      next if texto.empty?
      next if texto.length < 10
      next if ['Inicio', 'Favoritos', 'Carrito', 'Clips', 'Mi cuenta'].include?(texto)
      
      titulos << texto unless titulos.include?(texto)
      break if titulos.size >= 5
    end
  end
  
  # Mostrar resultados
  puts "\n" + "=" * 50
  puts " RESULTADOS:"
  puts "=" * 50
  
  if titulos.size >= 5
    titulos.first(5).each_with_index do |titulo, i|
      puts "#{i + 1}. #{titulo}"
    end
    puts "\n ÉXITO: 5 productos encontrados"
  else
    puts " Solo se encontraron #{titulos.size} productos:"
    titulos.each_with_index do |titulo, i|
      puts "#{i + 1}. #{titulo}"
    end
  end
  
  puts "=" * 50

rescue => e
  puts "\n ERROR: #{e.message}"
  puts e.backtrace.first(3).join("\n")
  screenshot(driver, "ERROR") if driver
  
ensure
  if driver
    puts "\n Cerrando..."
    driver.driver_quit rescue nil
  end
  puts " FIN\n"
end