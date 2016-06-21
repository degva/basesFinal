
CREATE TABLE public.estado (
                estado_id INTEGER NOT NULL,
                descrip VARCHAR NOT NULL,
                CONSTRAINT estado_pk PRIMARY KEY (estado_id)
);


CREATE SEQUENCE public.estado_de_orden_estado_id_seq;

CREATE TABLE public.estado_de_orden (
                estado_id INTEGER NOT NULL DEFAULT nextval('public.estado_de_orden_estado_id_seq'),
                descrip VARCHAR NOT NULL,
                CONSTRAINT estado_de_orden_pk PRIMARY KEY (estado_id)
);


ALTER SEQUENCE public.estado_de_orden_estado_id_seq OWNED BY public.estado_de_orden.estado_id;

CREATE TABLE public.almacen (
                almacen_id INTEGER NOT NULL,
                nombre VARCHAR NOT NULL,
                ubicacion VARCHAR NOT NULL,
                CONSTRAINT almacen_pk PRIMARY KEY (almacen_id)
);


CREATE TABLE public.Materiales (
                material_id INTEGER NOT NULL,
                nombre VARCHAR NOT NULL,
                descripcion VARCHAR NOT NULL,
                CONSTRAINT materiales_pk PRIMARY KEY (material_id)
);


CREATE TABLE public.material_x_almacen (
                almacen_id INTEGER NOT NULL,
                material_id INTEGER NOT NULL,
                cantidad INTEGER NOT NULL,
                CONSTRAINT material_x_almacen_pk PRIMARY KEY (almacen_id, material_id)
);


CREATE SEQUENCE public.persona_id_seq_1;

CREATE TABLE public.Staff (
                persona_id INTEGER NOT NULL DEFAULT nextval('public.persona_id_seq_1'),
                sueldo NUMERIC(4) NOT NULL,
                fecha_ingreso TIMESTAMP NOT NULL,
                CONSTRAINT staff_pk PRIMARY KEY (persona_id)
);


ALTER SEQUENCE public.persona_id_seq_1 OWNED BY public.Staff.persona_id;

CREATE SEQUENCE public.main_egreso_id_seq_1;

CREATE TABLE public.pago_stafff (
                egreso_id INTEGER NOT NULL DEFAULT nextval('public.main_egreso_id_seq_1'),
                persona_id INTEGER NOT NULL,
                staff_id INTEGER NOT NULL,
                fecha_pago TIMESTAMP,
                CONSTRAINT pago_stafff_pk PRIMARY KEY (egreso_id)
);


ALTER SEQUENCE public.main_egreso_id_seq_1 OWNED BY public.pago_stafff.egreso_id;

CREATE SEQUENCE public.persona_id_seq;

CREATE TABLE public.Clientes (
                persona_id INTEGER NOT NULL DEFAULT nextval('public.persona_id_seq'),
                RUC VARCHAR NOT NULL,
                razon_social VARCHAR NOT NULL,
                CONSTRAINT clientes_pk PRIMARY KEY (persona_id)
);


ALTER SEQUENCE public.persona_id_seq OWNED BY public.Clientes.persona_id;

CREATE SEQUENCE public.subsidios_subsidiario_id_seq;

CREATE TABLE public.Subsidios (
                subsidio_id INTEGER NOT NULL DEFAULT nextval('public.subsidios_subsidiario_id_seq'),
                direccion_local VARCHAR NOT NULL,
                latitud NUMERIC(4) NOT NULL,
                longitud NUMERIC(4) NOT NULL,
                cliente_id INTEGER NOT NULL,
                CONSTRAINT subsidios_pk PRIMARY KEY (subsidio_id)
);


ALTER SEQUENCE public.subsidios_subsidiario_id_seq OWNED BY public.Subsidios.subsidio_id;

CREATE SEQUENCE public.ingresos_venta_id_seq;

CREATE TABLE public.boleta (
                boleta_id INTEGER NOT NULL DEFAULT nextval('public.ingresos_venta_id_seq'),
                subsidio_id INTEGER,
                precio_total NUMERIC(4) NOT NULL,
                cliente_id INTEGER NOT NULL,
                factura BOOLEAN DEFAULT FALSE NOT NULL,
                fecha TIMESTAMP NOT NULL,
                staff_id INTEGER NOT NULL,
                fecha_modificacion TIMESTAMP,
                _bono BOOLEAN DEFAULT FALSE NOT NULL,
                delivery BOOLEAN DEFAULT FALSE NOT NULL,
                CONSTRAINT boleta_pk PRIMARY KEY (boleta_id)
);


