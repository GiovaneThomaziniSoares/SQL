---------------------------------------------------------------------------------
-- Apresentação.
---------------------------------------------------------------------------------

-- Este código é escrito em MySQL.
-- Em relação ao código de introdução a algumas funções básicas de SQL (SQL_code1.sql), 
-- este traz relações entre tabelas e queries mais complexas, inclusas subqueries.
-- São apresentadas funções e exemplos práticos que compatibilizam com o uso real de SQL na área
-- de ciência e análise de dados.


---------------------------------------------------------------------------------
-- Criar tabela e inserir dados nela.
---------------------------------------------------------------------------------

-- Informa ao SQL que vamos a base de dados intitulada Empresa_SQL_2.
USE Empresa_SQL_2;


-- Cria duas tabelas muito similares às utilizadas no código de introdução a algumas funções básicas de SQL.
-- Neste código, como avanço perante o de introdução ao SQL, é efetuada declaração de PRIMARY KEY.
CREATE TABLE Funcionarios_demografico (
ID_funcionario INT NOT NULL AUTO_INCREMENT, -- AUTO_INCREMENT é equivalente do 
											 -- MySQL ao IDENTITY(1,1). 
Nome VARCHAR(40),                           
Ultimo_sobrenome VARCHAR(40),
Idade INT,
Cidade_nasci VARCHAR(40),
Genero VARCHAR(40),
PRIMARY KEY (ID_funcionario) -- Indica que esta coluna é a primary key, isto é, 
                             -- que identifica cada record (observação) por meio 
                             -- de um identificador único.
);


-- Cria a outra tabela.
-- Também como avanço perante o código de introdução ao SQL, neste código são adicionadas 
-- relações entre essas duas tabelas. Isso é efetuado por meio de FOREIGN KEY.
CREATE TABLE Salario_funcionarios
(ID_funcionario INT,
Cargo VARCHAR(40),
Salario INT,
Nossa_empresa VARCHAR(1),
ID INT NOT NULL AUTO_INCREMENT,
PRIMARY KEY (ID),
-- Abaixo indica a coluna que é foreign key, isto é, que se refere à  
-- primary key de outra tabela (no caso, Funcionarios_demografico).                                                                               -- primary key de outra tabela (no caso, Funcionarios_demografico).
FOREIGN KEY (ID_funcionario) REFERENCES Funcionarios_demografico(ID_funcionario) 
);


-- Primeiro insere dados na tabela Funcionarios_demografico.
Insert INTO Funcionarios_demografico (Nome, Ultimo_sobrenome, Idade, Cidade_nasci, Genero)
VALUES 
('Matheus', 'Buniotto', 28, 'Guaraci', 'MASCULINO'),
('Vitor', 'Soares', 29, 'Guaraci', 'MASCULINO'),
('Bruna', 'Bonito', 26, 'Cajobi', 'FEMININO'),
('Victor', 'Bonito', 25, 'Cajobi', 'MASCULINO'),
('Luis', 'Bernardes', 29, 'Ribeirao_Preto', 'MASCULINO'),
('Rafael', 'Rodrigues', 32, 'Ribeirao_Preto', 'MASCULINO'),
('Mariane', 'Verzi', 28, 'Ribeirao_Preto', 'FEMININO');


-- Em sequência, na tabela Salario_funcionarios.
INSERT INTO Salario_funcionarios (ID_funcionario,Cargo, Salario, Nossa_empresa)
VALUES
(1,'Analista BI', 3400, 'S'),
(2,'Pesquisador Pleno', 4000, 'S'),
(3,'Pesquisadora jr', 2000, 'S'),
(4,'Bombeiro', 6000, 'N'),
(5,'Pesquisador quant/Cientista de dados', 11000, 'S'),
(6,'Pesquisador senior', 10000, 'S'),
(7,'Fotografa', 3400, 'S'),
(4,'Analista de Filmes', 1000, 'N'),
(6, 'Professor voluntario', 0, 'S');



---------------------------------------------------------------------------------
-- Breves alterações em tabelas.
---------------------------------------------------------------------------------

-- Alteramos o salário e o nome do cargo do funcionário que apresenta ID = 3.
UPDATE Salario_funcionarios 
SET Salario = 3000, Cargo = "Pesquisadora plena"
WHERE ID_funcionario = 3;


-- Agora simulamos o caso no qual é desejado deletar a linha de informações do funcionário de ID 4.
DELETE FROM Salario_funcionarios
WHERE ID_funcionario = 4;


