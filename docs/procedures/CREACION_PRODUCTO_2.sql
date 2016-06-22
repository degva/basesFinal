
====================================================================================================
1) INSERTAR EN LA TABLA PRODUCTOS  NOMBRE, DESCRIPCION
====================================================================================================

-- LA PREGUNTA 1 CHECK
CREATE OR REPLACE FUNCTION PR_INSERTAR_PRODUCTO (rellenar_nombre VARCHAR, rellenar_descripcion VARCHAR, rellenar_precio FLOAT)
RETURNS integer AS
$$
DECLARE
	return_id integer;
BEGIN

      INSERT INTO PRODUCTOS(NOMBRE, DESCRIPCION, PRECIO)
      VALUES (rellenar_nombre, rellenar_descripcion, rellenar_precio) RETURNING producto_id into return_id;
			
			return return_id;
END
$$
LANGUAGE plpgsql;
     

====================================================================================================
2) BUSCAR EL NOMBRE DEL MATERIAL CON LIKE EN LA TABLA MATERIALES
====================================================================================================
 
 -- LA PREGUNTA 2
CREATE OR REPLACE FUNCTION MOSTRAR_MATERIALES (rellenar_material VARCHAR)
	RETURNS TABLE (id integer, nombre varchar, descripcion varchar, precio_unitario real) AS
$$
BEGIN
	RETURN QUERY 
		SELECT m.material_id, m.nombre, m.descripcion, mxe.precio_unitario
			FROM materiales m, mate_x_egreso mxe
			WHERE
				m.material_id = mxe.material_id and
				m.nombre LIKE rellenar_material || '%';
END;
$$
LANGUAGE plpgsql;
 

====================================================================================================
3)INSERTAR DENTRO DE LA TABLA PROD_MATERIAL, DIEGO ME VA MANDA Y YO LO TENGO Q INSERTAR 
====================================================================================================

 -- LA PREGUNTA 3
CREATE OR REPLACE FUNCTION PR_INSERTAR_PROD_X_MATERIALES (prod_id INTEGER, prod_mat INTEGER, cant INTEGER)
RETURNS void AS
$$
BEGIN
  INSERT INTO PROD_X_MATERIALES(producto_id, material_id, cantidad)
    VALUES (prod_id, prod_mat, cant);
END
$$
LANGUAGE plpgsql;


====================================================================================================
4)  COMPLETAR LA COLUMNA PRECIO DE LA TABLA PRODUCTOS
====================================================================================================


CREATE OR REPLACE FUNCTION PREC_UNIT (M_ID INTEGER) -- M_ID es el MATERIAL_ID
RETURN INTEGER
IS
      CURSOR C1(code INTEGER) IS
            SELECT *
            FROM MATE_X_EGRESO
            WHERE MATERIAL_ID = code;
            
      V_C1 C1%ROWTYPE;
BEGIN
      OPEN C1(M_ID);
      LOOP
            FETCH C1 INTO V_C1;
            EXIT WHEN C1%NOTFOUND;
      END LOOP;
      RETURN V_C1.PRECIO_UNITARIO;
      CLOSE C1;
END;



CREATE OR REPLACE FUNCTION CANTIDAD (P_ID INTEGER)  -- P_ID es el PRODUCTO_ID
RETURN INTEGER
IS
      CURSOR C1(code INTEGER) IS
            SELECT *
            FROM PROD_X_MATERIALES
            WHERE PRODUCTO_ID = code;
            
      V_C1 C1%ROWTYPE;
BEGIN
      OPEN C1(P_ID);
      LOOP
            FETCH C1 INTO V_C1;
            EXIT WHEN C1%NOTFOUND;
      END LOOP;
      RETURN V_C1.CANTIDAD;
      CLOSE C1;
END;




SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER TR_INSERTAR_PRECIO
AFTER INSERT ON PROD_X_MATERIALES
FOR EACH ROW
DECLARE
      precio INTEGER;
      cant INTEGER;
      producto INTEGER;
BEGIN
      cant := CANTIDAD(:new.PRODUCTO_ID);
      precio := PREC_UNIT(:new.MATERIAL_ID);
      producto := precio * cant;
      
      INSERT INTO PRODUCTOS (PRECIO)
      VALUES (producto);
END;



-- SE CREA UN TRIGGER PARA EL ATRIBUTO PRECIO DE LA TABLA PRODUCTOS

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER TR_ACTUALIZAR_PRECIO
AFTER UPDATE ON PRODUCTOS
FOR EACH ROW
DECLARE
      precio_tot INTEGER;
BEGIN
      precio_tot := :old.PRECIO + :new.PRECIO;
      INSERT INTO PRODUCTOS (PRECIO)
      VALUES (precio_tot);
END;


