var adminFront = angular.module('app', ['ngRoute', 'uiGmapgoogle-maps']);

adminFront.config(['$routeProvider', 'uiGmapGoogleMapApiProvider', function($routeProvider, uiGmapGoogleMapApiProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'p/sellproduct',
      controller: 'sellProdCtrl'
    })
    .when('/addclient', {
      templateUrl: 'p/addclient'
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
      templateUrl: 'p/create'
    })
    .when('/staffpay', {
      templateUrl: 'p/staffpay'
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

adminFront.controller('sellProdCtrl', ['$scope', '$http',
  function($scope, $http) {	
		$scope.vp = {
			cliente: "",
			cliente_id: -1,
			productos: [
				{id: 001, nombre: "Producto A", cantidad: 1, precio: 23.21},
				{id: 002, nombre: "Producto B", cantidad: 1, precio: 123.1},
				{id: 003, nombre: "Producto C", cantidad: 1, precio: 442.2}
			],
			factura: 1,
			subtotal: function() {
				a = 0;
				$scope.vp.productos.forEach(function(i) {
					a += i.cantidad * i.precio;
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
				//  /api/bases/obtenerCliente
				console.log("The name is: " + $scope.vp.cliente );
			}
		};
  }
]);

adminFront.controller('deliverCtrl', ['$scope', '$http',
  function($scope, $http) {
		$scope.sp = {
			venta_procesos: [
				{num: 232345,cliente: "ste men 1", estado: "En proceso"},
				{num: 454831,cliente: "ste men 2", estado: "Para ser enviado"}
			]
		}
	}
]);

adminFront.controller('buyMatCtrl', ['$scope', '$http',
  function($scope, $http) {
		$scope.bm = {
			mat_req: [
				{id: 222, nombre: 'material 1', can_act: 2, can_nece: 5},
				{id: 342, nombre: 'material 2', can_act: 3, can_nece: 8},
				{id: 876, nombre: 'material 3', can_act: 0, can_nece: 2}
			],
			search: {
				searchProveedor: function() {
					console.log('Helo' + $scope.bm.search.id);		
					console.log('Helo' + $scope.bm.search.nombre);		
					console.log('Helo' + $scope.bm.search.descripcion);		
				}
			}
		};
		$scope.agp = {
			agregarProveedor: function() {
				console.log($scope.agp.correo);
			}
		};
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
			clientes : [
				{id: 1, nombre: 'Pepito', apellido: 'de los Palotes', telefono: 23452345},
				{id: 2, nombre: 'Jhon', apellido: 'Snow', telefono: 293485}
			],
			takeCliente: function(id) {
				console.log("Taken: " + id);
			},
			addSubsidio: function() {
				var lat = $scope.marker.coords.latitude;
				var lon = $scope.marker.coords.longitude;
				console.log("Latitud: " + lat);
				console.log("Longitud: " + lon);
			}
		};
	}
]);
