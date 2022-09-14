---------------------------------------------------------------------------------
-- Apresenta��o.
---------------------------------------------------------------------------------

-- Este c�digo � escrito em Microsoft SQL Server Management Studio.
-- Ele � composto principalmente por limpeza de dados.



---------------------------------------------------------------------------------
-- Importa��o de dados e descri��es de informa��es basilares.
---------------------------------------------------------------------------------

-- Indica a base de dados a ser utilizada.
USE data_cleaning;


  -- Visualiza todos os dados da tabela.
SELECT * FROM Plan1$;


-- Altera nome da tabela.
sp_rename 'Plan1$', 'func';


-- Visualiza novamente todos os dados da tabela.
SELECT * FROM func;


-- Como informa��es pr�vias, � informado que a coluna id_func � o identificador de funcion�rios. O id_func � �nico de cada funcion�rio.
-- As informa��es da tabela referem-se a funcion�rios. Assim, uma linha por funcion�rio basta para conter todas as informa��es.

-- � vis�vel a exist�ncia de muitas linhas com id_func id�ntico. � �til que a tabela n�o apresente esta propriedade para reduzir a quantia
-- de dados, tornando o processamento de dados mais r�pido.
-- Neste contexto, executamos procedimentos que visam minimizar a quantia de linhas da tabela.
-- Tais procedimentos tamb�m visam tornar a tabela mais padronizada e limpa, facilitando a manipula��o, an�lise e modelagem de dados.

-- Assim, assumimos que � desejado alterar a tabela de dados func.
-- Por boa pr�tica e tamb�m para podermos, ao fim, ver os resultados de manipula��es nesta tabela, a clonamos antes de alter�-la.
-- Tamb�m, antes de cada altera��o de tabela, demonstramos, por meio de query, sem alterar a tabela, a l�gica subjacente da altera��o mencionada, 
-- que permite alcan�ar o resultado almejado.


-- Clona a tabela.
SELECT * INTO func_clone 
FROM func;


-- Em sequ�ncia, iniciaremos o procedimento de limpeza de dados.



---------------------------------------------------------------------------------
-- Limpeza de dados.
---------------------------------------------------------------------------------

-- Como mencionado, existem linhas com id_func id�ntico. Mais especificamente, existem pares linhas com essa propriedade em que 
-- uma linha det�m informa��o de cidade_nasci ou idade e a outra (seu par) n�o. Com o c�digo abaixo, inserimos informa��o de uma linha que det�m 
-- informa��o de cidade_nasci para sua linha par que n�o possui este dado. Ainda, esta linha que recebe dado de cidade_nasci
-- deve apresentar informa��o de idade. Assim, obtemos uma linha com informa��es completas sobre essas duas colunas (cidade_nasci
-- e idade) para um id_func.

-- Primeiro demonstramos c�digo que expressa a l�gica para alcan�ar o objetivo mencionado. 
-- Notar como selecionamos cidades com NULL e idade sem NULL, seguindo o planejado .
-- Tamb�m perceber que selecionamos linhas com id_func igual (para coletar informa��o de um funcion�rio, consideramos o pr�prio
-- funcion�rio). Por fim, tal coleta � realizada em linhas diferentes, que det�m informa��e diferentes.
SELECT tab1.id_func,tab1.id_linha,tab1.idade,tab1.cidade_nasci,
ISNULL(tab1.cidade_nasci,tab2.cidade_nasci) AS cidade_nasci_infos_adicionais
FROM func tab1
JOIN func tab2
	ON tab1.id_func = tab2.id_func
	AND tab1.id_linha <> tab2.id_linha
WHERE tab1.cidade_nasci IS NULL AND tab1.idade IS NOT NULL;


-- Alteramos a tabela de acordo com o resultado almejado.
UPDATE tab1
SET cidade_nasci = ISNULL(tab1.cidade_nasci,tab2.cidade_nasci)
FROM func tab1
JOIN func tab2
	ON tab1.id_func = tab2.id_func
	AND tab1.id_linha <> tab2.id_linha
WHERE tab1.cidade_nasci IS NULL AND tab1.idade IS NOT NULL;


-- Visualizamos o resultado da altera��o executada acima.
SELECT * FROM func;


-- A seguir, percebemos que existem diversos espa�os na coluna nome. Removemos tais espa�os abaixo.
-- Demonstra��o da l�gica
SELECT LTRIM(RTRIM(nome)) FROM func;


-- Atualiza��o da tabela.
UPDATE func set nome = LTRIM(RTRIM(nome));


-- Novamente visualizamos o resultado da altera��o executada acima.
SELECT * FROM func;


-- Tamb�m � notada a exist�cia, no genero, de F, FEMININO, M e MASCULINO. Isso para o mesmo id_func.
SELECT tab1.genero, tab1.id_func, tab2.genero, tab2.id_func
FROM func tab1
JOIN func tab2
	ON tab1.id_func = tab2.id_func
	AND tab1.genero <> tab2.genero;


-- Preparamos para simplificar, padronizando mantendo apenas MASCULINO e FEMININO
SELECT genero,
CASE WHEN genero = 'M' THEN 'MASCULINO'
	 WHEN genero = 'F' THEN 'FEMININO'
	 ELSE genero
	 END AS genero_padronizado
FROM func;


-- Simplificando, vamos padronizar para apenas MASCULINO e FEMININO, isso para linhas que possuem mesmo func_id.
UPDATE tab1
SET genero = CASE WHEN tab1.genero = 'M' AND tab2.genero = 'MASCULINO' AND tab1.id_func = tab2.id_func
                  THEN 'MASCULINO'
	              WHEN tab1.genero = 'F' AND tab2.genero = 'FEMININO' AND tab1.id_func = tab2.id_func
				  THEN 'FEMININO'
	              ELSE tab1.genero
	              END
