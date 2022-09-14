---------------------------------------------------------------------------------
-- Apresentação.
---------------------------------------------------------------------------------

-- Este código é escrito em Microsoft SQL Server Management Studio.
-- Ele é composto principalmente por limpeza de dados.



---------------------------------------------------------------------------------
-- Importação de dados e descrições de informações basilares.
---------------------------------------------------------------------------------

-- Indica a base de dados a ser utilizada.
USE data_cleaning;


  -- Visualiza todos os dados da tabela.
SELECT * FROM Plan1$;


-- Altera nome da tabela.
sp_rename 'Plan1$', 'func';


-- Visualiza novamente todos os dados da tabela.
SELECT * FROM func;


-- Como informações prévias, é informado que a coluna id_func é o identificador de funcionários. O id_func é único de cada funcionário.
-- As informações da tabela referem-se a funcionários. Assim, uma linha por funcionário basta para conter todas as informações.

-- É visível a existência de muitas linhas com id_func idêntico. É útil que a tabela não apresente esta propriedade para reduzir a quantia
-- de dados, tornando o processamento de dados mais rápido.
-- Neste contexto, executamos procedimentos que visam minimizar a quantia de linhas da tabela.
-- Tais procedimentos também visam tornar a tabela mais padronizada e limpa, facilitando a manipulação, análise e modelagem de dados.

-- Assim, assumimos que é desejado alterar a tabela de dados func.
-- Por boa prática e também para podermos, ao fim, ver os resultados de manipulações nesta tabela, a clonamos antes de alterá-la.
-- Também, antes de cada alteração de tabela, demonstramos, por meio de query, sem alterar a tabela, a lógica subjacente da alteração mencionada, 
-- que permite alcançar o resultado almejado.


-- Clona a tabela.
SELECT * INTO func_clone 
FROM func;


-- Em sequência, iniciaremos o procedimento de limpeza de dados.



---------------------------------------------------------------------------------
-- Limpeza de dados.
---------------------------------------------------------------------------------

-- Como mencionado, existem linhas com id_func idêntico. Mais especificamente, existem pares linhas com essa propriedade em que 
-- uma linha detém informação de cidade_nasci ou idade e a outra (seu par) não. Com o código abaixo, inserimos informação de uma linha que detém 
-- informação de cidade_nasci para sua linha par que não possui este dado. Ainda, esta linha que recebe dado de cidade_nasci
-- deve apresentar informação de idade. Assim, obtemos uma linha com informações completas sobre essas duas colunas (cidade_nasci
-- e idade) para um id_func.

-- Primeiro demonstramos código que expressa a lógica para alcançar o objetivo mencionado. 
-- Notar como selecionamos cidades com NULL e idade sem NULL, seguindo o planejado .
-- Também perceber que selecionamos linhas com id_func igual (para coletar informação de um funcionário, consideramos o próprio
-- funcionário). Por fim, tal coleta é realizada em linhas diferentes, que detém informaçõe diferentes.
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


-- Visualizamos o resultado da alteração executada acima.
SELECT * FROM func;


-- A seguir, percebemos que existem diversos espaços na coluna nome. Removemos tais espaços abaixo.
-- Demonstração da lógica
SELECT LTRIM(RTRIM(nome)) FROM func;


-- Atualização da tabela.
UPDATE func set nome = LTRIM(RTRIM(nome));


-- Novamente visualizamos o resultado da alteração executada acima.
SELECT * FROM func;


-- Também é notada a existêcia, no genero, de F, FEMININO, M e MASCULINO. Isso para o mesmo id_func.
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


-- Nos falta a informação do ult_sobrenome do Matheus (id_func = 1). 
-- Ainda, foi informado de última hora que alguns nomes da tabela func estão errados.
-- Foi fornecida nova tabela e informado que ela contém todos os nomes e ultimos sobrenomes e que todos eles estão corretos.
-- Usaremos esta nova tabela para complementar e corrigir os nomes da tabela_func.

-- Primeiro visualizamos a tabela que contém os nomes corretos.
SELECT * FROM names_correct;


-- Atualizamos os dados das colunas de nome e ult_sobrenome da tabela func. 
-- Isso é efetuado utilizando dados de names_correct.
-- Primeiro demonstramos sem alterar a tabela.
SELECT tab1.nome, tab1.ult_sobrenome, tab1.id_func, tab2.func_id, tab2.nome AS nome_correct,  tab2.ultimo_sobrenome AS sobrenome_correct
FROM func AS tab1
JOIN names_correct AS tab2
	ON tab1.id_func = tab2.func_id;


-- Em sequência alterando a tabela.
UPDATE tab1
SET nome = tab2.nome, ult_sobrenome = tab2.ultimo_sobrenome
FROM func AS tab1
JOIN names_correct AS tab2
	ON tab1.id_func = tab2.func_id;


-- Visualiza o resultado.
SELECT * FROM func;


-- Nossa tabela está quase totalmente limpa. Será útil vermos se não existem linhas que representam id_fund que apresentam NULL em
-- alguma coluna e, ao tratar da mesma coluna e id_func, mas em linha distinta, exista um valor não NULL. Isso é investigado para todas as colunas.
-- Caso não exista linha com essas propriedades, existe ao menos uma linha, que representa um id_func, que contém informações para todas 
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


-- A query acima confirmou que existe ao menos uma linha, que representa um id_func, que contém informações para todas 
-- as colunas. Isso é válido para todos os id_func, uma vez que tratamos de todos eles na query acima.
-- Assim, podemos deletar todas as linhas que contém um ou mais dados faltantes.

-- Demonstra lógica por meio de query e identifica 3 linhas a serem deletadas.
SELECT id_func, nome, ult_sobrenome, idade, cidade_nasci, genero 
FROM func 
WHERE id_func IS NULL OR
	  nome IS NULL OR 
	  ult_sobrenome IS NULL OR
	  idade IS NULL OR
	  cidade_nasci IS NULL OR
	  genero IS NULL;


-- Efetua a alteração almejada.
DELETE FROM func
WHERE id_func IS NULL OR
	  nome IS NULL OR 
	  ult_sobrenome IS NULL OR
	  idade IS NULL OR
	  cidade_nasci IS NULL OR
	  genero IS NULL;


-- Visualizamos o resultado.
SELECT * FROM func;


-- Como mencionado desde o início, visamos remover os duplicados (linhas idênticas).
-- Como id_func já nos identifica perfeitamente cada funcionário, para remover duplicados, podemos desconsiderar a linha id_linha.

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


-- Remove a coluna já não mais útil.
ALTER TABLE func 
DROP COLUMN id_linha;


-- Visualiza o resultado e compara a tabela obtida com a inicial (func_clone).
SELECT * FROM func_clone;
SELECT * FROM func;



-- Como resultado, obtemos uma tabela mais sucinta, sem nenhuma perda de informação, com dados totalmente estruturados.
-- Antes disso ser alcançado, foi criada tabela clone da original. Ainda, previamente a cada passo de alteração da tabela func,
-- foi demonstrada a lógica de como se alcançar o resultado almejado sem alterar tal tabela.
-- Obrigado por ter acompanhado este processo.
