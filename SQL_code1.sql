---------------------------------------------------------------------------------
-- Apresenta��o.
---------------------------------------------------------------------------------

-- Este c�digo � escrito em Microsoft SQL Server Management Studio.
-- Ele apresenta como criar tabelas e inserir dados nelas. Este c�digo tamb�m demonstra como realizar simples queries e efetuar simples altera��es em tabelas. 
-- Em suma, � uma introdu��o a algumas fun��es b�sicas de SQL.



---------------------------------------------------------------------------------
-- Criar tabela e inserir dados nela.
---------------------------------------------------------------------------------

-- Indica que vamos usar a base de dados Empresa SQL.
USE [Empresa SQL];


-- Cria tabela.
CREATE TABLE Pessoal_info_funcionarios -- Cria o nome da tabela.
                              -- Em sequ�ncia, insere o nome de cada coluna e o tipo de vari�vel que ela �. 
(ID_funcionario INT NOT NULL, -- NOT NULL indica que n�o deve haver valores                          
                              -- NULL, que � importante principalmente para 
                              -- a vari�vel que identifica IDs de registros.
Nome VARCHAR(40),             
Ultimo_sobrenome VARCHAR(40),
Idade INT,
Cidade_nasci VARCHAR(40),
Genero VARCHAR(40)
);


-- Abaixo � criada uma nova tabela.
CREATE TABLE Empreg_info_funcionarios
(ID_funcionario INT IDENTITY(1,1), -- IDENTITY(1,1) faz com que IDs sejam
                                   --   sejam iniciados em 1 e caminhem 
                                   --   de um em um.

Cargo VARCHAR(40),
Salario INT);


-- Agora vamos inserir dados nas tabelas criadas.
Insert INTO Pessoal_info_funcionarios VALUES
(1, 'Mateus', 'Buniotto', 28, 'Guaraci', 'MASCULINO'),
(2, 'Vitor', 'Soares', 29, 'Guaraci', 'MASCULINO'),
(3, 'Bruna', 'Bonito', 26, 'Cajobi', 'FEMININO'),
(4, 'Victor', 'Bonito', 25, 'Cajobi', 'MASCULINO'),
(5, 'Luis', 'Bernardes', 29, 'Ribeirao Preto', 'MASCULINO'),
(6, 'Rafael', 'Rodrigues', 32, 'Ribeirao Preto', 'MASCULINO'),
(7, 'Mariane', 'Verzi', 28, 'Ribeirao Preo', 'FEMININO');


-- Insere dados na outra tabela.
INSERT INTO Empreg_info_funcionarios VALUES
('Analista BI', 3400),
('Pesquisador Pleno', 4000),
('Pesquisadora jr', 2000),
('Bombeiro', 6000),
('Cientista de dados', 11000),
('Pesquisador senior', 10000),
('Fotografa', 3400);



---------------------------------------------------------------------------------
-- Queries.
---------------------------------------------------------------------------------

-- Uma querie � uma solicita��o de dados ou de informa��es de uma tabela ou combina��o de tabelas.
-- Executar queries � uma atividade extremamente recorrente e importante na utiliza��o da linguagem SQL. 
-- Aqui, inicialmente, ser�o apresentadas queries altamente simples.


-- -- -- -- -- Sele��o de linhas e colunas adotando quase que exclusivamente SELECT e FROM -- -- -- -- --

-- Seleciona todas as linhas e colunas da tabela Pessoal_info_funcionarios.
SELECT *
FROM Pessoal_info_funcionarios;


-- Selecionar as primeiras 3 linhas e todas as colunas da tabela Pessoal_info_funcionarios.
SELECT TOP 3 *  
FROM Pessoal_info_funcionarios;


-- Seleciona a coluna que trata do ID dos funcion�rios.
SELECT ID_funcionario
FROM Pessoal_info_funcionarios;


-- Seleciona o nome e o �ltimo sobrenome dos funcion�rios.
SELECT Nome, Ultimo_sobrenome
FROM Pessoal_info_funcionarios;


-- -- -- -- -- Queries que adotam fun��es ainda n�o apresentadas. -- -- -- -- --

-- Contabiliza quantos dados existentes consta na coluna Nome.
-- Isso � realizado adotando a fun��o COUNT.
-- A fun��o AS exerce Aliasing, que � dar nome tempor�rio a uma tabela ou coluna.
SELECT COUNT(Nome) AS quantia_nomes
FROM Pessoal_info_funcionarios;


-- Abaixo selecionamos utilizando a fun��o DISTINCT, que identifica valores �nicos.
-- Como abaixo s�o selecionadas apenas 6 linhas e temos 7 ao todo, 2 pessoas possuem o mesmo sobrenome. 
SELECT DISTINCT(Ultimo_sobrenome)
FROM Pessoal_info_funcionarios;


-- De modo similar a acima, obtemos o retorno, em formato de valores �nicos, de Ultimo_sobrenome.
-- Todavia, distinto de acima, nesta nova abordagem � poss�vel obter a contagem de cada elemento. Isso � efetuado com emprego da fun��o GROUP BY.
-- Assim, identificamos que o sobrenome que caracteriza mais de uma pessoa � "Bonito".
SELECT Ultimo_sobrenome, COUNT(Ultimo_sobrenome) AS quantia_sobrenome
FROM Pessoal_info_funcionarios
GROUP BY Ultimo_sobrenome;


-- -- -- �nfase na fun��o WHERE -- -- --