-- Como na verdade queremos as informações do funcionário de ID = 4, reinserimos elas.
INSERT INTO Salario_funcionarios (ID_funcionario,Cargo, Salario, Nossa_empresa)
VALUES
(4,'Bombeiro', 6000, 'N'),
(4,'Analista de Filmes', 1000, 'N');



---------------------------------------------------------------------------------
-- Queries.
---------------------------------------------------------------------------------

-- -- -- -- -- JOINS -- -- -- -- --

-- JOIN é uma função usada para combinar linhas de duas ou mais tabelas, 
-- com base em uma coluna relacionada entre elas.
-- Vamos aos exemplos práticos.


-- Mostra coluna das duas tabelas. As linhas mostradas são aquelas que apresentam o mesmo valor
-- de ID_funcionario nas duas tabelas.
-- Notar que Victor e Rafael, por conterem duas informações distintas na tabela
-- salario_funcionarios, aparecem duas vezes.
SELECT * 
FROM Funcionarios_demografico AS dem
JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario;


-- É demonstrado que o INNER JOIN apresenta a mesma funcionalidade do JOIN expresso acima.
SELECT * 
FROM Funcionarios_demografico AS dem
INNER JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario;


-- Também demonstramos o caso de selecionar apenas determinadas colunas de tabelas.
SELECT dem.ID_funcionario, Nome, Cargo
FROM Funcionarios_demografico AS dem
INNER JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario;


-- Continuando, os comandos LEFT JOIN e RIGHT JOIN consideram todos os elementos da tabela situada do lado 
-- esquerdo e direito, repectivamente.
-- Para contribuir na demonstração disso, adicionamos um record em uma tabela.
INSERT INTO Funcionarios_demografico VALUES (8,'Jorge', 'Silva', 28, 'Olímpia', 'MASCULINO');


-- Em sequência, executamos o LEFT JOIN.
-- Notar como é mostrada o record a mais que Funcionarios_demografico detém perante a tabela salario_funcionarios.
SELECT * 
FROM Funcionarios_demografico AS dem
LEFT JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario;


-- Como na tabela salario_funcionarios todos records apresentam IDs compatíveis com  Funcionarios_demografico,
-- o RIGHT JOIN abaixo não apresenta nenhum record que contém informações em apenas uma das 2 tabelas.
SELECT * 
FROM Funcionarios_demografico AS dem
RIGHT JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario;


-- As tabelas são alteradas de lado no código abaixo para que vislumbremos as mesmas informações do
-- LEFT JOIN aplicado, agora utilizando o RIGHT JOIN.
SELECT * 
FROM salario_funcionarios AS sal
RIGHT JOIN Funcionarios_demografico AS dem ON sal.ID_funcionario = dem.ID_funcionario;


-- O record que adicionamos já não tem mais utilidade. Deletamos ele.
DELETE FROM Funcionarios_demografico WHERE ID_funcionario = 8;



-- -- -- -- -- Apresentação de outras funções e combinações delas com JOIN -- -- -- -- --

-- -- ORDER BY -- --
-- Queremos investigar as pessoas de acordo com seu salário. Mais especificamente, almejamos identificar 
-- o nome completo dos funcionários, ordenadas de modo que o maior salário esteja acima e o menor em baixo.
SELECT Nome, Ultimo_sobrenome, Salario 
FROM funcionarios_demografico AS dem
JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario 
ORDER BY Salario DESC;


-- -- CASE, GROUP BY e JOIN -- --
-- Antes de fazer um próximo JOIN, é útil apresentarmos a função CASE. Ele funciona como IF THEM.
-- Abaixo é demonstrado um simples exemplo. Nele, identificamos a região do estado em que cada funcinário nasceu.
SELECT (CASE 
WHEN Cidade_nasci = 'Guaraci' OR Cidade_nasci = 'Cajobi' THEN 'Noroeste'
WHEN Cidade_nasci = 'Ribeirao_Preto' THEN 'Norte'
END) AS Regiao_estado, Cidade_nasci, Nome, Ultimo_sobrenome
FROM funcionarios_demografico;


-- Também previamente a efetuarmos o próximo JOIN, é útil relembrar o GROUP BY por meio de dois exemplos simples.
-- Inicialmente, vislumbramos quantos dos empregos contidos em ID_funcionario são de nossa empresa.
SELECT Nossa_empresa, COUNT(ID_funcionario) FROM salario_funcionarios
GROUP BY Nossa_empresa;


