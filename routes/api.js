var pgp = require('pg-promise')();
var pgCn = require('./pg-config.js').getConnObj();

var api = {
	agregarCliente: function(req, res) {
		var nombre = req.body.nombre;
		var apellido = req.body.apellido;
		var telef = req.body.telf;
		var celular = req.body.cel;

		var correo = req.body.correo;
		var ruc = req.body.ruc;
		var direccion = req.body.direccion;

		var db = pgp(pgCn);

		query1 = "INSERT INTO personas (nombre, apellido, telefono, celular, correo, direccion) VALUES ($1,$2,$3,$4,$5,$6) RETURNING persona_id";
		query2 = "INSERT INTO clientes (persona_id, ruc, razon_social) VALUES ($1,$2,NULL)";
		db.one(query1, [nombre, apellido, telef, celular, correo, direccion])
			.then(function(data) {
				db.none(query2, [data.persona_id, ruc])
					.then(function(data) {
						console.log("Cliente Insertado");
						res.sendStatus(200);
					})
					.catch(function(error) {
						console.log(error);
						res.sendStatus(400);
					});
			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(400);
			});
	},
	agregarProveedor: function(req, res) {
		var razon_social = req.body.razon_social ;
		var descripcion = req.body.descripcion;
		var ruc = req.body.ruc;
		var telf = req.body.telefono;
		var celular = req.body.celular;
		var correo = req.body.correo;
		var direccion = req.body.direccion;

		var db = pgp(pgCn);

		query = "select agregar_proveedor($1,$2,$3,$4,$5,$6,$7)";
		db.one(query, [razon_social, descripcion, parseInt(ruc), parseInt(telf), parseInt(celular), correo, direccion])
			.then(function(data) {
				console.log("Proveedor Insertado");
				res.sendStatus(200);
			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(400);
			});
			// si quiero enviar un json
			// res.json(data);
	},
	buscarProveedor: function(req,res) {
		var id = req.body.id;
		var nombre = req.body.nombre;
		var desc = req.body.descripcion;

		var db = pgp(pgCn);

		query = "select * from buscar_proveedor($1,$2,$3)";
		db.one(query, [id, nombre, desc])
			.then(function(data) {
				console.log('Seencontro a alguien...');
				res.json(data);
			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(404);
			});
			// si quiero enviar un json
			// res.json(data);
	},
	obtenerMatFaltantes: function(req, res) {
		var db = pgp(pgCn);

		db.any("select * from revisar_inventario()" )
			.then(function(data) {
				console.log("Tenemos datos");
				res.json(data);

			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(404);
			});
	},
	buscarMaterial: function(req, res) {
		var val = req.body.val;
		var db = pgp(pgCn);
		db.any("select * from mostrar_materiales ($1)", [val])
			.then(function(data) {
				res.json(data);
			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(404);
			});
	},
	crearMaterial: function(req, res) {
		var nombre = req.body.nombre;
		var precio = req.body.precio;
		var descripcion = req.body.descripcion;
		var materiales = req.body.materiales;

		var db = pgp(pgCn);
		
		var query1 = "select PR_INSERTAR_PRODUCTO ($1, $2, $3)";
		var query2 = "select PR_INSERTAR_PROD_X_MATERIALES ($1, $2, $3)";
		db.one(query1, [nombre, descripcion, precio])
			.then(function(data) {
				var idProd = data.pr_insertar_producto;
				materiales.forEach(function(dato) {
					db.one(query2, [idProd, dato.id, dato.cant])
						.then(function(data) {
							console.log(data);
							res.sendtatus(200);
						})
						.catch(function(error) {
							console.log(error);
							res.sendStatus(500);
						});
				});
			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(404);
			});
	},

	// -- para venta de productos
	buscarCliente: function(req, res) {
		var val = req.body.dato;
		var db = pgp(pgCn);
		db.any("select * from buscar_cliente ($1)", [val])
			.then(function(data) {
				res.json(data);
			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(404);
			});
	},
	buscarProducto: function(req, res) {
		var val = req.body.dato;
		var db = pgp(pgCn);
		db.any("select * from buscar_producto ($1)", [val])
			.then(function(data) {
				res.json(data);
			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(404);
			});
	},
	agregarVenta: function(req, res) {
		var cliente_id = req.body.cliente_id;
		var productos = req.body.productos;
		var factura = req.body.factura;
		var staff_id = req.body.staff_id;
		var subtotal = req.body.subtotal;
		var igv = req.body.igv;

		var db = pgp(pgCn);
	
		var fecha = new Date();
		var anio = fecha.getYear() + 1900;
		var fecha_string = fecha.getMonth() + "-" + fecha.getDate() + "-" + anio;

		var query = "select agregar_venta ($1, $2, $3, '" + fecha_string+ "', $4)";
		var query2 = "insert into prod_x_boleta values ($1, $2, $3, $4)";
		if (factura) {
			precio_total = subtotal + igv;
		} else {
			precio_total = subtotal;
		}

		db.one(query, [precio_total, cliente_id, factura, staff_id])
			.then(function(data) {
				var id = data.agregar_venta;
				console.log('Eu ' + id);
				productos.forEach(function(item) {
					db.none(query2, [id, item.id, 0.0, item.cantidad])
						.then(function(d){
							res.sendStatus(200);
						})
						.catch(function(err) {
							console.log(err);
							res.sendStatus(404);
						});
				});
			})
			.catch(function(error) {
				console.log(error);
				res.sendStatus(404);
			});
	},
	crearSubsidio: function(req, res) {
		var latitud = req.body.latitud;
		var longitud = req.body.longitud;
		var ruc = req.body.ruc;
		var direccion = req.body.direc;
		var id = req.body.id;

		var db = pgp(pgCn);

		query = "select comprar_marca($1,$2,$3,$4,$5)";
		db.one(query, [id, ruc, latitud, longitud, direccion])
			.then(function(data) {
				res.sendStatus(200);
			})
			.catch(function(err) {
				console.log(err);
				res.sendStatus(404);
			});
	},
	carlacachis : function(req, res) {
		var prob_id = req.body.prob_id;
		var monto = req.body.monto;
		var items = req.body.items;

		var db = pgp(pgCn);
		
		query = "select registrarcompra($1,$2,$3)";
		db.one(query, [3, prob_id, monto])
			.then(function(data) {
				items.forEach(function(item){
					db.one("select agregar_material($1,$2,$3,$4)",[item.id, data.registrarcompra, item.precio, item.quantity])
						.then(function(data) {
							res.sendStatus(200);
						})
						.catch(function(err) {
							console.log(err);
							res.sendStatus(404);
						});
				});
			})
			.catch(function(err) {
				console.log(err);
				res.sendStatus(404);
			});
	}

};

module.exports = api;
