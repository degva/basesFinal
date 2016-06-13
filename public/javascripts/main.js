var adminFront = angular.module('app', ['ngRoute']);

adminFront.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'p/home',
      controller: 'mainCtrl'
    })
    .when('/sellproduct', {
      templateUrl: 'p/sellproduct'
    })
    .when('/delivery', {
      templateUrl: 'p/delivery'
    })
    .when('/sellbrand', {
      templateUrl: 'p/sellbrand'
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
}]);

adminFront.run(function($rootScope){
	$rootScope.$on('$viewContentLoaded', function(event, next){
		componentHandler.upgradeAllRegistered();
	});
});

adminFront.controller('mainCtrl', ['$scope', '$http',
  function($scope, $http) {
		console.log("inside main ctrl!");
  }]);
