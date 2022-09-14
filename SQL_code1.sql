---------------------------------------------------------------------------------
-- Apresentação.
---------------------------------------------------------------------------------

-- Este código é escrito em Microsoft SQL Server Management Studio.
-- Ele apresenta como criar tabelas e inserir dados nelas. Este código também demonstra como realizar simples queries e efetuar simples alterações em tabelas. 
-- Em suma, é uma introdução a algumas funções básicas de SQL.



---------------------------------------------------------------------------------
-- Criar tabela e inserir dados nela.
---------------------------------------------------------------------------------

-- Indica que vamos usar a base de dados Empresa SQL.
USE [Empresa SQL];


-- Cria tabela.
CREATE TABLE Pessoal_info_funcionarios -- Cria o nome da tabela.
                              -- Em sequência, insere o nome de cada coluna e o tipo de variável que ela é. 
(ID_funcionario INT NOT NULL, -- NOT NULL indica que não deve haver valores                          
                              -- NULL, que é importante principalmente para 
                              -- a variável que identifica IDs de registros.
Nome VARCHAR(40),             
Ultimo_sobrenome VARCHAR(40),
Idade INT,
Cidade_nasci VARCHAR(40),
Genero VARCHAR(40)
);


-- Abaixo é criada uma nova tabela.
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

-- Uma querie é uma solicitação de dados ou de informações de uma tabela ou combinação de tabelas.
-- Executar queries é uma atividade extremamente recorrente e importante na utilização da linguagem SQL. 
-- Aqui, inicialmente, serão apresentadas queries altamente simples.


-- -- -- -- -- Seleção de linhas e colunas adotando quase que exclusivamente SELECT e FROM -- -- -- -- --

-- Seleciona todas as linhas e colunas da tabela Pessoal_info_funcionarios.
SELECT *
FROM Pessoal_info_funcionarios;


-- Selecionar as primeiras 3 linhas e todas as colunas da tabela Pessoal_info_funcionarios.
SELECT TOP 3 *  
FROM Pessoal_info_funcionarios;


-- Seleciona a coluna que trata do ID dos funcionários.
SELECT ID_funcionario
FROM Pessoal_info_funcionarios;


-- Seleciona o nome e o último sobrenome dos funcionários.
SELECT Nome, Ultimo_sobrenome
FROM Pessoal_info_funcionarios;


-- -- -- -- -- Queries que adotam funções ainda não apresentadas. -- -- -- -- --

-- Contabiliza quantos dados existentes consta na coluna Nome.
-- Isso é realizado adotando a função COUNT.
-- A função AS exerce Aliasing, que é dar nome temporário a uma tabela ou coluna.
SELECT COUNT(Nome) AS quantia_nomes
FROM Pessoal_info_funcionarios;


-- Abaixo selecionamos utilizando a função DISTINCT, que identifica valores únicos.
-- Como abaixo são selecionadas apenas 6 linhas e temos 7 ao todo, 2 pessoas possuem o mesmo sobrenome. 
SELECT DISTINCT(Ultimo_sobrenome)
FROM Pessoal_info_funcionarios;


-- De modo similar a acima, obtemos o retorno, em formato de valores únicos, de Ultimo_sobrenome.
-- Todavia, distinto de acima, nesta nova abordagem é possível obter a contagem de cada elemento. Isso é efetuado com emprego da função GROUP BY.
-- Assim, identificamos que o sobrenome que caracteriza mais de uma pessoa é "Bonito".
SELECT Ultimo_sobrenome, COUNT(Ultimo_sobrenome) AS quantia_sobrenome
FROM Pessoal_info_funcionarios
GROUP BY Ultimo_sobrenome;


-- -- -- Ênfase na função WHERE -- -- --

-- Seleciona todas as informações de Empreg_info_funcionarios cujo ID não seja dado faltante. 
-- Isso é realizado adotando a função WHERE, que indica propriedades que os dados devem ter para serem acessados.
SELECT *
FROM Empreg_info_funcionarios
WHERE ID_funcionario IS NOT NULL;