ALTER SEQUENCE public.ingresos_venta_id_seq OWNED BY public.boleta.boleta_id;

CREATE TABLE public.boleta_x_estado (
                boleta_id INTEGER NOT NULL,
                estado_id INTEGER NOT NULL,
                fecha TIMESTAMP NOT NULL,
                CONSTRAINT boleta_x_estado_pk PRIMARY KEY (boleta_id, estado_id, fecha)
);


CREATE TABLE public.Personas (
                persona_id INTEGER NOT NULL,
                nombre VARCHAR NOT NULL,
                apellido VARCHAR NOT NULL,
                telefono VARCHAR NOT NULL,
                direccion VARCHAR NOT NULL,
                CONSTRAINT personas_pk PRIMARY KEY (persona_id)
);


CREATE SEQUENCE public.productos_producto_id_seq;

CREATE TABLE public.Productos (
                producto_id INTEGER NOT NULL DEFAULT nextval('public.productos_producto_id_seq'),
                descripcion VARCHAR NOT NULL,
                nombre VARCHAR NOT NULL,
                precio NUMERIC(4) NOT NULL,
                CONSTRAINT productos_pk PRIMARY KEY (producto_id)
);


ALTER SEQUENCE public.productos_producto_id_seq OWNED BY public.Productos.producto_id;

CREATE TABLE public.prod_x_materiales (
                producto_id INTEGER NOT NULL,
                material_id INTEGER NOT NULL,
                cantidad INTEGER NOT NULL,
                CONSTRAINT prod_x_materiales_pk PRIMARY KEY (producto_id, material_id)
);


CREATE TABLE public.prod_x_boleta (
                boleta_id INTEGER NOT NULL,
                producto_id INTEGER NOT NULL,
                descuento REAL NOT NULL,
                cantidad INTEGER NOT NULL,
                CONSTRAINT prod_x_boleta_pk PRIMARY KEY (boleta_id, producto_id)
);


CREATE TABLE public.orden_produccion (
                orden_prod_id INTEGER NOT NULL,
                persona_id INTEGER NOT NULL,
                boleta_id INTEGER NOT NULL,
                producto_id INTEGER NOT NULL,
                estado_id INTEGER NOT NULL,
                CONSTRAINT orden_produccion_pk PRIMARY KEY (orden_prod_id)
);


CREATE TABLE public.lista_materiales (
                orden_prod_id INTEGER NOT NULL,
                material_id INTEGER NOT NULL,
                cantidad INTEGER NOT NULL,
                CONSTRAINT lista_materiales_pk PRIMARY KEY (orden_prod_id, material_id)
);


CREATE SEQUENCE public.proveedores_proveedor_id_seq;

CREATE TABLE public.Proveedores (
                proveedor_id INTEGER NOT NULL DEFAULT nextval('public.proveedores_proveedor_id_seq'),
                razon_social VARCHAR NOT NULL,
                descripcion VARCHAR NOT NULL,
                ruc VARCHAR NOT NULL,
                telefono NUMERIC NOT NULL,
                celular NUMERIC NOT NULL,
                correo VARCHAR NOT NULL,
                direccion VARCHAR NOT NULL,
                CONSTRAINT proveedores_pk PRIMARY KEY (proveedor_id)
);


ALTER SEQUENCE public.proveedores_proveedor_id_seq OWNED BY public.Proveedores.proveedor_id;

CREATE TABLE public.compra_productos (
                egreso_id INTEGER NOT NULL,
                persona_id INTEGER NOT NULL,
                proveedor_id INTEGER NOT NULL,
                descripcion VARCHAR NOT NULL,
                total REAL NOT NULL,
                fecha TIMESTAMP,
                CONSTRAINT compra_productos_pk PRIMARY KEY (egreso_id)
);


CREATE TABLE public.mate_x_egreso (
                material_id INTEGER NOT NULL,
                egreso_id INTEGER NOT NULL,
                precio_unitario REAL NOT NULL,
                cantidad INTEGER NOT NULL,
                CONSTRAINT mate_x_egreso_pk PRIMARY KEY (material_id, egreso_id)
);


