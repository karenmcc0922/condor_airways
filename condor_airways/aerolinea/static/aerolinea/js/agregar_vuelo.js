document.addEventListener('DOMContentLoaded', function() {
    function tryInit() {
        const tipoField = document.getElementById('id_tipo');
        const codigoPreview = document.getElementById('id_codigo_preview');
        const codigoField = document.getElementById('id_codigo');
        const origenField = document.getElementById('id_origen');
        const destinoField = document.getElementById('id_destino');
        const fechaSalidaField = document.getElementById('id_fecha_salida');
        const horaSalidaField = document.getElementById('id_hora_salida');
        const fechaLlegadaField = document.getElementById('id_fecha_llegada');
        const horaLlegadaField = document.getElementById('id_hora_llegada');
        const tiempoVueloField = document.getElementById('id_tiempo_vuelo');
        const capacidadField = document.getElementById('id_capacidad');

        if (!tipoField || !codigoPreview) {
            setTimeout(tryInit, 100);
            return;
        }

        function setValues(value) {
            if (codigoPreview) {
                codigoPreview.value = value;
            }
            if (codigoField) {
                try { 
                    codigoField.value = value; 
                } catch (e) { 
                    // Ignorar errores al establecer valor en field
                }
            }
        }

        function updateCodigo() {
            const tipo = tipoField.value;
            
            if (!tipo) {
                setValues('Seleccione un tipo');
                return;
            }
            
            fetch(`/api/next-codigo/?tipo=${tipo}`)
                .then(response => response.json())
                .then(data => {
                    setValues(data.codigo);
                })
                .catch(error => {
                    console.error('Error al obtener código:', error);
                    setValues('Error al generar código');
                });
        }

        function establecerCapacidadAutomatica() {
            const tipo = tipoField.value;
            
            if (!tipo || !capacidadField) {
                return;
            }
            
            // Establecer capacidad según el tipo de vuelo
            if (tipo === 'NACIONAL') {
                capacidadField.value = '150';
            } else if (tipo === 'INTERNACIONAL') {
                capacidadField.value = '250';
            } else {
                capacidadField.value = '';
            }
        }

        function updateOptions() {
            const tipo = tipoField.value;
            
            if (!tipo) {
                // Limpiar opciones si no hay tipo seleccionado
                if (origenField) {
                    origenField.innerHTML = '<option value="">Seleccione el tipo de vuelo</option>';
                }
                if (destinoField) {
                    destinoField.innerHTML = '<option value="">Seleccione el tipo de vuelo</option>';
                }
                return;
            }
            
            // Obtener la URL correcta para el admin
            const adminUrl = window.location.pathname.includes('/admin/') 
                ? '/admin/aerolinea/vuelo/get_options/' 
                : '/api/get_options/';
            
            fetch(`${adminUrl}?tipo=${tipo}`)
                .then(response => response.json())
                .then(data => {
                    // Actualizar opciones de origen
                    if (origenField) {
                        origenField.innerHTML = '<option value="">Seleccione origen</option>';
                        data.origen_options.forEach(option => {
                            const optionElement = document.createElement('option');
                            optionElement.value = option[0];
                            optionElement.textContent = option[1];
                            origenField.appendChild(optionElement);
                        });
                    }
                    
                    // Actualizar opciones de destino
                    if (destinoField) {
                        destinoField.innerHTML = '<option value="">Seleccione destino</option>';
                        data.destino_options.forEach(option => {
                            const optionElement = document.createElement('option');
                            optionElement.value = option[0];
                            optionElement.textContent = option[1];
                            destinoField.appendChild(optionElement);
                        });
                    }
                })
                .catch(error => {
                    console.error('Error al obtener opciones:', error);
                    if (origenField) {
                        origenField.innerHTML = '<option value="">Error al cargar opciones</option>';
                    }
                    if (destinoField) {
                        destinoField.innerHTML = '<option value="">Error al cargar opciones</option>';
                    }
                });
        }

        function calcularTiempoVuelo() {
            const tipo = tipoField.value;
            const origen = origenField.value;
            const destino = destinoField.value;
            const fechaSalida = fechaSalidaField.value;
            const horaSalida = horaSalidaField.value;
            
            if (!tipo || !origen || !destino || !fechaSalida || !horaSalida) {
                // Limpiar campos si faltan datos
                if (tiempoVueloField) tiempoVueloField.value = '';
                if (fechaLlegadaField) fechaLlegadaField.value = '';
                if (horaLlegadaField) horaLlegadaField.value = '';
                return;
            }
            
            // Validar que origen y destino sean diferentes
            if (origen === destino) {
                alert('El origen y destino no pueden ser iguales');
                return;
            }
            
            // Obtener la URL correcta para el admin
            const adminUrl = window.location.pathname.includes('/admin/') 
                ? '/admin/aerolinea/vuelo/calcular_tiempo_vuelo/' 
                : '/api/calcular_tiempo_vuelo/';
            
            const params = new URLSearchParams({
                tipo: tipo,
                origen: origen,
                destino: destino,
                fecha_salida: fechaSalida,
                hora_salida: horaSalida
            });
            
            fetch(`${adminUrl}?${params}`)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        console.error('Error:', data.error);
                        alert('Error al calcular el tiempo de vuelo: ' + data.error);
                        return;
                    }
                    
                    // Actualizar campos con los valores calculados
                    if (tiempoVueloField) tiempoVueloField.value = data.tiempo_vuelo;
                    if (fechaLlegadaField) fechaLlegadaField.value = data.fecha_llegada;
                    if (horaLlegadaField) horaLlegadaField.value = data.hora_llegada;
                    
                    console.log(`Tiempo de vuelo calculado: ${data.tiempo_vuelo} (Distancia: ${data.distancia} km, Velocidad: ${data.velocidad} km/h)`);
                })
                .catch(error => {
                    console.error('Error al calcular tiempo de vuelo:', error);
                    alert('Error al calcular el tiempo de vuelo');
                });
        }

        // Event listeners
        tipoField.addEventListener('change', function() {
            updateCodigo();
            updateOptions();
            establecerCapacidadAutomatica();
            calcularTiempoVuelo();
        });
        
        tipoField.addEventListener('click', updateCodigo);
        
        // Event listeners para campos que afectan el cálculo
        if (origenField) {
            origenField.addEventListener('change', calcularTiempoVuelo);
        }
        if (destinoField) {
            destinoField.addEventListener('change', calcularTiempoVuelo);
        }
        if (fechaSalidaField) {
            fechaSalidaField.addEventListener('change', calcularTiempoVuelo);
        }
        if (horaSalidaField) {
            horaSalidaField.addEventListener('change', calcularTiempoVuelo);
        }
        
        window.addEventListener('load', function() {
            updateCodigo();
            updateOptions();
            establecerCapacidadAutomatica();
            calcularTiempoVuelo();
        });
        
        // Inicializar al cargar
        updateCodigo();
        updateOptions();
        establecerCapacidadAutomatica();
        calcularTiempoVuelo();
    }

    tryInit();
});
