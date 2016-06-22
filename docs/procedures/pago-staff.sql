CREATE OR REPLACE FUNCTION public.obtener_staff() 
 RETURNS TABLE (id integer, nomapell character varying)
 LANGUAGE plpsql
AS $function$
BEGIN
  RETURN QUERY
    SELECT S.persona_id, P.nombre ||' '||P.apellido
    FROM Personas P, Staff S, pago_staff PS
    WHERE (P.persona_id = S.persona_id) and
          (PS.fecha_pago IS NULL) and
          (PS.persona_id = S.persona_id);

END 
$function$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION ObtenerDetallePago(staff_idIN INTEGER)
RETURNS table (salario float,bono float,total float)
language plpgsql
AS $function$

BEGIN

	SELECT sueldo INTO salario
	FROM staff
	WHERE persona_id = staffidIN;

	SELECT sum(precio_total)*0.05 into bono
	FROM boleta 
	WHERE (staff_idIN = staff_id) AND (_bono = TRUE) TABLA;

	total := sueldo + bono;

END ;
$function$




CREATE OR REPLACE FUNCTION public.pagarStaff (id_staff_pagado INTEGER, id_staff_registra INTEGER) 
  RETURNS void
  LANGUAGE plpgsql
AS $function$
BEGIN

INSERT INTO pago_staff(persona_id, staff_id, fecha_pago)
VALUES (id_staff_pagado, id_staff_registra, SYSDATE);

END pagarStaff;
$function$


CREATE OR REPLACE FUNCTION public.Actualizar_Tabla_compras (almacenIN, materialIN, cantidadNew) 
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

UPDATE material_x_almacen
   SET cantidad = cantidadNew
 WHERE (almacen_id=almacenIN) AND (material_id = material IN);

END;
$function$
