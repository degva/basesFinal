--de la tabla de subsidios:
--	si el parametro que indica si tiene RUC está en '0' (está vacío), entonces evitar la compra -> ir a una excepcion
			
--	cuando el parametro que indica si tiene RUC es distinto de '0', se hace un INSERT a la tabla subsidios ( donde pondrá el id_cliente)

create or replace function Comprar_Marca
		(id_cliente_ing integer , indica_RUC INTEGER, latitud_ing float , longitud_ing float , dir_local_ing VARCHAR) 

RETURNS void AS

$$
BEGIN
		
		IF indica_RUC = 0 then
			RAISE exception using
				errcode = 'no_hay_RUC';
		
		ELSE
			INSERT INTO
				SUBSIDIOS (LATITUD, LONGITUD, CLIENTE_ID, DIRECCION_LOCAL)
				VALUES (latitud_ing, longitud_ing, id_cliente_ing, dir_local_ing);
		end if;
EXCEPTION
		WHEN OTHERS THEN
			raise notice 'se desconoce el error';
				ROLLBACK;

END
$$
LANGUAGE plpgsql;


-- preguntas:
-- esta tabla subsidios permite a un cliente con RUC tener varios subsidios?
-- habrán dos registros con el mismo cliente pero con distintos puntos de LONGITUD y LATITUD entonces? 
