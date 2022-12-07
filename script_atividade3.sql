
# Consulta 1


explain select * from venda v,
item_venda iv, produto p, cliente c, funcionario f
where v.id = iv.venda_id 
and c.id = v.cliente_id 
and p.id = iv.produto_id 
and f.id = v.funcionario_id 
and tipo_pagamento = 'D';
 
select * from venda v, item_venda iv, produto p, cliente c, funcionario f
where v.id = iv.venda_id 
and c.id = v.cliente_id 
and p.id = iv.produto_id 
and f.id = v.funcionario_id 
and tipo_pagamento = 'D';

 # Depois da otimização:
 
create index idx_data 
on venda(data);

create index index_tpagamento 
on venda(tipo_pagamento);

select v.data, v.valor_total,iv.nome_produto, iv.quantidade, iv.valor_unitario, c.nome, c.cpf, c.telefone 
from venda v 
join item_venda iv
join cliente c 
on c.id = v.cliente_id 
and v.id = iv.venda_id 
where v.tipo_pagamento = 'D' 
order by v.data desc;


explain select v.data, v.valor_total,iv.nome_produto, iv.quantidade, iv.valor_unitario, c.nome, c.cpf, c.telefone 
from venda v 
join item_venda iv
join cliente c 
on c.id = v.cliente_id 
and v.id = iv.venda_id 
where v.tipo_pagamento = 'D' 
order by v.data desc;

create view consulta1 as select v.data, 
v.valor_total,iv.nome_produto, iv.quantidade, iv.valor_unitario, c.nome, c.cpf, c.telefone 
from venda v 
join item_venda iv
join cliente c 
on c.id = v.cliente_id 
and v.id = iv.venda_id 
where v.tipo_pagamento = 'D' 
order by v.data desc;

select * from consulta1;

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# select 2 

select * 
FROM produto p, item_venda iv, venda v
WHERE p.id = iv.produto_id 
AND v.id = iv.venda_id
AND p.fabricante like '%lar%';

explain select * 
FROM produto p, item_venda iv, venda v
WHERE p.id = iv.produto_id 
AND v.id = iv.venda_id 
AND p.fabricante like '%lar%';

# Depois das otimização

create index idx_fabricante on produto(fabricante);

select p.nome, p.descricao, p.fabricante, iv.quantidade, v.data 
from produto p 
join item_venda iv 
join venda v 
on p.id = iv.produto_id 
AND v.id = iv.venda_id 
where p.fabricante = 'Ultralar' order by v.data;

explain select p.nome, p.descricao, p.fabricante, iv.quantidade, v.data 
from produto p 
join item_venda iv 
join venda v 
on p.id = iv.produto_id 
AND v.id = iv.venda_id 
where p.fabricante = 'Ultralar' 
order by v.data;

create view consulta2 as select p.nome, p.descricao, p.fabricante, iv.quantidade, v.data 
from produto p 
join item_venda iv 
join venda v 
on p.id = iv.produto_id 
AND v.id = iv.venda_id 
where p.fabricante = 'Ultralar' 
order by v.data;

select * from consulta2;

#função
delimiter //
create procedure consulta2(nome_fab varchar(255))
begin 
select p.nome, p.descricao, p.fabricante, iv.quantidade, v.data 
from produto p 
join item_venda iv 
join venda v 
on p.id = iv.produto_id 
AND v.id = iv.venda_id 
where p.fabricante = nome_fab 
order by v.data;
end //
delimiter ;

call consulta2('Ultralar');

-- Consulta 3
-- Antes da otimização
select SUM(iv.subtotal), SUM(iv.quantidade)
from produto p, item_venda iv, venda v, cliente c
where p.id = iv.produto_id 
and v.id = iv.venda_id 
and c.id = v.cliente_id 
group by c.nome, p.nome;

explain select SUM(iv.subtotal), SUM(iv.quantidade)
FROM produto p, item_venda iv, venda v, cliente c
WHERE p.id = iv.produto_id 
and v.id = iv.venda_id 
and c.id = v.cliente_id
group by c.nome, p.nome;

-- Depois da otimização
create index index_clientenome 
on cliente(nome);

create index index_produto 
on produto(nome);

select c.nome as nome_cliente, c.cpf, c.endereco, c.telefone, p.nome as nome_produto, p.descricao as descricao_produto, 
sum(iv.quantidade), sum(iv.subtotal)
from cliente c 
join item_venda iv 
join venda v 
join produto p 
on c.id = v.cliente_id 
and v.id = iv.venda_id 
and p.id = iv.produto_id 
group by c.nome, p.nome 
order by c.nome;

explain select c.nome as nome_cliente, c.cpf, c.endereco, c.telefone, p.nome as nome_produto, p.descricao as descricao_produto, 
sum(iv.quantidade), sum(iv.subtotal)
from cliente c 
join item_venda iv 
join venda v 
join produto p 
on c.id = v.cliente_id 
and v.id = iv.venda_id 
and p.id = iv.produto_id 
group by c.nome, p.nome 
order by c.nome;

create view consulta3 as select c.nome as nome_cliente, c.cpf, c.endereco, c.telefone, p.nome as nome_produto, p.descricao as descricao_produto, 
sum(iv.quantidade), sum(iv.subtotal)
from cliente c 
join item_venda iv join venda v 
join produto p 
on c.id = v.cliente_id 
and v.id = iv.venda_id 
and p.id = iv.produto_id 
group by c.nome, p.nome 
order by c.nome;

select * from consulta3;