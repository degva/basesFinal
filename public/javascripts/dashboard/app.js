var csDash = angular.module('csDash', [
  'ngRoute',
  'dashboardControllers'
]);

csDash.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/', {
      templateUrl: 'dashboard/partials/home',
      controller: 'mainCtrl'
    })
    .when('/contentCreator', {
      templateUrl: 'dashboard/partials/contentCreator',
      controller: 'contentCreatorCtrl'
    })
    .when('/contentCreator/:id', {
      templateUrl: 'dashboard/partials/contentCreator',
      controller: 'contentCreatorCtrl'
    })
    .when('/contentCreator/:course_id/topic',{
      templateUrl: 'dashboard/partials/topic',
      controller: 'ccTopicCtrl'
    })
    .when('/contentCreator/:course_id/topic/:id',{
      templateUrl: 'dashboard/partials/topic',
      controller: 'ccTopicCtrl'
    });
}]);

var csDashControllers = angular.module('dashboardControllers', [
  'ngFileUpload'
]);
