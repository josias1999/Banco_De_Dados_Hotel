CREATE DATABASE hospedar_db;
USE hospedar_db;
-- Tabela Hotel
CREATE TABLE Hotel (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    cidade VARCHAR(255) NOT NULL,
    uf VARCHAR(2) NOT NULL,
    classificacao INT NOT NULL CHECK (classificacao BETWEEN 1 AND 5)
);

-- Tabela Quarto
CREATE TABLE Quarto (
    quarto_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    numero INT NOT NULL,
    tipo VARCHAR(255) NOT NULL,
    preco_diaria DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

-- Tabela Cliente
CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE
);

-- Tabela Hospedagem
CREATE TABLE Hospedagem (
    hospedagem_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    quarto_id INT NOT NULL,
    dt_checkin DATE NOT NULL,
    dt_checkout DATE NOT NULL,
    valor_total_hosp FLOAT NOT NULL,
    status_hosp VARCHAR(20) NOT NULL CHECK (status_hosp IN ('reserva', 'finalizada', 'hospedado', 'cancelada')),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (quarto_id) REFERENCES Quarto(quarto_id)
);
-- Inserir dados na tabela Hotel
INSERT INTO Hotel (nome, cidade, uf, classificacao)
VALUES 
('Hotel A', 'São Paulo', 'SP', 5),
('Hotel B', 'Rio de Janeiro', 'RJ', 4);

-- Inserir dados na tabela Quarto
INSERT INTO Quarto (hotel_id, numero, tipo, preco_diaria)
VALUES 
(1, 101, 'Standard', 200.00),
(1, 102, 'Deluxe', 300.00),
(1, 103, 'Suíte', 500.00),
(1, 104, 'Standard', 200.00),
(1, 105, 'Deluxe', 300.00),
(2, 201, 'Standard', 180.00),
(2, 202, 'Deluxe', 280.00),
(2, 203, 'Suíte', 480.00),
(2, 204, 'Standard', 180.00),
(2, 205, 'Deluxe', 280.00);

-- Inserir dados na tabela Cliente
INSERT INTO Cliente (nome, email, telefone, cpf)
VALUES 
('João Silva', 'joao@gmail.com', '1111-1111', '123.456.789-00'),
('Maria Souza', 'maria@gmail.com', '2222-2222', '987.654.321-00'),
('Carlos Oliveira', 'carlos@gmail.com', '3333-3333', '111.222.333-44');

-- Inserir dados na tabela Hospedagem
INSERT INTO Hospedagem (cliente_id, quarto_id, dt_checkin, dt_checkout, valor_total_hosp, status_hosp)
VALUES 
(1, 101, '2024-01-01', '2024-01-05', 800.00, 'reserva'),
(1, 102, '2024-02-01', '2024-02-03', 600.00, 'reserva'),
(1, 103, '2024-03-01', '2024-03-05', 2500.00, 'finalizada'),
(1, 104, '2024-04-01', '2024-04-05', 800.00, 'hospedado'),
(1, 105, '2024-05-01', '2024-05-05', 1200.00, 'cancelada'),
(2, 201, '2024-01-10', '2024-01-15', 900.00, 'reserva'),
(2, 202, '2024-02-10', '2024-02-12', 560.00, 'reserva'),
(2, 203, '2024-03-10', '2024-03-15', 2400.00, 'finalizada'),
(2, 204, '2024-04-10', '2024-04-15', 900.00, 'hospedado'),
(2, 205, '2024-05-10', '2024-05-15', 1400.00, 'cancelada'),
(3, 101, '2024-06-01', '2024-06-05', 800.00, 'reserva'),
(3, 102, '2024-07-01', '2024-07-03', 600.00, 'reserva'),
(3, 103, '2024-08-01', '2024-08-05', 2500.00, 'finalizada'),
(3, 104, '2024-09-01', '2024-09-05', 800.00, 'hospedado'),
(3, 105, '2024-10-01', '2024-10-05', 1200.00, 'cancelada'),
(1, 201, '2024-11-01', '2024-11-05', 720.00, 'finalizada'),
(2, 202, '2024-12-01', '2024-12-05', 1120.00, 'finalizada'),
(3, 203, '2024-11-15', '2024-11-20', 2400.00, 'finalizada'),
(1, 204, '2024-11-20', '2024-11-25', 900.00, 'hospedado'),
(2, 205, '2024-12-10', '2024-12-15', 1400.00, 'cancelada');
-- a. Listar todos os hotéis e seus respectivos quartos
SELECT h.nome AS hotel_nome, h.cidade, q.tipo, q.preco_diaria
FROM Hotel h
JOIN Quarto q ON h.hotel_id = q.hotel_id;

