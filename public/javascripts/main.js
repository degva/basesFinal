var adminFront = angular.module('app', ['ngRoute', 'uiGmapgoogle-maps']);

adminFront.config(['$routeProvider', 'uiGmapGoogleMapApiProvider', function($routeProvider, uiGmapGoogleMapApiProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'p/sellproduct',
      controller: 'sellProdCtrl'
    })
    .when('/addclient', {
      templateUrl: 'p/addclient',
			controller: 'addCliCtrl'
    })
    .when('/sellproduct', {
      templateUrl: 'p/sellproduct'
    })
    .when('/deliver', {
      templateUrl: 'p/deliver',
			controller: 'deliverCtrl'
    })
    .when('/subsidios', {
      templateUrl: 'p/subsidios',
			controller: 'subsiCtrl'
    })
    .when('/buymaterials', {
      templateUrl: 'p/buymaterials',
			controller: 'buyMatCtrl'
    })
    .when('/create', {
      templateUrl: 'p/create',
			controller: 'createCtrl'
    })
    .when('/staffpay', {
      templateUrl: 'p/staffpay',
			controller: 'staffCtrl'
    })
    .when('/log-out', {
      templateUrl: 'p/log-out'
    });
    uiGmapGoogleMapApiProvider.configure({
        key: 'AIzaSyC775mDWk-PWsor_N3U39MlhZWcPDgMd9c',
        v: '3.20', //defaults to latest 3.X anyhow
        libraries: 'weather,geometry,visualization'
    });
}]);

adminFront.run(function($rootScope){
	$rootScope.$on('$viewContentLoaded', function(event, next){
		componentHandler.upgradeAllRegistered();
	});
});

adminFront.controller('addCliCtrl', ['$scope', '$http',
	function($scope, $http) {
		$scope.add = {
			data: {},
			addCliente: function() {
				$http({
					url: "/api/bases/agregarCliente",
					method: "POST",
					data: JSON.stringify($scope.add.data),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data, status, headers, config) {
					if (status == 200) {
						alert('Cliente insertado!');
						$scope.add.data = {};
					} else {
						alert('Error papu :\'v');
					}
				})
			}
		};
	}
]);

adminFront.controller('sellProdCtrl', ['$scope', '$http',
  function($scope, $http) {	
		$scope.vp = {
			cliente: "",
			cliente_id: -1,
			productos: [
				//{id: 003, nombre: "Producto C", cantidad: 1, precio: 442.2}
			],
			factura: 1,
			subtotal: function() {
				var a = 0;
				$scope.vp.productos.forEach(function(i) {
					a += i.cantidad * i.precio_unitario;
				});
				return a;
			},
			igv: function() {
				if ($scope.vp.factura == 1) {
					return $scope.vp.subtotal() * 0.18;
				} else {
					return 0;
				}
			},
			buscarCliente: function() {
				// buscar con el API a
				$http({
					url: '/api/bases/buscarCliente',
					method: 'post',
					data: JSON.stringify({
						dato: $scope.vp.cliente
					}),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data) {
					$scope.vp.cliente_resultado = data;
				})
				.error(function(err) {
					alert('algo paso');
					console.log(err);
				});
			},
			tomaCliente: function(item) {
				$scope.vp.cliente_id = item.id;
				$scope.vp.cliente = item.nombre + ' ' + item.apellido;
				$scope.vp.cliente_resultado = [];
			},

			buscaProducto: function() {
				$http({
					url: '/api/bases/buscarProducto',
					method: 'post',
					data: JSON.stringify({
						dato: $scope.vp.prod_busqueda
					}),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data) {
					$scope.vp.producto_resultado = data;
				})
				.error(function(err) {
					alert('algo paso');
					console.log(err);
				});
			},
			tomaProducto: function(item) {
				$scope.vp.productos.push(item);
				$scope.vp.prod_busqueda = "";
				$scope.vp.producto_restulado = [];
			},

			concretarVenta: function() {

				$http({
					url: '/api/bases/agregarVenta',
					method: 'post',
					data: JSON.stringify({
						cliente_id: $scope.vp.cliente_id,
						productos: $scope.vp.productos,
						factura: $scope.vp.factura,
						staff_id: 3,
						subtotal: $scope.vp.subtotal(),
						igv: $scope.vp.igv()
					}),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data) {
					alert('venta hecha');
				})
				.error(function(err) {
					alert('algo paso');
					console.log(err);
				});
				
			}

		};
  }
]);

