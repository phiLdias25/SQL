-- Criando a base de dados para manipulação
CREATE TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50));

CREATE TABLE EmployeeSalary
(EmployeeID int,
JobTitle varchar(50),
Salary int);

INSERT INTO EmployeeDemographics
VALUES
    (1001, 'Jim', 'Halpert', 30, 'Male'),
    (1002, 'Pam', 'Beasley', 30, 'Female'),
    (1003, 'Dwight', 'Schrute', 29, 'Male'),
    (1004, 'Angela', 'Martin', 31, 'Female'),
    (1005, 'Toby', 'Flenderson', 32, 'Male'),
    (1006, 'Michael', 'Scott', 35, 'Male'),
    (1007, 'Meredith', 'Palmer', 32, 'Female'),
    (1008, 'Stanley', 'Hudson', 38, 'Male'),
    (1009, 'Kevin', 'Malone', 31, 'Male'),
    (1010, 'Ryan', 'Howard', 26, 'Male');

INSERT INTO EmployeeSalary
VALUES
    (1001, 'Salesman', 45000),
    (1002, 'Receptionist', 36000),
    (1003, 'Salesman', 63000),
    (1004, 'Accountant', 47000),
    (1005, 'HR', 50000),
    (1006, 'Regional Manager', 65000),
    (1007, 'Supplier Relations', 41000),
    (1008, 'Salesman', 48000),
    (1009, 'Accountant', 42000);

---- CASE STATEMENTS ----
--- Especifica condições e o que acontecerá quando elas são cumpridas

SELECT FirstName, LastName, Age,
CASE
    WHEN Age > 30 THEN 'Old'
    ELSE 'Young' -- Cria uma nova coluna que determina os funcionários com idade acima de 30 anos como 'old' e abaixo como 'young'
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age;

SELECT FirstName, LastName, Age,
CASE
    WHEN Age > 30 THEN 'Old'
    WHEN Age BETWEEN 27 AND 30 THEN 'Young'
    ELSE 'Baby' 
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age;

SELECT FirstName, LastName, Age,
CASE
    WHEN Age > 30 THEN 'Old'
    WHEN Age = 38 THEN 'Stanley' -- O PRIMEIRO WHEN É SEMPRE PRIORIZADO, POR ISSO, PARA IDADE IGUAL A 38, AINDA APARECE OLD
    ELSE 'Young' 
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age;

DELETE FROM EmployeeDemographics
WHERE EmployeeID = 1010;

-- Imaginando que cada funcionário receberá um aumento COM BASE EM SUA POSIÇÃO NA EMPRESA, podemos usar um CASE STATEMENT
SELECT FirstName, LastName, JobTitle, Salary,
CASE
    WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .1)
    WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
    WHEN JobTitle = 'HR' THEN Salary + (Salary * 0.000001)
    ELSE Salary + (Salary * .03)
END AS SalaryAfterRaise
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;


---- HAVING CLAUSE ----

-- Encontrar todos as posições com mais de uma pessoa trabalhando
SELECT JobTitle, COUNT(JobTitle) -- Além de selecionar por trabalho, fará a contagem de quantas pessoas trabalham naquela posição
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1; -- Limita a base para somente posições que possuem mais de um indivíduo - DEVE SER COLOCADA DEPOIS DO AGRUPAMENTO (GROUP BY)

-- Encontrar todos as posições com salário médio maior que 45000
SELECT JobTitle, AVG(Salary)
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary); -- HAVING deve vir ANTES DA ORDENAÇÃO (ORDER BY)

---- Atualizando e Deletando Dados ----
-- Enquanto INSERT cria novas colunas, UPDATE vai ATUALIZAR UMA LINHA JÁ EXISTENTE, e DELETE vai DELETAR UMA LINHA COMPLETA

-- Adicionando novas infos
INSERT INTO EmployeeDemographics
VALUES(NULL,'Holly','Flax',NULL,NULL);

-- Para atualizar os valores da nova funcionária:
UPDATE EmployeeDemographics
SET EmployeeID = 1010
WHERE FirstName = 'Holly' AND LastName = 'Flax';

-- É possível atualizar mais de uma info na mesma query:
UPDATE EmployeeDemographics
SET Age = 31, Gender = 'Female'
WHERE FirstName = 'Holly' AND LastName = 'Flax';

-- Para deletar uma linha:
DELETE FROM EmployeeDemographics
WHERE EmployeeID = 1005;

--- Uma possibilidade para tomar cuidado com o DELETE é utilizar um SELECT antes, para evitar deletar informações que não deveriam ser apagadas

---- ALIASING ----
-- Temporariamente alterar o nome de alguma coluna para facilitar o entendimento

SELECT FirstName AS FName
FROM EmployeeDemographics;

--É possível fazer sem o AS
SELECT FirstName FName
FROM EmployeeDemographics;


-- Criar uma coluna com o nome completo dos funcionários
SELECT CONCAT(FirstName, ' ' , LastName) AS FullName -- CONCAT serve para concatenar strings em uma coluna só
FROM EmployeeDemographics;

-- Encontrar a idade média dos funcionários
SELECT AVG(Age) as AverageAge
FROM EmployeeDemographics;

-- É possível criar um ALIAS para a tabela
SELECT Demo.EmployeeID
FROM EmployeeDemographics AS Demo;

-- Juntando com a base de salário
SELECT Demo.EmployeeID, Sal.Salary
FROM EmployeeDemographics AS Demo
JOIN EmployeeSalary AS Sal
ON Demo.EmployeeID = Sal.EmployeeID;

---- PARTITION BY ----
-- Divide os resultados da query

-- Fazendo o join das duas tabelas
SELECT *
FROM EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.EmployeeID = sal.EmployeeID;

-- Separando a base por gênero:
SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
FROM EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.EmployeeID = sal.EmployeeID; -- Mostra não só os funcionários, mas o total de homens e mulheres na empresa

--- Diferente do Group By, o Partition isola uma coluna para realizar o agrupamento
SELECT Gender, COUNT(Gender)
FROM EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.EmployeeID = sal.EmployeeID
GROUP BY Gender; -- Para obter o mesmo agrupamento com o GROUP BY, não conseguimos manter os outros atributos na base