-- Como temos 7 funcionários ao todo, concluimos acima que dois de nossos funcionários possuem outro emprego.
-- Vemos quais são os IDs das pessoas da nossa empresa que detém mais de um emprego.
-- Contatamos abaixo que são os de ID 4 e 6.
SELECT ID_funcionario, COUNT(ID_funcionario) AS quantia_empregos FROM salario_funcionarios
GROUP BY ID_funcionario;


-- Detendo conhecimento de GROUP BY, CASE e JOIN, almejamos vislumbrar a média de salário das profissões que 
-- podem se enquadrar como (1) Analista e (2) Cientista/pesquisador.
SELECT (CASE WHEN Cargo LIKE 'Pesq%' THEN 'Pesquisador/Cientista'
               WHEN Cargo LIKE 'Analist%' THEN 'Analista'
               END) AS Cargo, AVG(Salario)
FROM funcionarios_demografico AS dem
JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario
WHERE Cargo LIKE 'Pesq%' OR Cargo LIKE 'Analist%'
GROUP BY (CASE WHEN Cargo LIKE 'Pesq%' THEN 'Pesquisador/Cientista'
               WHEN Cargo LIKE 'Analist%' THEN 'Analista'
               END);


-- Aproveitando o conhecimento de CASE WHEN, simulamos cenário no qual os funcionários receberiam aumento
-- de acordo com o cargo que apresentam.
-- Pesquisadores recebem 10% de aumento. Analistas recebem 7.5%.
SELECT (CASE WHEN Cargo LIKE 'Pesq%' THEN Salario + (Salario *0.1)
               WHEN Cargo LIKE 'Analist%' THEN Salario + (Salario *0.075)
               ELSE Salario + (Salario *0.05)
               END) AS Salario_pos_aumento, Salario AS Salario_atual, Cargo, Nome, Ultimo_sobrenome
FROM funcionarios_demografico AS dem
JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario;


-- Lembra que poucas queries acima identificamos o ID de funcionários que apresentam mais de um emprego?
-- Agora queremos, para além do ID, o nome completo de todos os funcionários, 
-- expressando a quantia de empregos que possuem.
SELECT dem.Nome, dem.Ultimo_sobrenome, dem.ID_funcionario, 
COUNT(sal.ID_funcionario) AS quantia_empregos                                                              
FROM Funcionarios_demografico AS dem 
JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario
GROUP BY dem.ID_funcionario; 


-- -- -- PARTITION BY, GROUP BY e JOIN -- -- --

-- O mesmo resultado do acima pode ser obtido com emprego de PARTITION BY.
-- Esta função divide as linhas ou o conjunto de resultados da consulta em pequenas partições.
-- Ela é bastante similar a GROUP BY.
-- Um GROUP BY normalmente reduz o número de linhas retornadas acumulando-as e usualmente calculando médias ou 
-- somas para cada linha. PARTITION BY não afeta o número de linhas retornadas, mas altera como o
-- resultado de uma função de janela é calculado.

-- Para facilitar a compreensão de PARTITION BY, oferecemos um simples exemplo em que é comparado com GROUP BY.
-- Visualizamos quantos funcionários nasceram em cada cidade, isso utilizando GROUP BY.
SELECT Cidade_nasci, COUNT(Cidade_nasci) AS qnt_func_nasc_por_cidad FROM Funcionarios_demografico
GROUP BY Cidade_nasci;


-- Novamente visualizamos quantos funcionários nasceram em cada cidade. Agora utilizamos o PARTITION BY.
-- Notar que ele exprime as linhas duplicadas idênticas, diferente de GROUP BY.
SELECT Cidade_nasci, COUNT(Cidade_nasci) OVER(PARTITION BY Cidade_nasci) AS qnt_func_nasc_por_cidad 
FROM Funcionarios_demografico;


-- Por isso, pode ser adotado o SELECT DISTINCT para que não sejam expressas linhas duplicadas idênticas.
-- Assim, adotando PARTITION BY, é obtido mesmo resultado de GROUP BY.
SELECT DISTINCT Cidade_nasci, COUNT(Cidade_nasci) OVER(PARTITION BY Cidade_nasci) AS qnt_func_nasc_por_cidad 
FROM Funcionarios_demografico;