ALTER TABLE public.boleta_x_estado ADD CONSTRAINT estado_boleta_x_estado_fk
FOREIGN KEY (estado_id)
REFERENCES public.estado (estado_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orden_produccion ADD CONSTRAINT estado_lista_materiales_orden_produccion_fk
FOREIGN KEY (estado_id)
REFERENCES public.estado_de_orden (estado_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.material_x_almacen ADD CONSTRAINT almacen_material_x_almacen_fk
FOREIGN KEY (almacen_id)
REFERENCES public.almacen (almacen_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.prod_x_materiales ADD CONSTRAINT materiales_prod_x_insumo_fk
FOREIGN KEY (material_id)
REFERENCES public.Materiales (material_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.mate_x_egreso ADD CONSTRAINT materiales_mate_x_egreso_fk
FOREIGN KEY (material_id)
REFERENCES public.Materiales (material_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.lista_materiales ADD CONSTRAINT materiales_lista_materiales_fk
FOREIGN KEY (material_id)
REFERENCES public.Materiales (material_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.material_x_almacen ADD CONSTRAINT materiales_material_x_almacen_fk
FOREIGN KEY (material_id)
REFERENCES public.Materiales (material_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Personas ADD CONSTRAINT staff_personas_fk
FOREIGN KEY (persona_id)
REFERENCES public.Staff (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.boleta ADD CONSTRAINT staff_boleta_fk
FOREIGN KEY (staff_id)
REFERENCES public.Staff (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orden_produccion ADD CONSTRAINT staff_orden_produccion_fk
FOREIGN KEY (persona_id)
REFERENCES public.Staff (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.pago_stafff ADD CONSTRAINT staff_pago_stafff_fk
FOREIGN KEY (persona_id)
REFERENCES public.Staff (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.pago_stafff ADD CONSTRAINT staff_pago_stafff_fk1
FOREIGN KEY (staff_id)
REFERENCES public.Staff (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.compra_productos ADD CONSTRAINT staff_compra_productos_fk
FOREIGN KEY (persona_id)
REFERENCES public.Staff (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Subsidios ADD CONSTRAINT clientes_subsidios_fk
FOREIGN KEY (cliente_id)
REFERENCES public.Clientes (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.boleta ADD CONSTRAINT clientes_ingresos_fk
FOREIGN KEY (cliente_id)
REFERENCES public.Clientes (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Personas ADD CONSTRAINT clientes_personas_fk
FOREIGN KEY (persona_id)
REFERENCES public.Clientes (persona_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.boleta ADD CONSTRAINT subsidiarios_ingresos_fk
FOREIGN KEY (subsidio_id)
REFERENCES public.Subsidios (subsidio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.prod_x_boleta ADD CONSTRAINT ventas_prod_x_venta_fk
FOREIGN KEY (boleta_id)
REFERENCES public.boleta (boleta_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.boleta_x_estado ADD CONSTRAINT boleta_boleta_x_estado_fk
FOREIGN KEY (boleta_id)
REFERENCES public.boleta (boleta_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.prod_x_boleta ADD CONSTRAINT productos_prod_x_venta_fk
FOREIGN KEY (producto_id)
REFERENCES public.Productos (producto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.prod_x_materiales ADD CONSTRAINT productos_prod_x_insumo_fk
FOREIGN KEY (producto_id)
REFERENCES public.Productos (producto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orden_produccion ADD CONSTRAINT prod_x_ingreso_orden_produccion_fk
FOREIGN KEY (boleta_id, producto_id)
REFERENCES public.prod_x_boleta (boleta_id, producto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.lista_materiales ADD CONSTRAINT orden_produccion_lista_materiales_fk
FOREIGN KEY (orden_prod_id)
REFERENCES public.orden_produccion (orden_prod_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.compra_productos ADD CONSTRAINT proveedores_compra_productos_fk
FOREIGN KEY (proveedor_id)
REFERENCES public.Proveedores (proveedor_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.mate_x_egreso ADD CONSTRAINT compra_productos_mate_x_egreso_fk
FOREIGN KEY (egreso_id)
REFERENCES public.compra_productos (egreso_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