FROM func AS tab1 
JOIN func tab2
ON tab1.id_func = tab2.id_func
WHERE tab1.genero = 'F' OR tab1.genero = 'M';


-- Visualizamos o resultado.
SELECT * FROM func;


-- Nos falta a informa��o do ult_sobrenome do Matheus (id_func = 1). 
-- Ainda, foi informado de �ltima hora que alguns nomes da tabela func est�o errados.
-- Foi fornecida nova tabela e informado que ela cont�m todos os nomes e ultimos sobrenomes e que todos eles est�o corretos.
-- Usaremos esta nova tabela para complementar e corrigir os nomes da tabela_func.

-- Primeiro visualizamos a tabela que cont�m os nomes corretos.
SELECT * FROM names_correct;


-- Atualizamos os dados das colunas de nome e ult_sobrenome da tabela func. 
-- Isso � efetuado utilizando dados de names_correct.
-- Primeiro demonstramos sem alterar a tabela.
SELECT tab1.nome, tab1.ult_sobrenome, tab1.id_func, tab2.func_id, tab2.nome AS nome_correct,  tab2.ultimo_sobrenome AS sobrenome_correct
FROM func AS tab1
JOIN names_correct AS tab2
	ON tab1.id_func = tab2.func_id;


-- Em sequ�ncia alterando a tabela.
UPDATE tab1
SET nome = tab2.nome, ult_sobrenome = tab2.ultimo_sobrenome
FROM func AS tab1
JOIN names_correct AS tab2
	ON tab1.id_func = tab2.func_id;


-- Visualiza o resultado.
SELECT * FROM func;


-- Nossa tabela est� quase totalmente limpa. Ser� �til vermos se n�o existem linhas que representam id_fund que apresentam NULL em
-- alguma coluna e, ao tratar da mesma coluna e id_func, mas em linha distinta, exista um valor n�o NULL. Isso � investigado para todas as colunas.
-- Caso n�o exista linha com essas propriedades, existe ao menos uma linha, que representa um id_func, que cont�m informa��es para todas 
-- as colunas.
SELECT tab1.id_func,tab1.nome,tab1.ult_sobrenome,tab1.idade,tab1.cidade_nasci,tab1.genero
FROM func AS tab1
JOIN func AS tab2
	ON tab1.id_func = tab2.id_func
	AND tab1.id_linha <> tab2.id_linha
WHERE tab1.id_func IS NULL AND tab2.id_func IS NULL OR
tab1.nome IS NULL AND tab2.nome IS NULL OR 
tab1.ult_sobrenome IS NULL AND tab2.ult_sobrenome IS NULL OR 
tab1.idade IS NULL AND tab2.idade IS NULL OR 
tab1.cidade_nasci IS NULL AND tab2.cidade_nasci IS NULL OR
tab1.genero IS NULL AND tab2.genero IS NULL OR
tab1.id_func IS NULL AND tab2.id_func IS NULL;


-- A query acima confirmou que existe ao menos uma linha, que representa um id_func, que cont�m informa��es para todas 
-- as colunas. Isso � v�lido para todos os id_func, uma vez que tratamos de todos eles na query acima.
-- Assim, podemos deletar todas as linhas que cont�m um ou mais dados faltantes.

-- Demonstra l�gica por meio de query e identifica 3 linhas a serem deletadas.
SELECT id_func, nome, ult_sobrenome, idade, cidade_nasci, genero 
FROM func 
WHERE id_func IS NULL OR
	  nome IS NULL OR 
	  ult_sobrenome IS NULL OR
	  idade IS NULL OR
	  cidade_nasci IS NULL OR
	  genero IS NULL;


-- Efetua a altera��o almejada.
DELETE FROM func
WHERE id_func IS NULL OR
	  nome IS NULL OR 
	  ult_sobrenome IS NULL OR
	  idade IS NULL OR
	  cidade_nasci IS NULL OR
	  genero IS NULL;


-- Visualizamos o resultado.
SELECT * FROM func;


-- Como mencionado desde o in�cio, visamos remover os duplicados (linhas id�nticas).
-- Como id_func j� nos identifica perfeitamente cada funcion�rio, para remover duplicados, podemos desconsiderar a linha id_linha.

-- Demonstra query que faz isso.
SELECT DISTINCT id_func, nome, ult_sobrenome, idade, cidade_nasci, genero 
FROM func;


-- Remove duplicados da tabela.
WITH CTE AS(
   SELECT id_func, nome, ult_sobrenome, idade, cidade_nasci, genero,
       RN = ROW_NUMBER()OVER(PARTITION BY id_func ORDER BY id_func)
   FROM func
)
DELETE FROM CTE WHERE RN > 1;


-- Remove a coluna j� n�o mais �til.
ALTER TABLE func 
DROP COLUMN id_linha;


-- Visualiza o resultado e compara a tabela obtida com a inicial (func_clone).
SELECT * FROM func_clone;
SELECT * FROM func;



-- Como resultado, obtemos uma tabela mais sucinta, sem nenhuma perda de informa��o, com dados totalmente estruturados.
-- Antes disso ser alcan�ado, foi criada tabela clone da original. Ainda, previamente a cada passo de altera��o da tabela func,
-- foi demonstrada a l�gica de como se alcan�ar o resultado almejado sem alterar tal tabela.
-- Obrigado por ter acompanhado este processo.
