var adminFront = angular.module('app', ['ngRoute']);

adminFront.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'p/sellproduct',
      controller: 'mainCtrl'
    })
    .when('/sellproduct', {
      templateUrl: 'p/sellproduct'
    })
    .when('/deliver', {
      templateUrl: 'p/deliver'
    })
    .when('/subsidios', {
      templateUrl: 'p/subsidios'
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
