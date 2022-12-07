#ativ -1

DELIMITER //

CREATE PROCEDURE atividade2_1 ()

begin
select c.id as id_cliente, v.data as data_compra, v.data_envio 
as data_final, c.nome as nome_cliente, v.id 
as id_compra,i.valor_unitario,i.quantidade, i.subtotal as total_compra, i.nome_produto
from cliente c join venda v join item_venda i 
on c.id = v.cliente_id and v.id=i.venda_id;

end //
DELIMITER ;

CALL atividade2_1();

#---------------------------------------------------------------------------------------------------------

#ativ - 2

Delimiter //
create function comissao_funcionario(
id_funcionario int, data_inicial date, data_final date) returns decimal(25,2) deterministic
begin
 declare comissao_atual int;
    declare comissao_total decimal(25,2);
    select c.comissao into comissao_atual from cargo as c join funcionario as f on c.id = f.cargo_id where id_funcionario = f.id;
 if comissao_atual is null then
  return 0.00;
 else 
  select sum((comissao_atual/100)  * v.valor_total) into comissao_total from venda as v where id_funcionario = v.funcionario_id and date(v.data) between data_inicial and data_final;
        return comissao_atual;
 end if;
end //

Delimiter ;

select comissao_funcionario(5, '2018-01-01', '2025-01-01');

#---------------------------------------------------------------------------------------------------------

#ativ - 3

DELIMITER //
CREATE function descricao_cliente(id_cliente int) returns varchar(25) deterministic
begin
 declare total_valor decimal(25,2);
    select sum(v.valor_total) into total_valor from venda as v where id_cliente = cliente_id and year(v.data) between 2019 and 2022;

    if total_valor > 10000 then
  return 'PREMIUM';
        
 else
  return 'REGULAR';
        
    end if;

end //

DELIMITER ;

select descricao_cliente(20);

#---------------------------------------------------------------------------------------------------------

#ativ - 4

create table Usuario_cripto(
id int not null auto_increment primary key,
login varchar(45) not null,
senha varchar(20) not null);

alter table Usuario_cripto add column ultimo_login datetime not null;

DELIMITER //
CREATE trigger cripto after insert
on usuario for each row 
begin
 insert into Usuario_cripto(login, senha) select login, MD5(senha) from usuario where login not in (select login from Usuario_cripto);
end //

DELIMITER ;

insert into Usuario_cripto(login, senha, ultimo_login) values
('login123', 'senha123', '2022-01-10 10:00:00');