adminFront.controller('deliverCtrl', ['$scope', '$http',
  function($scope, $http) {
		$scope.sp = {
			venta_procesos: [
				{num: 58327,cliente: "ste men 1", estado: "En proceso",
					ordenes: [
						{id: 2345, descuento: 0.5, cantidad: 2,
							subordenes: [
								{id: 1234,estado:'en contruccion'}
							]
						},
						{id: 6782, descuento: 0, cantidad: 3,
							subordenes: [
								{id: 3234,estado:'No se Loco'}
							]
						}
					]
				},
				{num: 45481,cliente: "ste men 2", estado: "Para ser enviado", 
					ordenes: [
						{id: 4234, descuento: 0.05, cantidad: 2,
							subordenes: [
								{id: 1234,estado:'en contruccion'},
								{id: 4234,estado:'No se :\'v'},
								{id: 3424,estado:'Asume no ma'}
							]
						},
						{id: 6345, descuento: 0.0, cantidad: 8},
						{id: 1342, descuento: 0.2, cantidad: 6}
					]
				}
			],
			tomaProceso: function(item) {
				$scope.sp.nu_orden = item.num;
				$scope.sp.nu_ordenes = item.ordenes;
			},
			tomaSubProceso: function(item) {
				$scope.sp.nu_subordenes = item.subordenes;
			}
		};
	}
]);

adminFront.controller('buyMatCtrl', ['$scope', '$http',
  function($scope, $http) {
		$scope.bm = {
			mat_req: [
			],
			search: {
				searchProveedor: function() {
					$http({
						url: '/api/bases/buscarProveedor',
						method: 'post',
						data: JSON.stringify($scope.bm.search),
						headers: {'Content-Type': 'application/json'}
					})
					.success(function(data, status, headers, config) {
						if (status == 200) {
							alert('Proveedor encontrado!');
							$scope.bm.result = data;
						}
					})
					.error(function(data, status, headers, config) {
						alert('no se encontro a nadie');
					});
				}
			}
		};
		$scope.agp = {
			agregarProveedor: function() {
				$http({
					url: '/api/bases/agregarProveedor',
					method: 'post',
					data: JSON.stringify($scope.agp.dato),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data, status, headers, config) {
					if (status == 200) {
						alert('Proveedor Agregado!');
						$scope.agp.dato = {};
					}
				})
				.error(function(data, status, headers, config) {
					alert('Hubo un error...');
				});
			}
		};

		$scope.agm = {
			data : {
				items : []
			},
			addItem: function() {
				$scope.agm.data.items.push({id: 0, quantity: '0', precio: '0'});
			},
			agregarMateriales: function() {
				$http({
					url: '/api/bases/agregarMaterial',
					method: 'post',
					data: JSON.stringify($scope.agm.data),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data, status, headers, config) {
					alert('yay!');
				})
				.error(function(data, status, headers, config) {
					console.log('error');
				});
			}
		};
		$http({
			url: "/api/bases/getMatFaltantes",
			method: "GET",
			headers: {'Content-Type': 'application/json'}
		})
		.success(function(data, status, headers, config) {
			if (status == 200) {
				console.log(data);
				$scope.bm.mat_req = data;
			} else {
				alert('Error papu :\'v');
			}
		});
	}
]);

