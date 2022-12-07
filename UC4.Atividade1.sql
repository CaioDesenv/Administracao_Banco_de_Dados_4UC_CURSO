-- Crie um usuário específico para relatórios. Crie role para ele, com acesso apenas à consulta em tabelas (nem dados, nem estrutura podem ser alterados). --
create user 'funcionario1'@'localhost' identified by 'userSenha123';
create role 'so_consulta'; 
grant select on uc4atividades.* to 'so_consulta';
grant 'so_consulta' to 'funcionario1'@'localhost';
set default role 'so_consulta' to  'funcionario1'@'localhost';

-- Crie usuário e role para funcionário, o qual pode manipular as tabelas de venda, cliente e produto, mas não deve ter acesso (nem para consulta) a funcionário e cargo e não deve ser capaz de realizar alterações de estrutura em nenhuma tabela. 
create user 'funcionario2'@'localhost' identified by 'us1234';
create role 'manipula_vcp';
grant select, insert, update, delete on uc4atividades.venda to 'manipula_vcp';
grant select, insert, update, delete on uc4atividades.cliente to 'manipula_vcp';
grant select, insert, update, delete on uc4atividades.produto to 'manipula_vcp';
grant 'manipula_vcp' to 'funcionario2'@'localhost';
set default role 'manipula_vcp' to 'funcionario2'@'localhost';

-- Escolha um método de criptografia ou hash para aplicar às senhas dos usuários. Atualize a tabela “usuário” aplicando a criptografia ou hash ao campo de senha em todos os registros.
insert into usuario(login, senha) values
('funcionario1', sha2('userSenha123', 256)),
('funcionario2', sha2('us1234', 256));

select * from usuario;
