--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: almacen; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY almacen (almacen_id, nombre, ubicacion) FROM stdin;
1	almacen1	taller_V
\.


--
-- Data for Name: personas; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY personas (persona_id, nombre, apellido, direccion, telefono) FROM stdin;
1	pepito	condor	su casa	5555555
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY clientes (persona_id, ruc, razon_social) FROM stdin;
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY staff (persona_id, fecha_ingreso, sueldo) FROM stdin;
1	2016-06-21 20:48:00.481875	800
\.


--
-- Data for Name: subsidios; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY subsidios (subsidio_id, direccion_local, latitud, longitud, cliente_id) FROM stdin;
\.


--
-- Data for Name: boleta; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY boleta (boleta_id, subsidio_id, precio_total, cliente_id, factura, fecha, staff_id, fecha_modificacion, _bono, delivery) FROM stdin;
\.


--
-- Data for Name: estado; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY estado (estado_id, descrip) FROM stdin;
0	no hay delivery
1	orden registrada
2	orden procesada
3	listo para enviar
4	enviado
\.


--
-- Data for Name: boleta_x_estado; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY boleta_x_estado (boleta_id, estado_id, fecha) FROM stdin;
\.


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY proveedores (proveedor_id, razon_social, descripcion, ruc, telefono, celular, correo, direccion) FROM stdin;
\.


--
-- Data for Name: compra_productos; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY compra_productos (egreso_id, persona_id, proveedor_id, total, fecha) FROM stdin;
\.


--
-- Data for Name: estado_de_orden; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY estado_de_orden (estado_id, descrip) FROM stdin;
1	proceso registrado
2	fabricandose
3	listo para fabricar
\.


--
-- Name: estado_de_orden_estado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander
--

SELECT pg_catalog.setval('estado_de_orden_estado_id_seq', 1, false);


--
-- Name: estado_estado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander
--

SELECT pg_catalog.setval('estado_estado_id_seq', 1, false);


--
-- Name: ingresos_venta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander
--

SELECT pg_catalog.setval('ingresos_venta_id_seq', 1, false);


--
-- Data for Name: materiales; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY materiales (material_id, nombre, descripcion) FROM stdin;
1	botella azul	altura: 10cm, ancho: 10cm
2	botella roja	altura: 50cm, ancho: 10cm
3	botella verde	altura: 50cm, ancho: 10cm
4	minibotella	altura: 7cm, ancho: 5cm
5	botella dama Juana	altura: 40cm, ancho: 80cm
6	vidrio 10x10	altura: 10cm, ancho: 10cm
7	vidrio 20x20	altura: 20cm, ancho: 20cm
8	vidrio 30x30	altura: 50cm, ancho: 30cm
9	vidrio 40x40	altura: 50cm, ancho: 50cm
10	botella marron	altura: 50cm, ancho: 10cm
11	botella morada	altura: 50cm, ancho: 10cm
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY productos (producto_id, descripcion, nombre, precio) FROM stdin;
\.


--
-- Data for Name: prod_x_boleta; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY prod_x_boleta (boleta_id, producto_id, descuento, cantidad) FROM stdin;
\.


--
-- Data for Name: orden_produccion; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY orden_produccion (orden_prod_id, persona_id, boleta_id, producto_id, estado_id) FROM stdin;
\.


--
-- Data for Name: lista_materiales; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY lista_materiales (orden_prod_id, material_id, cantidad) FROM stdin;
\.


--
-- Name: main_egreso_id_seq_1; Type: SEQUENCE SET; Schema: public; Owner: alexander
--

SELECT pg_catalog.setval('main_egreso_id_seq_1', 1, false);


--
-- Data for Name: mate_x_egreso; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY mate_x_egreso (material_id, egreso_id, precio_unitario, cantidad) FROM stdin;
\.


--
-- Data for Name: material_x_almacen; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY material_x_almacen (almacen_id, material_id, cantidad) FROM stdin;
\.


--
-- Data for Name: pago_stafff; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY pago_stafff (egreso_id, persona_id, staff_id, fecha_pago) FROM stdin;
\.


--
-- Name: personas_persona_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander
--

SELECT pg_catalog.setval('personas_persona_id_seq', 1, true);


--
-- Data for Name: prod_x_materiales; Type: TABLE DATA; Schema: public; Owner: alexander
--

COPY prod_x_materiales (producto_id, material_id, cantidad) FROM stdin;
\.


--
-- Name: productos_producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander
--

SELECT pg_catalog.setval('productos_producto_id_seq', 1, false);


--
-- Name: proveedores_proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander
--

SELECT pg_catalog.setval('proveedores_proveedor_id_seq', 1, false);


--
-- Name: subsidios_subsidiario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander
--

SELECT pg_catalog.setval('subsidios_subsidiario_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

