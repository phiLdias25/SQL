-- Tipos de Variável

-- INT - Valores Inteiros
-- DECIMAL(M [total de dígitos],N [número de dígitos após casa decimal]) - Valor exato de nºs decimais
-- VARCHAR(n) - String de texto de length n
-- BLOB - Binary Large Object (Armazena dados Grandes)
-- DATE - Data (AAAA-MM-DD)
-- TIMESTAMP - Data e hora (AAAA-MM-DD HH:MM:SS)

------ Criando Tabelas ------

CREATE TABLE student(
    student_id INT PRIMARY KEY, -- Nome da coluna e Avisando que essa é a chave primária, que diferencia os elementos da tabela de forma única
    name VARCHAR(20),
    major VARCHAR(20)
    -- PRIMARY KEY(student_id) Também é uma forma de colocar a chave primária
);

DESCRIBE student; -- Mostra as informações básicas da tabela


ALTER TABLE student ADD gpa DECIMAL(3, 2); -- Adiciona uma coluna nova à tabela



ALTER TABLE student DROP COLUMN gpa; -- Remove uma coluna da tabela

------ Inserindo Dados na Tabela ------

INSERT INTO student VALUES( -- A ordem será da primeira coluna inserida até a última
    1, 'Jack', 'Biology'
);

SELECT * FROM student; -- Apresenta todas as informações da tabela

INSERT INTO student VALUES(
    2, 'Kate', 'Sociology'
);

INSERT INTO student(student_id, name) VALUES(
    3, 'Claire'
); -- Seleciona em quais colunas os dados serão inseridos, no caso, não foi colocado o major

INSERT INTO student VALUES(
    4, 'Jack', 'Biology'
);

INSERT INTO student VALUES(
    5, 'Mike', 'Computer Science'
);

DROP TABLE student; -- Deleta a tabela

CREATE TABLE student(
    student_id INT PRIMARY KEY,
    name VARCHAR(20) NOT NULL, -- Nenhum nome pode ser null,
    major VARCHAR(20) UNIQUE -- Nenhum aluno pode ter um major igual ao outro
);

CREATE TABLE student(
    student_id INT AUTO_INCREMENT, -- Mesmo se o número do ID não for especificado, o programa preencherá automaticamente o valor,
    name VARCHAR(20) NOT NULL, -- Nenhum nome pode ser null,
    major VARCHAR(20) DEFAULT 'undecided', -- Caso o major não seja informado, o default será undecided
    PRIMARY KEY(student_id)
);

INSERT INTO student(name, major) VALUES( 
    'Jack', 'Biology'
);

INSERT INTO student(name, major) VALUES(
    'Kate', 'Sociology'
);

INSERT INTO student(name, major) VALUES(
    'Claire', 'Chemistry'
);

INSERT INTO student(name, major) VALUES(
    'Jack', 'Biology'
);

INSERT INTO student(name, major) VALUES(
    'Mike', 'Computer Science'
);

SELECT * FROM student;

---- Atualizando a base de dados ----

UPDATE student -- Atualizando a base student
SET major = 'Bio' -- Mudando o nome da coluna major
WHERE major = 'Biology'; -- Selecionando que a mudança ocorrerá somente para os majors de Biologia

UPDATE student
SET major = 'Comp Sci'
WHERE major = 'Computer Science';

UPDATE student
SET major = 'Comp Sci'
WHERE student_id = 4; -- Trocando a condição de mudança do nome

UPDATE student
SET major = 'Biochemistry'
WHERE major = 'Bio' OR major = 'Chemistry'; -- A condição agora inclui DOIS majors diferentes

UPDATE student
SET name = 'Tom', major = 'undecided'
WHERE student_id = 1; -- Agora, aquele com id 1 teve seu nome e major trocados

UPDATE student
SET major = 'undecided'; -- Sem o WHERE, todas as colunas foram afetadas

---- Deletando colunas da base de dados ----

DELETE FROM student
WHERE student_id = 5; -- O aluno com id 5 foi deletado da tabela

DELETE FROM student
WHERE name = 'Tom' AND major = 'undecided'; -- Agora, aquele com nome Tom E major não definido foi deletado da tabela

---- Queries Básicas ----

-- A Querie é como uma 'pergunta' que é feita para a base sobre uma característica da base

SELECT name
FROM student; -- Nesse caso, foi pedido para que fosse selecionada somente a coluna 'names' da base

