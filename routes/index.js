var express = require('express');
var router = express.Router();

var api = require('./api.js');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

// For courses
router.get('/p/:name', function(req, res, next) {
	var partial = req.params.name;
	res.render('partials/' + partial);
});

// API URLs
// Agregar Cliente
router.post('/api/bases/agregarCliente', api.agregarCliente);

// Comprar materiales
router.get('/api/bases/getMatFaltantes', api.obtenerMatFaltantes);
router.post('/api/bases/buscarProveedor', api.buscarProveedor);
router.post('/api/bases/agregarProveedor', api.agregarProveedor);
router.post('/api/bases/agregarMaterial', api.carlacachis);

// Creacion de materiales
router.post('/api/bases/buscarMaterial', api.buscarMaterial);
router.post('/api/bases/material', api.crearMaterial);

// venta del producto
router.post('/api/bases/buscarCliente', api.buscarCliente);
router.post('/api/bases/buscarProducto', api.buscarProducto);
router.post('/api/bases/agregarVenta', api.agregarVenta);

// subsidios
router.post('/api/bases/crearSubsidio', api.crearSubsidio);

// delivery
//router.get('/api/bases/obtenerVentas', api.obtenerVentas);
//router.post('/api/bases/obtenerOrden/:id', api.obtenerOrden);
//router.post('/api/bases/obtenerSubOrdenes/:id', api.obtenerSubOrdenes);
//router.post('/api/bases/cambiarDireccion/:id', api.cambiarDireccion);

module.exports = router;