-- b. Listar todos os clientes que já realizaram hospedagens (status_hosp igual á “finalizada”), e os respectivos quartos e hotéis
SELECT c.nome AS cliente_nome, q.tipo AS quarto_tipo, h.nome AS hotel_nome
FROM Cliente c
JOIN Hospedagem hos ON c.cliente_id = hos.cliente_id
JOIN Quarto q ON hos.quarto_id = q.quarto_id
JOIN Hotel h ON q.hotel_id = h.hotel_id
WHERE hos.status_hosp = 'finalizada';

-- c. Mostrar o histórico de hospedagens em ordem cronológica de um determinado cliente
SELECT hos.*
FROM Hospedagem hos
WHERE hos.cliente_id = 1 -- Substituir pelo cliente desejado
ORDER BY hos.dt_checkin;

-- d. Apresentar o cliente com maior número de hospedagens
SELECT c.nome, COUNT(hos.hospedagem_id) AS total_hospedagens
FROM Cliente c
JOIN Hospedagem hos ON c.cliente_id = hos.cliente_id
GROUP BY c.cliente_id
ORDER BY total_hospedagens DESC
LIMIT 1;

-- e. Apresentar clientes que tiveram hospedagem “cancelada”, os respectivos quartos e hotéis
SELECT c.nome AS cliente_nome, q.tipo AS quarto_tipo, h.nome AS hotel_nome
FROM Cliente c
JOIN Hospedagem hos ON c.cliente_id = hos.cliente_id
JOIN Quarto q ON hos.quarto_id = q.quarto_id
JOIN Hotel h ON q.hotel_id = h.hotel_id
WHERE hos.status_hosp = 'cancelada';

-- f. Calcular a receita de todos os hotéis (hospedagem com status_hosp igual a “finalizada”), ordenado de forma decrescente
SELECT h.nome AS hotel_nome, SUM(hos.valor_total_hosp) AS total_receita
FROM Hospedagem hos
JOIN Quarto q ON hos.quarto_id = q.quarto_id
JOIN Hotel h ON q.hotel_id = h.hotel_id
WHERE hos.status_hosp = 'finalizada'
GROUP BY h.hotel_id
ORDER BY total_receita DESC;

-- g. Listar todos os clientes que já fizeram uma reserva em um hotel específico
SELECT DISTINCT c.nome AS cliente_nome
FROM Cliente c
JOIN Hospedagem hos ON c.cliente_id = hos.cliente_id
JOIN Quarto q ON hos.quarto_id = q.quarto_id
WHERE q.hotel_id = 1; -- Substituir pelo hotel desejado

-- h. Listar o quanto cada cliente que gastou em hospedagens (status_hosp igual a “finalizada”), em ordem decrescente por valor gasto
SELECT c.nome AS cliente_nome, SUM(hos.valor_total_hosp) AS total_gasto
FROM Cliente c
JOIN Hospedagem hos ON c.cliente_id = hos.cliente_id
WHERE hos.status_hosp = 'finalizada'
GROUP BY c.cliente_id
ORDER BY total_gasto DESC;

-- i. Listar todos os quartos que ainda não receberam hóspedes
SELECT q.*
FROM Quarto q
LEFT JOIN Hospedagem hos ON q.quarto_id = hos.quarto_id
WHERE hos.hospedagem_id IS NULL;

-- j. Apresentar a média de preços de diárias em todos os hotéis, por tipos de quarto
SELECT q.tipo, AVG(q.preco_diaria) AS media_preco_diaria
FROM Quarto q
GROUP BY q.tipo;

-- l. Criar a coluna checkin_realizado do tipo booleano na tabela Hospedagem e atribuir valores
ALTER TABLE Hospedagem ADD COLUMN checkin_realizado BOOLEAN;
UPDATE Hospedagem
SET checkin_realizado = CASE
    WHEN status_hosp IN ('finalizada', 'hospedado') THEN TRUE
    ELSE FALSE
END;

-- m. Mudar o nome da coluna “classificacao” da tabela Hotel para “ratting”
ALTER TABLE Hotel CHANGE COLUMN classificacao ratting INT NOT NULL;

