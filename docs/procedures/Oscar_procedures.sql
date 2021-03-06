create or replace procedure cambiarDireccion(codigoBoleta integer,opcion integer)
is
  estadoId integer;
  estadoErr exception;
  persona integer;
  nuevaDireccion varchar;
  --excepcion que es activada cuando el ultimo estado de un pedido paso el limite de modificacion
begin
  --sacando el ultimo estado de un pedido
  Select estado_id into estadoId
	  from boleta_x_estado
		where codigoBoleta=boleta_id
		group by estado_id
		having fecha=MAX(fecha);

  --si el estado es mayor que 3 significa que no se puede modificar la direccion
  if estadoId>=3 then 
    raise estadoErr;
  else 

  if opcion=1 then
    dbms_output.put_line('se cancelo el delivery,recoger en tienda');
  
	INSERT into boleta_x_estado values (codigoBoleta,0,sysdate);
  --se registra en la boleta el estado 0 que significa que no hay delivery

  update BOLETA set delivery=false where codigoBoleta=boleta_id;
  else if opcion=2 then
    accept nuevaDireccion varchar prompt 'Escriba la nueva direccion';

    select cliente_id into persona 
			from boleta 
			where boleta_id=codigoBoleta;

		UPDATE personas 
			set direccion=nuevaDireccion 
			where (persona_Id=persona);
  end if;
exception
  when estadoErr
   dbms_output.put_line('El producto ya fue enviado, la direccion no puede ser cambiada');
end;
--




--
create or replace procedure registroDeDelivery(codigoBoleta integer)
is
  --procedimiento que muestra el registro de estados de un pedido en especifico
  errorCodigo exception;
  descripcion varchar;
  fechaMod timestamp;
begin
  -- se crea un cursor con el registro de estados de un pedido
  for codigoBoleta 
  in (select b.boleta_id,e.descrip as descripcion ,b.fecha as fechaMod
     from boleta_x_estado B,estado E
     where e.estado_id=b.estado_id and codigoBoleta=b.boleta_id
     order by estado_id ASC)
   --se muestran los estados del pedido
   loop
     dbms_output.put_line(descripcion||'    '||fechaMod); 
   end loop;
   if SQL%NOTFOUND then 
      raise errorCodigo;
   end if;
exception
   when errorCodigo then 
      dbms_output.put_line('El codigo que ha ingresado no existe');
end;




create or replace procedure ventasEnProceso is
--cursor que muestra el ultimo estado de las ventas 
  cursor c1 is
    SELECT x.boleta_id as codBoleta,c.razon_social as nombre,e.descrip as estadoActual
    FROM boleta b,clientes c,boleta_x_estado x,estado e
    WHERE e.estado_id=x.estado_id and x.boleta_id=b.boleta_id and b.cliente_id=c.cliente_id
    group by x.boleta_id
    having fecha=max(fecha) and x.estado_id<3;
 
  registro c1%rowtype;
  codBoleta integer;
  nombre varchar;
  estadoActual varchar;
begin
  open c1;
  loop 
     fetch c1 into registro;
     exit when c1%notfound; 
     dbms_output.put_line(c1.codBoleta||'    '||c1.nombre||'    '||c1.estadoActual);
  end loop; 
  close c1;
end;






create or replace procedure estadoProceso(IdBoleta integer)
is
--cursor que muestra el ultimo estado de los productos en un pedido
cursor c1 is
 SELECT aux.producto_id,d.descrip
 FROM   (Select aux.producto_id,o.estado_id
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
     dbms_output.put_line(c1.producto_id||'    '||c1.descrip);
  end loop; 
  close c1;
end;
