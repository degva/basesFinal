CREATE OR REPLACE PROCEDURE RegistrarProductosComprados(staff_idIN IN INTEGER, persona_idIN IN INTEGER, totalIN IN INTEGER) IS
BEGIN
	INSERT INTO compra_productos (persona_id, proveedor_id, total, fecha) 
		VALUES (staff_idIN, persona_idIN, totalIN, SYSDATE);
END RegistrarProductosComprados

CREATE OR REPLACE PROCEDURE RegigstrarMateriales(material_idIN IN INTEGER, egreso_idIN IN INTEGER, precio_unitarioIN IN FLOAT, cantidadIN IN INTEGER) IS
BEGIN
INSERT INTO mate_x_egreso (material_id, egreso_id, precio_unitario, cantidad) 
VALUES (material_idIN, egreso_idIN, precio_unitarioIN, cantidadIN);
END RegistrarMateriales;

-- para crear un proveedor
CREATE OR REPLACE FUNCTION agregar_proveedor(
	i_razon_social VARCHAR, 
	i_descripcion VARCHAR, 
	i_ruc integer, 
	i_telefono integer, 
	i_celular integer, 
	i_correo VARCHAR, 
	i_direccion VARCHAR) RETURNS void AS
$BODY$
BEGIN
	INSERT INTO Proveedores (razon_social, descripcion, ruc, telefono, celular, correo, direccion)
		VALUES (i_razon_social, i_descripcion, i_ruc, i_telefono, i_celular, i_correo, i_direccion);
END 
$BODY$
LANGUAGE plpgsql;


-- para buscar un proveedor
CREATE OR REPLACE FUNCTION buscar_proveedor(
		proveedor_id_bus INTEGER, 
		razon_social_bus VARCHAR, 
		descripcion_bus VARCHAR)
	RETURNS TABLE (razon_social varchar, descripcion varchar, ruc numeric, telefono numeric, celular numeric, correo varchar, direccion varchar) AS

$BODY$
BEGIN
	RETURN QUERY SELECT p.razon_social, p.descripcion, p.ruc, p.telefono, p.celular, p.correo, p.direccion
		FROM Proveedores p
		WHERE 
			p.proveedor_id = proveedor_id_bus OR 
			p.razon_social LIKE razon_social_bus || '%' OR 
			p.descripcion LIKE descripcion_bus || '%';
	
	EXCEPTION
		WHEN TOO_MANY_ROWS THEN 
			RAISE NOTICE 'Hay más de una coincidencia';
		WHEN NO_DATA_FOUND THEN
			RAISE NOTICE 'Proveedor no encontrado'; 
END
$BODY$
LANGUAGE plpgsql;


-- para obtener los materiales faltantes
CREATE OR REPLACE FUNCTION revisar_inventario () 
	RETURNS TABLE(id integer, nombre varchar, can_act integer, can_nece bigint) AS
$BODY$
	SELECT M.material_id, M.nombre, MXA.cantidad, 5
	FROM Materiales M, Material_x_Almacen MXA, Almacen A
	WHERE (A.almacen_id = MXA.almacen_id) 
	AND (M.material_id = MXA.material_id) 
	AND (MXA.cantidad < 5)

	UNION
	SELECT M.material_id, M.nombre, MXA.cantidad, sum(LM.cantidad)
	FROM Materiales M, Material_x_Almacen MXA, Almacen A, Lista_Materiales LM
	WHERE (A.almacen_id=MXA.almacen_id) 
	AND (M.material_id=MXA.material_id) 
	AND (M.material_id=LM.material_id) 
	GROUP BY M.material_id, MXA.cantidad
	HAVING sum(LM.cantidad) < (SELECT SUM(cantidad) SUMA
					FROM Material_x_Almacen
					WHERE material_id = M.material_id);
$BODY$
LANGUAGE sql;
