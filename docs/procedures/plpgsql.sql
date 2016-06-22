create or replace function cambiarDireccion(codigoBoleta integer,opcion integer, nuevaDireccion varchar)

  RETURNS void
  language plpgsql
  AS $function$

 DECLARE 

  estadoId integer;
  estadoErr exception;
  persona integer;
  --excepcion que es activada cuando el ultimo estado de un pedido paso el limite de modificacion

  begin
  --sacando el ultimo estado de un pedido
  Select estado_id into estadoId,fecha
  from boleta_x_estado
  where codigoBoleta=boleta_id
  group by estado_id
  having fecha=MAX(fecha);
  --si el estado es mayor que 3 significa que no se puede modificar la direccion
  if estadoId>3 then raise estadoErr;
  else 
      if opcion=1 then 
				 RAISE NOTICE 'se cancelo el delivery,recoger en tienda';
         INSERT into boleta_x_estado values (codigoBoleta,0,now());
          --se registra en la boleta el estado 0 que significa que no hay delivery
         update BOLETA set delivery=false where codigoBoleta=boleta_id;
      elsif opcion=2 then
         --accept nuevaDireccion varchar prompt 'Escriba la nueva direccion';
         select cliente_id into persona 
          from boleta 
         where boleta_id=codigoBoleta;
         UPDATE personas 
         set direccion=nuevaDireccion 
        where (persona_Id=persona);
				insert
     end if;
    end if; 
   
  exception
  when estadoErr then
   RAISE NOTICE 'El producto ya fue enviado, la direccion no puede ser cambiada';
   
  end;
$function$
--
--
create or replace function registroDeDelivery(codigoBoleta integer)

  RETURNS table (descripcion varchar, fecha timestamp)
  language plpgsql
  AS $function$

--procedimiento que muestra el registro de estados de un pedido en especifico
declare
	descripcion varchar;
	fecha timestamp;
begin
-- se crea un cursor con el registro de estados de un pedido
	for codigoBoleta 
		in (select b.boleta_id,e.descrip as descripcion ,b.fecha as fechaMod
		from boleta_x_estado B,estado E
		where e.estado_id=b.estado_id and codigoBoleta=b.boleta_id
		order by estado_id ASC)
		--se muestran los estados del pedido
	loop
		return next;
		descripcion := codigoBoleta.descripcion;
		fecha := codigoBoleta.fechaMod;
	end loop;
	if NOT FOUND then
		raise exception 'El codigo que ha ingresado no existe'; 
	end if;
end;
$function$

create or replace function ventasEnProceso() 

  RETURNS void
  language plpgsql
  AS $function$


declare 
cursor c1 for
  SELECT x.boleta_id as codBoleta,c.razon_social as nombre,e.descrip as estadoActual
  FROM boleta b,clientes c,boleta_x_estado x,estado e
  WHERE e.estado_id=x.estado_id and x.boleta_id=b.boleta_id and b.cliente_id=c.cliente_id
  group by x.boleta_id
  having fecha=max(fecha);
 
registro c1%rowtype;

begin
  open c1;
  loop 
     fetch c1 into registro;
     exit when c1%notfound; 
     dbms_output.put_line(registro.codBoleta||'    '||registro.nombre||'    '||registro.estadoActual);
  end loop; 
  close c1;
end;

$function$



create or replace function estadoProceso(IdBoleta integer)

RETURNS void
  language plpgsql
  AS $function$

declare 

  cursor c1 (IdBoleta in integer) for
    SELECT aux.producto_id,d.descrip
    FROM   (Select aux.producto_id as p_id,o.estado_id as estado
            From producto_x_boleta x,orden_produccion o
            where x.boleta_id=IdBoleta and x.producto_id=o.producto_id) aux,
               descripcion d
    WHERE   d.estado_id=aux.estado_id
    GROUP BY aux.producto_id
    HAVING aux.estado_id=MAX(aux.estado_id);
  registro c1%rowtype;
begin
  open c1;
  loop 
     fetch c1 into registro;
     exit when c1%notfound; 
     dbms_output.put_line(registro.p_id||'    '||registro.estado);
  end loop; 
  close c1;
end;
$function$