-- Seleciona todas as informa��es de Empreg_info_funcionarios cujo ID n�o seja dado faltante. 
-- Isso � realizado adotando a fun��o WHERE, que indica propriedades que os dados devem ter para serem acessados.
SELECT *
FROM Empreg_info_funcionarios
WHERE ID_funcionario IS NOT NULL;


-- Vislumbramos o nome de todos que possuem o �ltimo sobrenome igual a "Bonito".
SELECT Nome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome = 'Bonito';


-- Tamb�m identificamos o nome de todos que cujo �ltimo sobrenome � diferente de "Bonito".
SELECT Nome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome <> 'Bonito';


-- Seleciona todos os nomes e sobrenomes cujos �ltimos sejam Bonito ou Buniotto.
-- Isso � executando combinando WHERE e IN. O �ltimo indica um conjunto de elementos.
SELECT Nome, Ultimo_sobrenome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome IN ('Bonito', 'Buniotto');


-- Vemos todas as informa��es apenas pessoas do sexo masculino e com idade igual ou superior a 29 anos.
-- De novidade, usamos o AND que indica que a condi��o anterior e posterior devem ser satisfeitas e >=, que indica maior ou igual.
SELECT *
FROM Pessoal_info_funcionarios
WHERE Genero = 'MASCULINO' AND Idade >= 29;


-- -- Principalmente combina WHERE com LIKE -- --

-- A fun��o LIKE investiga padr�es nos dados.
-- Ela utiliza wildcards, que s�o caracteres que substituem outro caractere ou sequ�ncia de caracteres ao efetuar query.
-- Exemplificando, abaixo identificamos todos os nomes que come�am (indicado por �%� ap�s a letra) com V.
SELECT Nome
FROM Pessoal_info_funcionarios
WHERE Nome LIKE 'V%';


-- Assim como um �%� ap�s a letra indica que ela deve ser a primeira, �%� ap�s a letra (ou conjunto de letras) indica que ela deve estar no fim.
-- Seleciona nome e sobrenome daquele cujo sobrenome termina com "tto".
SELECT Nome, Ultimo_sobrenome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%tto';


-- Vislumbramos nome e �ltimo sobrenome de quem possui t em seu �ltimo sobrenome.
-- A letra estar entre �%� indica que ela deve ser existente na coluna indicada.
SELECT Nome, Ultimo_sobrenome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%t%';


-- Seleciona todas as informa��es daquelas pessoas cujo sobrenome det�m 'ni'.
SELECT *
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%ni%';


-- Os dois exemplos abaixo demonstram como a ordem dos wildcards importam.
SELECT *
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%n%i%';


SELECT *
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%i%n%';


-- Demonstramos outra potencial combina��o de condi��es para selecionar elementos.
-- Como novidade, usamos OR que indica que ao menos a condi��o anterior ou posterior (ou ambas) devem ser satisfeitas.
-- Tamb�m usamos BETWEEN, que indica que deve estar entre os n�meros descritos.
SELECT * FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%i%n%' OR ID_funcionario BETWEEN 2 AND 5;	


-- -- Demonstra como ordenar as linhas da tabela. -- --

-- Ordenamos as observa��es (linhas) de acordo com o sal�rio (ordem decrescente), adotando a fun��o ORDER BY.
SELECT * 
FROM Empreg_info_funcionarios
ORDER BY Salario;


-- ORDER BY organiza linhas em ordem ascendente de valores. Abaixo demonstramos como fazer tal ordenamento em formato descendente.
SELECT * 
FROM Empreg_info_funcionarios
ORDER BY Salario DESC;


-- -- -- -- -- Queries de medidas b�sicas descritivas de dados quantitativos. -- -- -- -- --

-- Vamos ver o sal�rio m�ximo.
SELECT MAX(Salario) AS max_salario
FROM Empreg_info_funcionarios;


-- Agora o sal�rio m�nimo.
SELECT MIN(Salario) AS min_salario
FROM Empreg_info_funcionarios;


-- Vamos ver a m�dia dos sal�rios.
SELECT AVG(Salario) AS media_salario
FROM Empreg_info_funcionarios;


-- Tamb�m obtemos o desvio padr�o dos sal�rios.
SELECT STDEVP(Salario) AS desv_pad_salario
FROM Empreg_info_funcionarios;



---------------------------------------------------------------------------------
-- Dele��o e outras altera��es b�sicas em tabelas.
---------------------------------------------------------------------------------

-- Abaixo � demonstrado como deletar completamente uma tabela.
-- O comando � mantido comentado pois n�o � desejado de fato executar tal dele��o.
-- DROP TABLE Pessoal_info_funcionarios;


-- A seguir, adiciona uma nova coluna na tabela Pessoal_info_funcionarios.
ALTER TABLE Pessoal_info_funcionarios
ADD Altura INT;


-- Deleta uma coluna na tabela Pessoal_info_funcionarios.
ALTER TABLE Pessoal_info_funcionarios
DROP COLUMN Altura;


-- Altera valor contido na tabela.
UPDATE Pessoal_info_funcionarios
SET Nome = 'Matheus'
WHERE ID_funcionario = 1;


-- Visualiza o resultado da altera��o.
SELECT * FROM Pessoal_info_funcionarios;



-- Neste ponto � finalizada esta introdu��o a algumas fun��es b�sicas de SQL. 
-- Obrigado por ter acompanhado.