adminFront.controller('createCtrl', ['$scope', '$http',
	function($scope, $http) {
		$scope.cc = {
			materiales : [
			],
			buscar : function() {
				var str = $scope.cc.material_busc;
				$http({
					url: '/api/bases/buscarMaterial',
					method: 'post',
					data: JSON.stringify({val: str}),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data, status, headers, config) {
					$scope.cc.resultados = data;
				});
			},
			addMaterial: function(mat) {
				mat.cant = 0;
				$scope.cc.materiales.push(mat);
			},
			total: function() {
				var a = 0;
				$scope.cc.materiales.forEach(function(i) {
					a += i.cant * i.precio_unitario;
				});
				return (a * 1.55).toFixed(2);
			},
			create_prod: function() {
				// toma todas las variables y las manda por API
				$http({
					url: '/api/bases/material',
					method: 'post',
					data: JSON.stringify({
						nombre: $scope.cc.nombre,
						descripcion: $scope.cc.descripcion,
						materiales: $scope.cc.materiales,
						precio: $scope.cc.total()
					}),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data, status, headers, config) {
					alert('producto Creado!');
					$scope.cc.nombre= "";
					$scope.cc.descripcion = "";
					$scope.cc.materiales = [];
					$scope.cc.resultados = [];
				});
			}
		};
	}
]);

adminFront.controller('staffCtrl', ['$scope', '$http',
	function($scope, $http) {
		$scope.sp = {
			staffs : [
				{id: 234, nombre: 'ssg'},
				{id: 564, nombre: 'hfkdg'}
			],
			putIntoDetails : function (id) {
				$scope.sp._st_id = id;
				$scope.sp._st_details = [
					{descripcion: 'thiss that', monto: 234},
					{descripcion: 'thiss that', monto: 347.33}
				];
				$scope.sp._st_total = 0;
				$scope.sp._st_details.forEach(function(i) {
					$scope.sp._st_total += i.monto;
				});
			},
			pagar: function() {
				// mandar todo por la API
			}
		}
	}
]);

adminFront.controller('subsiCtrl', ['$scope', '$http', 'uiGmapGoogleMapApi',
	function( $scope, $http, uiGmapGoogleMapApi) {

		// no tocar todo este bloque :'v
		// -------------------------------------------------------------------------------
		$scope.map = { center: { latitude: -12.072668, longitude: -77.079427 }, zoom: 15 };
		$scope.options = {scrollwheel:  true};
		$scope.marker = {
			id: 0,
			coords: {
				latitude: -12.072668, 
				longitude: -77.079427
			},
			options: {draggable: true},
			events: {
				dragend: function(marker, eventName, args) {
					console.log("marker dragend");
					var lat = marker.getPosition().lat();
					var lon = marker.getPosition().lng();
					$scope.marker.options = {
						draggable: true,
						labelContent: "lat: " + $scope.marker.coords.latitude + ' lon: ' + $scope.marker.coords.longitude,
						labelAnchor: "100 0",
						labelClass: "marker-labels"
					}
				}
			}
		};
		uiGmapGoogleMapApi.then(function(maps) {
		});
		// -------------------------------------------------------------------------------
		
		$scope.sub = {
			buscarCliente: function() {
				// buscar con el API a
				$http({
					url: '/api/bases/buscarCliente',
					method: 'post',
					data: JSON.stringify({
						dato: $scope.sub.cliente_bus
					}),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data) {
					$scope.sub.clientes = data;
				})
				.error(function(err) {
					alert('algo paso');
					console.log(err);
				});
			},
			tomaCliente: function(item) {
				$scope.sub.cliente_id = item.id;
				$scope.sub.cliente_nombre = item.nombre;
				$scope.sub.cliente_apellido = item.apellido;
				$scope.sub.clientes = [];
			},
			addSubsidio: function() {
				var lat = $scope.marker.coords.latitude;
				var lon = $scope.marker.coords.longitude;

				$http({
					url: '/api/bases/crearSubsidio',
					method: 'post',
					data: JSON.stringify({
						latitud: lat,
						longitud: lon,
						direc: $scope.sub.direccion,
						ruc: $scope.sub.ruc,
						id: $scope.sub.cliente_id
					}),
					headers: {'Content-Type': 'application/json'}
				})
				.success(function(data) {
					alert('ocs :\'v');
				})
				.error(function(err) {
					alert('algo paso');
					console.log(err);
				});
			}
		};
	}
]);
