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
      templateUrl: 'p/buymaterials'
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

adminFront.controller('sellProdCtrl', ['$scope', '$http',
  function($scope, $http) {	
	}
]);

adminFront.controller('subsiCtrl', ['$scope', '$http', 'uiGmapGoogleMapApi',
	function( $scope, $http, uiGmapGoogleMapApi) {
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
	}
]);