-- Por fim, demonstramos que o mesmo resultado da última query antes desta seção em que nos encontramos
-- (que trata de PARTITION BY e GROUP BY) pode ser obtido com emprego de PARTITION BY.
SELECT DISTINCT dem.Nome, dem.Ultimo_sobrenome, 
COUNT(sal.ID_funcionario) OVER (PARTITION BY sal.ID_funcionario) AS quantia_empregos
FROM Salario_funcionarios AS sal
JOIN Funcionarios_demografico AS dem ON sal.ID_funcionario = dem.ID_funcionario;



---------------------------------------------------------------------------------
-- Subqueries.
---------------------------------------------------------------------------------

-- Uma subquery é uma query aninhada em outra query ou subquery.
-- Assim, naturalmente, é uma query mais complexa.

-- Common Table Expressions (CTEs) permitem efetuar queries mais complexas e depois resgatar os resultados
-- de modo mais simples e compreensível. Assim, CTEs são úteis para tratar de subqueries.

-- A seguir, demonstramos uma subquerie que utilize CTE.
-- Essa subquery obtém a média de salário das profissões que 
-- podem se enquadrar como (1) Analista e (2) Cientista/pesquisador.
WITH CTE_funcionars AS
(SELECT (CASE WHEN Cargo LIKE 'Pesq%' THEN 'Pesquisador/Cientista'
               WHEN Cargo LIKE 'Analist%' THEN 'Analista'
               END) AS Cargo, AVG(Salario) AS Sal_medio_por_carg
FROM funcionarios_demografico AS dem
JOIN salario_funcionarios AS sal ON dem.ID_funcionario = sal.ID_funcionario
WHERE Cargo LIKE 'Pesq%' OR Cargo LIKE 'Analist%'
GROUP BY (CASE WHEN Cargo LIKE 'Pesq%' THEN 'Pesquisador/Cientista'
               WHEN Cargo LIKE 'Analist%' THEN 'Analista'
               END)
)
SELECT Cargo, Sal_medio_por_carg -- Aqui a query, que acima era um pouco complexa, torna-se bastante simples.
FROM CTE_funcionars;


-- Para desenvolver uma subquery um pouco mais complexa, vamos criar uma nova tabela.
-- Ela expressa a renda obtida por cada funcionário de acordo com vendas efetuadas para cada cliente.
CREATE TABLE client_func_renda
(ID_funcionario INT,
id_cliente INT ,
renda INT,
ID INT NOT NULL AUTO_INCREMENT,
PRIMARY KEY (ID),                                                                               
FOREIGN KEY (ID_funcionario) REFERENCES Funcionarios_demografico(ID_funcionario) 
);


-- Insere valores nesta nova tabela.
INSERT INTO client_func_renda (ID_funcionario, id_cliente, renda)
VALUES
(1,11, 1000),
(1,12, 1000),
(1,13, 1000),
(2,11, 2000),
(2,12, 2000),
(2,13, 2000),
(3,13, 1700),
(3,14, 900),
(4,14, 1500),
(5,15, 1900),
(6,16, 1900);


-- Visualiza a tabela criada.
SELECT * FROM client_func_renda;


-- Visamos identificar funcionarios que são excessivamente dependentes de apenas um cliente.
-- Para isso, vamos identificar o nome completo de funcionarios cuja receita obtida de 
-- venda para um mesmo cliente representa mais de 50% de seu salario total.
WITH CTE_cli_func_sal AS -- Cria CTE e cria porcent_sal_tot.
	(SELECT cli_func.id_cliente, cli_func.ID_funcionario, cli_func.renda / sal.Salario AS porcent_sal_tot
	FROM client_func_renda AS cli_func
	JOIN salario_funcionarios AS sal ON cli_func.ID_funcionario = sal.ID_funcionario 
	GROUP BY sal.ID_funcionario
	ORDER BY cli_func.ID_funcionario
)
		SELECT dem.Nome, dem.Ultimo_sobrenome -- Seleciona nome e ultimo sobrenome.
		FROM funcionarios_demografico AS dem
		WHERE dem.ID_funcionario IN ( -- nome e ultimo sobrenome são demonstrados de quem apresenta 
			SELECT ID_funcionario     -- porcent_sal_tot > 0.5 para um mesmo cliente.
			FROM CTE_cli_func_sal
			WHERE porcent_sal_tot > 0.5
);


-- Neste ponto é finalizado este código de SQL. 
-- Nele foram criadas tabelas, inserido dados nelas. Elas também foram alteradas.
-- Este código focalizou em queries, especialmente as que envolvem relações entre tabelas.
-- A complexidade das queries, vie de regra, cresceu conforme foi avançado o código.
-- Por fim, foram apresentadas subqueries.
-- Obrigado por ter acompanhado.