SELECT name, major
FROM student; -- Agora, o 'major' foi incluído

SELECT name, major
FROM student
ORDER BY name; -- Com o ORDER BY, a seleção é ordenada pelos nomes (Em ordem alfabética)

SELECT name, major
FROM student
ORDER BY name DESC; -- Ordem agora é descendente

SELECT *
FROM student
ORDER BY major, student_id; -- Agora, caso o 'major' seja igual, a base é ordenada a partir do 'student_id'

SELECT *
FROM student
LIMIT 2; -- O LIMIT limita os resultados que aparecem

SELECT *
FROM student
ORDER BY student_id DESC
LIMIT 2; -- Utilizando tudo, selecionamos todas as infos da base, ordenando pelo 'student_id' de forma decrescente, e limitando a saída para 2 resultados

SELECT *
FROM student
WHERE major = 'Biology'; -- Agora, o comando WHERE seleciona somente a informação que você coloca na saída, nesse caso, somente aqueles que possuem 'major'  = 'Biology'

SELECT *
FROM student
WHERE major = 'Chemistry';

SELECT name, major
FROM student
WHERE major = 'Biology'; -- A seleção definiu agora que somente desejamos o 'name' e o 'major', não todas as infos

SELECT name, major
FROM student
WHERE major = 'Biology' OR major = 'Chemistry'; -- Agora, queremos aqueles que possuem 'major' OU 'Biology' OU 'Chemistry'

SELECT name, major
FROM student
WHERE major = 'Biology' OR name = 'Kate';

SELECT name, major
FROM student
WHERE major <> 'Chemistry'; -- Agora, queremos todos aqueles que NÃO POSSUEM 'major' = 'Chemistry'

SELECT *
FROM student
WHERE student_id <> 3;

SELECT name, major
FROM student
WHERE student_id <= 3 AND name <> 'Jack';

SELECT *
FROM student
WHERE name IN ('Claire', 'Kate', 'Mike'); -- O comando IN cria um vetor que define quais variáveis da coluna 'name' queremos que seja apresentado

SELECT *
FROM student
WHERE major IN ('Biology', 'Chemistry');

SELECT *
FROM student
WHERE major IN ('Biology', 'Chemistry') AND student_id > 2;


-- Intro à uma base de dados empresarial --

-- Primeiro, vamos baixar a base criada pelo cara do vídeo

CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  -- Tornando uma das variáveis uma chave externa
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

-- Modo de alterar uma base de dados depois de criá-la
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;
--

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- -----------------------------------------------------------------------------

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

-- Atualizando uma entrada de uma base de dados após criar a entrada
UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;
--

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

-- QUERIES BÁSICAS (SELECT) --

-- Achar todos os funcionários
SELECT *
FROM employee;

-- Achar todos os clientes
SELECT *
FROM client;

-- Funcionários ordenados por salário
SELECT *
FROM employee
ORDER BY salary DESC; -- DESC ordena de forma decrescente

-- Ordenar os funcionários por sexo e nome
SELECT *
FROM employee
ORDER BY sex, first_name, last_name;

-- Encontrar os primeiros 5 funcionários da empresa
SELECT *
FROM employee
LIMIT 5;

-- Encontrar o primeiro e  sobrenome de todos os funcionários
SELECT first_name, last_name
FROM employee;

-- Mesma coisa, porém mudando o nome da coluna de nome e sobrenome
SELECT first_name AS forename, last_name AS surname
FROM employee;

-- Encontrar todos os gêneros diferentes
SELECT DISTINCT sex
FROM employee;

-- Encontrar todas as franquias diferentes
SELECT DISTINCT branch_id
FROM employee;

-- QUERIES BÁSICAS (FUNCTIONS) --

-- Encontrar o número de funcionários
SELECT COUNT(emp_id)
FROM employee;

-- Encontrar o número de funcionários que possui supervisores
SELECT COUNT(super_id)
FROM employee;

-- Encontrar o número de funcionárias nascidas após 1970
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1971-01-01';

-- Encontrar a média do salário dos funcionários
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

-- Encontrar a soma do salário dos funcionários
SELECT SUM(salary)
FROM employee;

-- Encontrar quantos homens e mulheres estão na empresa
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

-- Encontrar as vendas totais de cada vendedor
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

-- Encontrar quanto dinheiro cada cliente gastou com a empresa
SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;