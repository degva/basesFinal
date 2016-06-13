var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

// For courses
router.get('/admin/courses-p/:name', function(req, res, next) {
	var partial = req.params.name;
	res.render('partials/courses_partials/' + partial);
});

// For everything else
router.get('/admin/:name', function(req, res, next) {
  var partial = req.params.name;
  res.render('partials/' + partial);
});

module.exports = router;
