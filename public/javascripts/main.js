var adminFront = angular.module('app', ['ngRoute']);

adminFront.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'admin/home',
      controller: 'mainCtrl'
    })
    // -- routes for incomes
    .when('/income', {
      templateUrl: 'admin/income'
    })
		// -/- incomes routes

		// --routes for authors
    .when('/authors', {
      templateUrl: 'admin/authors'
    })
		// -/- authors routes

		// -- routes for courses
    .when('/courses', {
      templateUrl: 'admin/courses',
      controller: 'coursesCtrl'
    })
    .when('/courses/create', {
      templateUrl: 'admin/courses-p/create',
      controller: 'coursesCtrl'
    })
		// -/- courses routes
		
		// -- routes for configure 
    .when('/configure', {
      templateUrl: 'admin/configure',
    });
}]);

adminFront.run(function($rootScope){
	$rootScope.$on('$viewContentLoaded', function(event, next){
		componentHandler.upgradeAllRegistered();
	});
});

adminFront.controller('mainCtrl', ['$scope', '$http',
  function($scope, $http) {
    $scope.thes = "User!";
   
    $scope.authors = {};

    $scope.authors.loadAuthors = function () {

      var authors = ['Diego Vargas', 'John Snow'];

      return authors.map(function(c, index) {
        var cParts = c.split(' ');
        var contact = {
          name: c,
          email: cParts[0][0].toLowerCase() + '.' + cParts[1].toLowerCase() + '@example.com',
          image: 'http://lorempixel.com/50/50/people?' + index
        };
        contact._lowername = contact.name.toLowerCase();
        return contact;
      });
    }
    
    $scope.authors.allAuthors = $scope.authors.loadAuthors();
    $scope.authors.person = [$scope.authors.allAuthors[0]];

  }]);

adminFront.controller('coursesCtrl', ['$scope', '$http',
  function($scope, $http) {
    $scope.thes = "User!";
  }]);