-- Vislumbramos o nome de todos que possuem o último sobrenome igual a "Bonito".
SELECT Nome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome = 'Bonito';


-- Também identificamos o nome de todos que cujo último sobrenome é diferente de "Bonito".
SELECT Nome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome <> 'Bonito';


-- Seleciona todos os nomes e sobrenomes cujos últimos sejam Bonito ou Buniotto.
-- Isso é executando combinando WHERE e IN. O último indica um conjunto de elementos.
SELECT Nome, Ultimo_sobrenome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome IN ('Bonito', 'Buniotto');


-- Vemos todas as informações apenas pessoas do sexo masculino e com idade igual ou superior a 29 anos.
-- De novidade, usamos o AND que indica que a condição anterior e posterior devem ser satisfeitas e >=, que indica maior ou igual.
SELECT *
FROM Pessoal_info_funcionarios
WHERE Genero = 'MASCULINO' AND Idade >= 29;


-- -- Principalmente combina WHERE com LIKE -- --

-- A função LIKE investiga padrões nos dados.
-- Ela utiliza wildcards, que são caracteres que substituem outro caractere ou sequência de caracteres ao efetuar query.
-- Exemplificando, abaixo identificamos todos os nomes que começam (indicado por “%” após a letra) com V.
SELECT Nome
FROM Pessoal_info_funcionarios
WHERE Nome LIKE 'V%';


-- Assim como um “%” após a letra indica que ela deve ser a primeira, “%” após a letra (ou conjunto de letras) indica que ela deve estar no fim.
-- Seleciona nome e sobrenome daquele cujo sobrenome termina com "tto".
SELECT Nome, Ultimo_sobrenome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%tto';


-- Vislumbramos nome e último sobrenome de quem possui t em seu último sobrenome.
-- A letra estar entre “%” indica que ela deve ser existente na coluna indicada.
SELECT Nome, Ultimo_sobrenome
FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%t%';


-- Seleciona todas as informações daquelas pessoas cujo sobrenome detém 'ni'.
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


-- Demonstramos outra potencial combinação de condições para selecionar elementos.
-- Como novidade, usamos OR que indica que ao menos a condição anterior ou posterior (ou ambas) devem ser satisfeitas.
-- Também usamos BETWEEN, que indica que deve estar entre os números descritos.
SELECT * FROM Pessoal_info_funcionarios
WHERE Ultimo_sobrenome LIKE '%i%n%' OR ID_funcionario BETWEEN 2 AND 5;	


-- -- Demonstra como ordenar as linhas da tabela. -- --

-- Ordenamos as observações (linhas) de acordo com o salário (ordem decrescente), adotando a função ORDER BY.
SELECT * 
FROM Empreg_info_funcionarios
ORDER BY Salario;


-- ORDER BY organiza linhas em ordem ascendente de valores. Abaixo demonstramos como fazer tal ordenamento em formato descendente.
SELECT * 
FROM Empreg_info_funcionarios
ORDER BY Salario DESC;


-- -- -- -- -- Queries de medidas básicas descritivas de dados quantitativos. -- -- -- -- --

-- Vamos ver o salário máximo.
SELECT MAX(Salario) AS max_salario
FROM Empreg_info_funcionarios;


-- Agora o salário mínimo.
SELECT MIN(Salario) AS min_salario
FROM Empreg_info_funcionarios;


-- Vamos ver a média dos salários.
SELECT AVG(Salario) AS media_salario
FROM Empreg_info_funcionarios;


-- Também obtemos o desvio padrão dos salários.
SELECT STDEVP(Salario) AS desv_pad_salario
FROM Empreg_info_funcionarios;



---------------------------------------------------------------------------------
-- Deleção e outras alterações básicas em tabelas.
---------------------------------------------------------------------------------

-- Abaixo é demonstrado como deletar completamente uma tabela.
-- O comando é mantido comentado pois não é desejado de fato executar tal deleção.
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


-- Visualiza o resultado da alteração.
SELECT * FROM Pessoal_info_funcionarios;



-- Neste ponto é finalizada esta introdução a algumas funções básicas de SQL. 
-- Obrigado por ter acompanhado.