-- a. Procedure "RegistrarCheckIn"
DELIMITER //
CREATE PROCEDURE RegistrarCheckIn(IN p_hospedagem_id INT, IN p_dt_checkin DATE)
BEGIN
    UPDATE Hospedagem
    SET dt_checkin = p_dt_checkin, status_hosp = 'hospedado'
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;

-- b. Procedure "CalcularTotalHospedagem"
DELIMITER //
CREATE PROCEDURE CalcularTotalHospedagem(IN p_hospedagem_id INT)
BEGIN
    DECLARE v_dt_checkin DATE;
    DECLARE v_dt_checkout DATE;
    DECLARE v_quarto_id INT;
    DECLARE v_preco_diaria DECIMAL(10, 2);
    DECLARE v_dias INT;
    DECLARE v_valor_total FLOAT;

    SELECT dt_checkin, dt_checkout, quarto_id INTO v_dt_checkin, v_dt_checkout, v_quarto_id
    FROM Hospedagem
    WHERE hospedagem_id = p_hospedagem_id;

    SELECT preco_diaria INTO v_preco_diaria
    FROM Quarto
    WHERE quarto_id = v_quarto_id;

    SET v_dias = DATEDIFF(v_dt_checkout, v_dt_checkin);
    SET v_valor_total = v_dias * v_preco_diaria;

    UPDATE Hospedagem
    SET valor_total_hosp = v_valor_total
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;

-- c. Procedure "RegistrarCheckout"
DELIMITER //
CREATE PROCEDURE RegistrarCheckout(IN p_hospedagem_id INT, IN p_dt_checkout DATE)
BEGIN
    UPDATE Hospedagem
    SET dt_checkout = p_dt_checkout, status_hosp = 'finalizada'
    WHERE hospedagem_id = p_hospedagem_id;
END //
DELIMITER ;

-- a. Function "TotalHospedagensHotel"
DELIMITER //
CREATE FUNCTION TotalHospedagensHotel(p_hotel_id INT) RETURNS INT
BEGIN
    DECLARE v_total_hospedagens INT;

    SELECT COUNT(hos.hospedagem_id) INTO v_total_hospedagens
    FROM Hospedagem hos
    JOIN Quarto q ON hos.quarto_id = q.quarto_id
    WHERE q.hotel_id = p_hotel_id;

    RETURN v_total_hospedagens;
END //
DELIMITER ;

-- b. Function "ValorMedioDiariasHotel"
DELIMITER //
CREATE FUNCTION ValorMedioDiariasHotel(p_hotel_id INT) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE v_valor_medio DECIMAL(10, 2);

    SELECT AVG(q.preco_diaria) INTO v_valor_medio
    FROM Quarto q
    WHERE q.hotel_id = p_hotel_id;

    RETURN v_valor_medio;
END //
DELIMITER ;

-- c. Function "VerificarDisponibilidadeQuarto"
DELIMITER //
CREATE FUNCTION VerificarDisponibilidadeQuarto(p_quarto_id INT, p_data DATE) RETURNS BOOLEAN
BEGIN
    DECLARE v_disponivel BOOLEAN;

    SELECT COUNT(*) = 0 INTO v_disponivel
    FROM Hospedagem
    WHERE quarto_id = p_quarto_id AND p_data BETWEEN dt_checkin AND dt_checkout;

    RETURN v_disponivel;
END //
DELIMITER ;

-- a. Trigger "AntesDeInserirHospedagem"
DELIMITER //
CREATE TRIGGER AntesDeInserirHospedagem
BEFORE INSERT ON Hospedagem
FOR EACH ROW
BEGIN
    DECLARE v_disponivel BOOLEAN;

    SET v_disponivel = (SELECT VerificarDisponibilidadeQuarto(NEW.quarto_id, NEW.dt_checkin));

    IF v_disponivel = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quarto não está disponível na data de check-in.';
    END IF;
END //
DELIMITER ;

-- b. Trigger "AposDeletarCliente"
CREATE TABLE ClienteLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    nome VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(20),
    cpf VARCHAR(14),
    data_exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER AposDeletarCliente
AFTER DELETE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO ClienteLog (cliente_id, nome, email, telefone, cpf)
    VALUES (OLD.cliente_id, OLD.nome, OLD.email, OLD.telefone, OLD.cpf);
END //
DELIMITER ;

