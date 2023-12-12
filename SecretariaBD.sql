/*
Porte (idPorte(PK), qtdSala, metragem)

Evento(idEvento(PK), dataEvento, publicoExperado, publicoReal, localEvento)

Linguagem(idLinguagem(PK), tipo)

CasadeCultura(idCasa(PK), idPorte(FK) Referencia Porte(idPorte), nomeCasa, endereco, cordenador, capacidade)

Artista(idArtista(PK), tipoLing(FK) Referencia Linguagem(idLinguagem), nomeCompleto, email, telefone, endereco, genero, etnia, nomeArtistico)

ArtistaPF(idArtista(PK)(FK) Referencia Artista(isArtista), cpf)

ArtistaPJ(idArtista(PK)(FK) Referencia Artista(isArtista), cnpj)

Grupo(idGrupo(PK), tipoLing(FK) Referencia Linguagem(idLinguagem))

Participacao(idArtista(PK)(FK) Referencia Artista(isArtista), idGrupo(PK)(FK) Referencia Grupo(idGrupo), funcao)

ContratoEvento(idContrato(PK), idEvento(FK) Referencia Evento(idEvento), idCasa(FK) Referencia CasadeCultura(idCasa), idGrupo(FK) Referencia Grupo(idGrupo),idPagamento(FK) Referencia Pagamento(idPagamento) dataContrato)

Pagamento(idPagamento(PK), idContrato(FK) Referencia ContratoEvento(idContrato), dataAgendado, dataEfetivada)
*/

--Deixar as datas no formato Dia/Mes/Ano
SET DATESTYLE TO POSTGRES, DMY ;

--Criação tabela Porte 
DROP TABLE IF EXISTS porte CASCADE ;
CREATE TABLE porte (
	idPorte SMALLSERIAL PRIMARY KEY,
	qtdSala INT NOT NULL,
	metragem NUMERIC(8,2) NOT NULL
);

--Criação tabela Eventos
DROP TABLE IF EXISTS evento CASCADE ;
CREATE TABLE evento (
	idEvento SMALLSERIAL PRIMARY KEY,
	dataEvento DATE NOT NULL,
	publicoExperado SMALLINT, 
	publicoReal SMALLINT NOT NULL,
	localEvento VARCHAR(255) NOT NULL
);

--Criação tabela Linguagem
DROP TABLE IF EXISTS linguagem CASCADE ;
CREATE TABLE linguagem (
	idLinguagem SMALLSERIAL PRIMARY KEY,
	tipo VARCHAR(30) NOT NULL
);

--Criação tabela Casas de Cultura
DROP TABLE IF EXISTS casacultura CASCADE ;
CREATE TABLE casacultura (
	idCasa SMALLSERIAL PRIMARY KEY,
	idPorte SMALLINT NOT NULL REFERENCES porte(idPorte) ON DELETE CASCADE ON UPDATE CASCADE,
	nomeCasa VARCHAR(50),
	endereco VARCHAR(255) NOT NULL,
	regiao VARCHAR(15) NOT NULL,
	cordenador VARCHAR(50) NOT NULL,
	capacidade INT NOT NULL
);

--Criação tabela Artista
DROP TABLE IF EXISTS artista CASCADE ;
CREATE TABLE artista (
	idArtista SMALLSERIAL PRIMARY KEY,
	tipoLing SMALLINT NOT NULL REFERENCES linguagem(idLinguagem) ON DELETE CASCADE ON UPDATE CASCADE,
	nomeCompleto VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	telefone VARCHAR(15) NOT NULL,
	endereco VARCHAR(100) NOT NULL,
	genero VARCHAR(30),
	etnia VARCHAR(30),
	nomeArtistico VARCHAR(50) NOT NULL
);

--Criação tabela Artista Pessoa Fisica
DROP TABLE IF EXISTS artistapf CASCADE ;
CREATE TABLE artistapf (
	idArtista SMALLINT PRIMARY KEY,
	cpf CHAR(11) NOT NULL,
	FOREIGN KEY (idArtista) REFERENCES artista(idArtista) ON DELETE CASCADE ON UPDATE CASCADE
);

--Criação tabela Artista Pessoa Juridica
DROP TABLE IF EXISTS artistapj CASCADE ;
CREATE TABLE artistapj (
	idArtista SMALLINT PRIMARY KEY,
	cnpj CHAR(14) NOT NULL,
	FOREIGN KEY (idArtista) REFERENCES artista(idArtista) ON DELETE CASCADE ON UPDATE CASCADE
);
--Criação tabela Grupo
DROP TABLE IF EXISTS grupo CASCADE ;
CREATE TABLE grupo (
	idGrupo SMALLSERIAL PRIMARY KEY,
	tipoLing SMALLINT NOT NULL REFERENCES linguagem(idLinguagem) ON DELETE CASCADE ON UPDATE CASCADE
);

--Criação tabela Participação
DROP TABLE IF EXISTS participacao CASCADE ;
CREATE TABLE participacao (
	idArtista SMALLINT,
	idGrupo SMALLINT,
	funcao VARCHAR(30) NOT NULL,
	PRIMARY KEY(idArtista, idGrupo),
	FOREIGN KEY (idArtista) REFERENCES artista(idArtista) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (idGrupo) REFERENCES grupo(idGrupo) ON DELETE CASCADE ON UPDATE CASCADE
);

--Criação tabela Contrato do Evento
DROP TABLE IF EXISTS contratoevento CASCADE ; 
CREATE TABLE contratoevento (
	idContrato SMALLSERIAL PRIMARY KEY,
	idEvento SMALLINT NOT NULL REFERENCES evento(idEvento) ON DELETE CASCADE ON UPDATE CASCADE,
	idCasa SMALLINT NOT NULL REFERENCES casacultura(idCasa) ON DELETE CASCADE ON UPDATE CASCADE,
	idGrupo SMALLINT NOT NULL REFERENCES grupo(idGrupo) ON DELETE CASCADE ON UPDATE CASCADE,
	dataContrato DATE NOT NULL
);

--Criação tabela Pagamento
DROP TABLE IF EXISTS pagamento CASCADE ;
CREATE TABLE pagamento (
	idPagamento SMALLSERIAL PRIMARY KEY,
	idContrato SMALLINT NOT NULL REFERENCES contratoevento(idContrato) ON DELETE CASCADE ON UPDATE CASCADE,
	valorPag NUMERIC(8,2),
	dataAgendado DATE NOT NULL,
	dataEfetivada TIMESTAMP NOT NULL
);


--INSERTS
--INSERÇÃO DOS DADOS NAS TABELAS
INSERT INTO porte (idPorte, qtdSala, metragem) VALUES 
(DEFAULT, 0, 120.50),
(DEFAULT, 2, 90.25),
(DEFAULT, 3, 150.75),
(DEFAULT, 4, 200.00),
(DEFAULT, 5, 110.80);

INSERT INTO evento (idEvento, dataEvento, publicoExperado, publicoReal, localEvento) VALUES 
(DEFAULT, '2023-01-10', 30, 10, 'Sala 1'),	
(DEFAULT, '2023-02-15', 50, 30, 'Salão'),	
(DEFAULT, '2023-03-20', 80, 60, 'Palco Interno'),	
(DEFAULT, '2023-04-05', 120, 100, 'Palco Interno'),	
(DEFAULT, '2023-05-08', 200, 180, 'Palco Interno'),	
(DEFAULT, '2023-06-12', 300, 280, 'Palco Externo'),	
(DEFAULT, '2023-07-18', 500, 480, 'Palco Externo'),	
(DEFAULT, '2023-08-22', 800, 760, 'Palco Externo'),	
(DEFAULT, '2023-09-28', 1200, 1100, 'Palco Externo'),	
(DEFAULT, '2023-10-15', 2500, 2400, 'Palco Externo'),	
(DEFAULT, '2023-11-15', 5000, 4800, 'Palco Externo'),	
(DEFAULT, '2023-12-20', 6000, 5800, 'Palco Externo'),	
(DEFAULT, '2023-06-30', 150, 140, 'Palco Interno'),	
(DEFAULT, '2023-09-10', 300, 280, 'Palco Externo'),	
(DEFAULT, '2023-12-25', 1000, 950, 'Palco Externo'),	
(DEFAULT, '2023-02-28', 80, 60, 'Palco Interno'),	
(DEFAULT, '2023-05-05', 200, 180, 'Palco Interno'),	
(DEFAULT, '2023-08-15', 1000, 950, 'Palco Externo'),	
(DEFAULT, '2023-11-01', 4000, 3800, 'Palco Externo'),	
(DEFAULT, '2023-03-10', 150, 140, 'Palco Interno'),	
(DEFAULT, '2023-06-20', 250, 230, 'Palco Interno'),	
(DEFAULT, '2023-09-05', 800, 760, 'Palco Externo'),	
(DEFAULT, '2023-12-10', 3000, 2800, 'Palco Externo'),	
(DEFAULT, '2023-04-15', 180, 160, 'Salão'),	
(DEFAULT, '2023-07-01', 400, 380, 'Palco Externo'),	
(DEFAULT, '2023-10-10', 2000, 1900, 'Palco Externo'),	
(DEFAULT, '2023-01-25', 40, 20, 'Sala'),	
(DEFAULT, '2023-05-01', 100, 80, 'Salão'),	
(DEFAULT, '2023-08-08', 600, 580, 'Palco Externo'),	
(DEFAULT, '2023-11-20', 3500, 3300, 'Palco Externo'),	
(DEFAULT, '2023-02-10', 70, 50, 'Salão'),	
(DEFAULT, '2023-05-15', 150, 130, 'Palco Interno'),	
(DEFAULT, '2023-02-28', 80, 60, 'Salão'),	
(DEFAULT, '2023-05-05', 200, 180, 'Palco Interno'),	
(DEFAULT, '2023-08-15', 1000, 950, 'Palco Externo'),	
(DEFAULT, '2023-11-01', 4000, 3800, 'Palco Externo'),	
(DEFAULT, '2023-03-10', 150, 140, 'Palco Interno'),	
(DEFAULT, '2023-06-20', 250, 230, 'Palco Interno'),	
(DEFAULT, '2023-09-05', 800, 760, 'Palco Externo'),	
(DEFAULT, '2023-12-10', 3000, 2800, 'Palco Externo'),	
(DEFAULT, '2023-04-15', 180, 160, 'Palco Interno'),	
(DEFAULT, '2023-07-01', 400, 380, 'Palco Externo'),	
(DEFAULT, '2023-10-10', 2000, 1900, 'Palco Externo'),	
(DEFAULT, '2023-01-25', 40, 20, 'Sala'),	
(DEFAULT, '2023-05-01', 100, 80, 'Palco Interno'),	
(DEFAULT, '2023-08-08', 600, 580, 'Palco Externo'),	
(DEFAULT, '2023-11-20', 3500, 3300, 'Palco Externo'),	
(DEFAULT, '2023-02-10', 70, 50, 'Palco Interno'),	
(DEFAULT, '2023-05-15', 150, 130, 'Palco Interno'),	
(DEFAULT, '2023-08-01', 39, 35, 'Sala 1');	

INSERT INTO linguagem (idLinguagem, tipo) VALUES 
(DEFAULT, 'Dança'),
(DEFAULT, 'Teatro'),
(DEFAULT, 'Contação de Histórias'),
(DEFAULT, 'Palestra'),
(DEFAULT, 'Música');

INSERT INTO casacultura (idCasa, idPorte, nomeCasa, endereco, regiao, cordenador, capacidade)
VALUES
(DEFAULT, 1, 'Brasilândia', 'Rua Brasilândia, 123', 'NORTE','João Silva', 200),
(DEFAULT, 2, 'Butantã', 'Rua Butantã, 456', 'OESTE','Maria Oliveira', 1250),
(DEFAULT, 3, 'Campo Limpo', 'Rua Campo Limpo, 789', 'SUL','Carlos Santos', 3000),
(DEFAULT, 1, 'Freguesia do Ó', 'Rua Freguesia do Ó, 101', 'NORTE','Ana Pereira', 150),
(DEFAULT, 2, 'Guaianases', 'Rua Guaianases, 202', 'LESTE','Pedro Souza', 1250),
(DEFAULT, 3, 'Hip Hop Leste', 'Rua Hip Hop Leste, 303', 'LESTE','Larissa Santos', 3300),
(DEFAULT, 1, 'Hip Hop Sul', 'Rua Hip Hop Sul, 404', 'SUL','Ricardo Oliveira', 200),
(DEFAULT, 2, 'Ipiranga', 'Rua Ipiranga, 505', 'SUL','Fernanda Lima', 250),
(DEFAULT, 3, 'Itaim Paulista', 'Rua Itaim Paulista, 606', 'LESTE','Gabriel Silva', 300),
(DEFAULT, 1, 'MBoi Mirim', 'Rua MBoi Mirim, 707', 'SUL','Mariana Oliveira', 200),
(DEFAULT, 2, 'Raul Seixas', 'Rua Raul Seixas, 808', 'LESTE','Daniel Santos', 2350),
(DEFAULT, 3, 'Julio Guerra', 'Rua Julio Guerra, 909', 'SUL','Amanda Oliveira', 3300),
(DEFAULT, 1, 'Manoel Cardoso', 'Rua Manoel Cardoso, 111', 'SUL','Lucas Silva', 200),
(DEFAULT, 2, 'São Mateus', 'Rua São Mateus, 222', 'LESTE','Isabela Oliveira', 250),
(DEFAULT, 3, 'São Miguel', 'Rua São Miguel, 333', 'LESTE','Roberto Silva', 3300),
(DEFAULT, 1, 'São Rafael', 'Rua São Rafael, 444', 'LESTE','Patricia Oliveira', 200),
(DEFAULT, 2, 'Tremembé', 'Rua Tremembé, 555', 'OESTE','Gustavo Silva', 250),
(DEFAULT, 3, 'Vila Guilherme', 'Rua Vila Guilherme, 666', 'NORTE','Camila Oliveira', 3300),
(DEFAULT, 2, 'Parelheiro', 'Rua Parelheiros, 777', 'SUL', 'Mauro Lopes', 1500);

INSERT INTO artista (idArtista, tipoLing, nomeCompleto, email, telefone, endereco, genero, etnia, nomeArtistico) VALUES 
(DEFAULT, 5, 'Ana Silva', 'ana.silva@gmail.com', '+55 123456789', 'Rua A, 123', 'Mulher Cis', 'Branco', 'Ana Art'),
(DEFAULT, 2, 'Carlos Oliveira', 'carlos.oliveira@outlook.com', '+55 987654321', 'Rua B, 456', 'Homem Trans', 'Negro', 'Carlito'),
(DEFAULT, 3, 'Maria Santos', 'maria.santos@yahoo.com', '+55 111223344', 'Rua C, 789', 'Mulher Trans', 'Pardo', 'Mary'),
(DEFAULT, 1, 'Eduardo Lima', 'eduardo.lima@gmail.com', '+55 555555555', 'Rua D, 101', 'Homem Cis', 'Branco', 'Edu Lima'),
(DEFAULT, 5, 'Aline Pereira', 'aline.pereira@outlook.com', '+55 999888777', 'Rua E, 202', 'Mulher Cis', 'Pardo', 'Liny'),
(DEFAULT, 2, 'João Oliveira', 'joao.oliveira@gmail.com', '+55 987654322', 'Rua F, 789', 'Homem Cis', 'Negro', 'Joãozinho'),
(DEFAULT, 3, 'Fernanda Silva', 'fernanda.silva@outlook.com', '+55 111223345', 'Rua G, 101', 'Mulher Cis', 'Pardo', 'Fer'),
(DEFAULT, 5, 'Luiz Santos', 'luiz.santos@yahoo.com', '+55 555555556', 'Rua H, 202', 'Homem Cis', 'Branco', 'Luizinho'),
(DEFAULT, 4, 'Mariana Oliveira', 'mariana.oliveira@gmail.com', '+55 987654323', 'Rua I, 789', 'Mulher Cis', 'Negro', 'Mari'),
(DEFAULT, 5, 'Rafaela Pereira', 'rafaela.pereira@outlook.com', '+55 111223346', 'Rua J, 101', 'Mulher Cis', 'Pardo', 'Rafa'),
(DEFAULT, 5, 'Pedro Lima', 'pedro.lima@yahoo.com', '+55 555555557', 'Rua K, 202', 'Homem Cis', 'Branco', 'Pedrinho'),
(DEFAULT, 5, 'Lucas Oliveira', 'lucas.oliveira@gmail.com', '+55 987654324', 'Rua L, 567', 'Homem Cis', 'Negro', 'Lucasinho'),
(DEFAULT, 5, 'Patricia Silva', 'patricia.silva@outlook.com', '+55 111223347', 'Rua M, 789', 'Mulher Cis', 'Pardo', 'Paty'),
(DEFAULT, 2, 'Guilherme Lima', 'guilherme.lima@yahoo.com', '+55 555555558', 'Rua N, 101', 'Homem Cis', 'Branco', 'Gui Lima'),
(DEFAULT, 3, 'Isabela Santos', 'isabela.santos@gmail.com', '+55 987654325', 'Rua O, 567', 'Mulher Cis', 'Negro', 'Bela'),
(DEFAULT, 5, 'Ricardo Pereira', 'ricardo.pereira@outlook.com', '+55 111223348', 'Rua P, 789', 'Homem Cis', 'Pardo', 'Rick'),
(DEFAULT, 5, 'Camila Lima', 'camila.lima@yahoo.com', '+55 555555559', 'Rua Q, 101', 'Mulher Cis', 'Branco', 'Cami'),
(DEFAULT, 5, 'João Silva', 'joao.silva@gmail.com', '+55 987654326', 'Rua R, 567', 'Homem Cis', 'Negro', 'Joãozinho'),
(DEFAULT, 5, 'Laura Oliveira', 'laura.oliveira@outlook.com', '+55 111223349', 'Rua S, 789', 'Mulher Cis', 'Pardo', 'Lau'),
(DEFAULT, 5, 'Miguel Lima', 'miguel.lima@yahoo.com', '+55 555555560', 'Rua T, 101', 'Homem Cis', 'Branco', 'Miguelito'),
(DEFAULT, 3, 'Gabriela Santos', 'gabriela.santos@gmail.com', '+55 987654327', 'Rua U, 567', 'Mulher Cis', 'Negro', 'Gabi'),
(DEFAULT, 1, 'Vinicius Pereira', 'vinicius.pereira@outlook.com', '+55 111223350', 'Rua V, 789', 'Homem Cis', 'Pardo', 'Vini'),
(DEFAULT, 2, 'Amanda Lima', 'amanda.lima@yahoo.com', '+55 555555561', 'Rua W, 101', 'Mulher Cis', 'Branco', 'Amandinha'),
(DEFAULT, 4, 'Fernanda Oliveira', 'fernanda.oliveira@gmail.com', '+55 987654328', 'Rua X, 567', 'Mulher Cis', 'Negro', 'Fernandinha'),
(DEFAULT, 5, 'Matheus Silva', 'matheus.silva@outlook.com', '+55 111223351', 'Rua Y, 789', 'Homem Cis', 'Pardo', 'Matheuzinho'),
(DEFAULT, 5, 'Larissa Lima', 'larissa.lima@yahoo.com', '+55 555555562', 'Rua Z, 101', 'Mulher Cis', 'Branco', 'Lari'),
(DEFAULT, 5, 'Felipe Santos', 'felipe.santos@gmail.com', '+55 987654329', 'Rua AA, 567', 'Homem Cis', 'Negro', 'Felipinho'),
(DEFAULT, 5, 'Juliana Oliveira', 'juliana.oliveira@outlook.com', '+55 111223352', 'Rua BB, 789', 'Mulher Cis', 'Pardo', 'Ju'),
(DEFAULT, 5, 'Pedro Lima', 'pedro.lima@yahoo.com', '+55 555555563', 'Rua CC, 101', 'Homem Cis', 'Branco', 'Pê'),
(DEFAULT, 3, 'Bruna Santos', 'bruna.santos@gmail.com', '+55 987654330', 'Rua DD, 567', 'Mulher Cis', 'Negro', 'Bru'),
(DEFAULT, 1, 'Roberto Pereira', 'roberto.pereira@outlook.com', '+55 111223353', 'Rua EE, 789', 'Homem Cis', 'Pardo', 'Rô'),
(DEFAULT, 2, 'Camilo Lima', 'camilo.lima@yahoo.com', '+55 555555564', 'Rua FF, 101', 'Homem Cis', 'Branco', 'Milo'),
(DEFAULT, 5, 'Carla Oliveira', 'carla.oliveira@gmail.com', '+55 987654331', 'Rua GG, 567', 'Mulher Cis', 'Negro', 'Carlinha'),
(DEFAULT, 5, 'Vitor Silva', 'vitor.silva@outlook.com', '+55 111223354', 'Rua HH, 789', 'Homem Cis', 'Pardo', 'Vitinho'),
(DEFAULT, 5, 'Luana Lima', 'luana.lima@yahoo.com', '+55 555555565', 'Rua II, 101', 'Mulher Cis', 'Branco', 'Lua'),
(DEFAULT, 5, 'Daniel Santos', 'daniel.santos@gmail.com', '+55 987654332', 'Rua JJ, 567', 'Homem Cis', 'Negro', 'Dani'),
(DEFAULT, 1, 'Raquel Oliveira', 'raquel.oliveira@outlook.com', '+55 111223355', 'Rua KK, 789', 'Mulher Cis', 'Pardo', 'Raq'),
(DEFAULT, 2, 'Marcos Lima', 'marcos.lima@yahoo.com', '+55 555555566', 'Rua LL, 101', 'Homem Cis', 'Branco', 'Marquinhos'),
(DEFAULT, 1, 'Robson Oliveira', 'robson.oliveira@gmail.com', '+55 987654333', 'Rua MM, 567', 'Homem Cis', 'Negro', 'Robsonzinho'),
(DEFAULT, 5, 'Leticia Lima', 'leticia.lima@outlook.com', '+55 111223356', 'Rua NN, 789', 'Mulher Cis', 'Pardo', 'Letícia'),
(DEFAULT, 5, 'Diego Santos', 'diego.santos@yahoo.com', '+55 555555567', 'Rua OO, 101', 'Homem Cis', 'Branco', 'Diegão'),
(DEFAULT, 5, 'Tatiane Oliveira', 'tatiane.oliveira@gmail.com', '+55 987654334', 'Rua PP, 567', 'Mulher Cis', 'Negro', 'Tati'),
(DEFAULT, 5, 'Rafael Lima', 'rafael.lima@outlook.com', '+55 111223357', 'Rua QQ, 789', 'Homem Cis', 'Pardo', 'Rafa'),
(DEFAULT, 5, 'Viviane Santos', 'viviane.santos@yahoo.com', '+55 555555568', 'Rua RR, 101', 'Mulher Cis', 'Branco', 'Vivi'),
(DEFAULT, 5, 'Marcio Oliveira', 'marcio.oliveira@gmail.com', '+55 987654335', 'Rua SS, 567', 'Homem Cis', 'Negro', 'Marcinho'),
(DEFAULT, 5, 'Fernanda Lima', 'fernanda.lima@outlook.com', '+55 111223358', 'Rua TT, 789', 'Mulher Cis', 'Pardo', 'Fê'),
(DEFAULT, 5, 'Vinicius Santos', 'vinicius.santos@yahoo.com', '+55 555555569', 'Rua UU, 101', 'Homem Cis', 'Branco', 'Vini'),
(DEFAULT, 5, 'Talita Oliveira', 'talita.oliveira@gmail.com', '+55 987654336', 'Rua VV, 567', 'Mulher Cis', 'Negro', 'Tali'),
(DEFAULT, 2, 'Adriano Lima', 'adriano.lima@outlook.com', '+55 111223359', 'Rua WW, 789', 'Homem Cis', 'Pardo', 'Adri'),
(DEFAULT, 3, 'Vanessa Santos', 'vanessa.santos@yahoo.com', '+55 555555570', 'Rua XX, 101', 'Mulher Cis', 'Branco', 'Van'),
(DEFAULT, 1, 'Rodrigo Oliveira', 'rodrigo.oliveira@gmail.com', '+55 987654337', 'Rua YY, 567', 'Homem Cis', 'Negro', 'Rodrigo'),
(DEFAULT, 2, 'Carolina Lima', 'carolina.lima@outlook.com', '+55 111223360', 'Rua ZZ, 789', 'Mulher Cis', 'Pardo', 'Carol'),
(DEFAULT, 5, 'Lucas Santos', 'lucas.santos@yahoo.com', '+55 555555571', 'Rua AAA, 101', 'Homem Cis', 'Branco', 'Lu'),
(DEFAULT, 5, 'Amanda Oliveira', 'amanda.oliveira@gmail.com', '+55 987654338', 'Rua BBB, 567', 'Mulher Cis', 'Negro', 'Amandinha'),
(DEFAULT, 5, 'Gabriel Lima', 'gabriel.lima@outlook.com', '+55 111223361', 'Rua CCC, 789', 'Homem Cis', 'Pardo', 'Gabi'),
(DEFAULT, 5, 'Isaac Santos', 'isaac.santos@yahoo.com', '+55 555555572', 'Rua DDD, 101', 'Homem Cis', 'Branco', 'Isa');

INSERT INTO artistapf (idArtista, CPF) VALUES
(1, '12345678901'),
(2, '23456789012'),
(3, '34567890123'),
(4, '45678901234'),
(5, '56789012345'),
(6, '67890123456'),
(7, '78901234567'),
(8, '89012345678'),
(9, '90123456789'),
(10, '98765432101');

INSERT INTO artistapj (idArtista, cnpj) VALUES 
(11, '11223344556677'),
(12, '22334455667788'),
(13, '33445566778899'),
(14, '44556677889900'),
(15, '55667788990011'),
(16, '66778899001122'),
(17, '77889900112233'),
(18, '88990011223344'),
(19, '99001122334455'),
(20, '11122233344455'),
(21, '22233344455566'),
(22, '33344455566677'),
(23, '44455566677788'),
(24, '55566677788899'),
(25, '66677788899900'),
(26, '77788899900011'),
(27, '88899900011122'),
(28, '99900011122233'),
(29, '11122233344444'),
(30, '22233344455555'),
(31, '33344455566666'),
(32, '44455566677777'),
(33, '55566677788888'),
(34, '66677788899999'),
(35, '77788899900000'),
(36, '88899900011111'),
(37, '99900011122222'),
(38, '11122233344433'),
(39, '22233344455544'),
(40, '33344455566655'),
(41, '44455566677766'),
(42, '55566677788877'),
(43, '66677788899988'),
(44, '77788899900099'),
(45, '88899900011100'),
(46, '99900011122211'),
(47, '11122233344422'),
(48, '22233344455533'),
(49, '33344455566644'),
(50, '44455566677755'),
(51, '55566677788866'),
(52, '66677788899977'),
(53, '77788899900088'),
(54, '88899900011199'),
(55, '99900011122200'),
(56, '12345678901234');

INSERT INTO grupo (idGrupo, tipoLing) VALUES 
(DEFAULT, 1),
(DEFAULT, 2),
(DEFAULT, 3),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 5),
(DEFAULT, 5),
(DEFAULT, 3),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 5),
(DEFAULT, 2),
(DEFAULT, 3),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 1),
(DEFAULT, 2),
(DEFAULT, 5),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 1),
(DEFAULT, 5),
(DEFAULT, 3),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 1),
(DEFAULT, 2),
(DEFAULT, 5),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 1),
(DEFAULT, 2),
(DEFAULT, 3),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 1),
(DEFAULT, 2),
(DEFAULT, 5),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 1),
(DEFAULT, 2),
(DEFAULT, 3),
(DEFAULT, 5),
(DEFAULT, 4),
(DEFAULT, 1),
(DEFAULT, 2),
(DEFAULT, 5),
(DEFAULT, 5),
(DEFAULT, 4);

INSERT INTO participacao (idArtista, idGrupo, funcao) VALUES 
(1, 1, 'Dançarino'),
(2, 2, 'Ator'),
(3, 3, 'Palestrante'),
(4, 1, 'Cantor'),
(5, 4, 'DJ'),
(6, 4, 'MC'),
(7, 3, 'Brincante'),
(8, 5, 'Instrumentista'),
(9, 6, 'Iluminador'),
(10, 7, 'Cantor'),
(11, 8, 'Dançarino'),
(12, 9, 'Ator'),
(13, 10, 'Cantor'),
(14, 11, 'Instrumentista'),
(15, 12, 'Brincante'),
(16, 13, 'DJ'),
(17, 14, 'MC'),
(18, 15, 'Ator'),
(19, 16, 'Dançarino'),
(20, 17, 'Instrumentista'),
(21, 18, 'Cantor'),
(22, 19, 'Iluminador'),
(23, 20, 'MC'),
(24, 21, 'Brincante'),
(25, 22, 'Dançarino'),
(26, 23, 'Cantor'),
(27, 24, 'Instrumentista'),
(28, 25, 'Ator'),
(29, 26, 'DJ'),
(30, 27, 'Brincante'),
(31, 28, 'Iluminador'),
(32, 29, 'Cantor'),
(33, 30, 'Ator'),
(34, 31, 'MC'),
(35, 32, 'Instrumentista'),
(36, 33, 'Dançarino'),
(37, 34, 'Cantor'),
(38, 35, 'DJ'),
(39, 36, 'Iluminador'),
(40, 37, 'Ator'),
(41, 38, 'Instrumentista'),
(42, 39, 'Brincante'),
(43, 40, 'Cantor'),
(44, 41, 'Dançarino'),
(45, 42, 'Ator'),
(46, 43, 'MC'),
(47, 44, 'Instrumentista'),
(48, 45, 'DJ'),
(49, 46, 'Cantor'),
(50, 47, 'Brincante'),
(51, 48, 'Ator'),
(52, 49, 'MC'),
(53, 50, 'Iluminador'),
(54, 1, 'Instrumentista'),
(55, 2, 'Cantor'),
(56, 3, 'Ator');

INSERT INTO contratoevento (idContrato, idEvento, idCasa, idGrupo, dataContrato) VALUES 
(DEFAULT, 1, 4, 1, '2023-01-10'),
(DEFAULT, 2, 1, 2, '2023-06-12'),
(DEFAULT, 3, 5, 3, '2023-09-20'),
(DEFAULT, 4, 3, 4, '2023-10-15'),
(DEFAULT, 5, 2, 5, '2023-11-18'),
(DEFAULT, 6, 7, 6, '2023-02-05'),
(DEFAULT, 7, 9, 7, '2023-03-15'),
(DEFAULT, 8, 11, 8, '2023-04-20'),
(DEFAULT, 9, 13, 9, '2023-07-01'),
(DEFAULT, 10, 15, 10, '2023-08-10'),
(DEFAULT, 11, 17, 11, '2023-11-05'),
(DEFAULT, 12, 19, 12, '2023-12-25'),
(DEFAULT, 13, 1, 13, '2023-05-30'),
(DEFAULT, 14, 3, 14, '2023-09-10'),
(DEFAULT, 15, 5, 15, '2023-10-31'),
(DEFAULT, 16, 8, 16, '2023-02-15'),
(DEFAULT, 17, 10, 17, '2023-04-05'),
(DEFAULT, 18, 12, 18, '2023-06-20'),
(DEFAULT, 19, 14, 19, '2023-08-01'),
(DEFAULT, 20, 16, 20, '2023-12-10'),
(DEFAULT, 21, 18, 21, '2023-03-25'),
(DEFAULT, 22, 2, 22, '2023-05-05'),
(DEFAULT, 23, 4, 23, '2023-07-15'),
(DEFAULT, 24, 6, 24, '2023-09-28'),
(DEFAULT, 25, 8, 25, '2023-11-10'),
(DEFAULT, 26, 10, 26, '2023-01-15'),
(DEFAULT, 27, 12, 27, '2023-04-01'),
(DEFAULT, 28, 14, 28, '2023-06-15'),
(DEFAULT, 29, 16, 29, '2023-08-30'),
(DEFAULT, 30, 18, 30, '2023-10-20'),
(DEFAULT, 31, 1, 31, '2023-02-28'),
(DEFAULT, 32, 3, 32, '2023-05-10'),
(DEFAULT, 33, 5, 33, '2023-07-25'),
(DEFAULT, 34, 7, 34, '2023-09-10'),
(DEFAULT, 35, 9, 35, '2023-11-15'),
(DEFAULT, 36, 11, 36, '2023-01-01'),
(DEFAULT, 37, 13, 37, '2023-03-18'),
(DEFAULT, 38, 15, 38, '2023-05-03'),
(DEFAULT, 39, 17, 39, '2023-08-18'),
(DEFAULT, 40, 19, 40, '2023-10-01'),
(DEFAULT, 41, 2, 41, '2023-12-15'),
(DEFAULT, 42, 4, 42, '2023-02-10'),
(DEFAULT, 43, 6, 43, '2023-04-25'),
(DEFAULT, 44, 8, 44, '2023-06-10'),
(DEFAULT, 45, 10, 45, '2023-09-01'),
(DEFAULT, 46, 12, 46, '2023-10-30'),
(DEFAULT, 47, 14, 47, '2023-12-05'),
(DEFAULT, 48, 16, 48, '2023-03-20'),
(DEFAULT, 49, 18, 49, '2023-05-05'),
(DEFAULT, 50, 1, 50, '2023-07-18');

INSERT INTO pagamento (idPagamento, idContrato, valorPag, dataAgendado, dataEfetivada) VALUES 
(DEFAULT, 1, 4500.00,'2023-02-01', '2023-02-01 15:30:00'),
(DEFAULT, 2, 1500.00,'2023-07-03', '2023-07-03 14:45:00'),
(DEFAULT, 3, 8000.00,'2023-10-01', '2023-10-01 16:15:00'),
(DEFAULT, 4, 12500.00,'2023-10-28', '2023-10-28 13:20:00'),
(DEFAULT, 5, 10000.00,'2023-11-30', '2023-11-30 17:00:00'),
(DEFAULT, 6, 5500.00, '2023-01-15', '2023-01-15 15:30:00'),
(DEFAULT, 7, 9200.00, '2023-02-03', '2023-02-03 14:45:00'),
(DEFAULT, 8, 3800.00, '2023-03-10', '2023-03-10 16:15:00'),
(DEFAULT, 9, 6700.00, '2023-04-05', '2023-04-05 13:20:00'),
(DEFAULT, 10, 8600.00, '2023-05-20', '2023-05-20 17:00:00'),
(DEFAULT, 11, 10500.00, '2023-06-28', '2023-06-28 09:45:00'),
(DEFAULT, 12, 2300.00, '2023-07-15', '2023-07-15 12:30:00'),
(DEFAULT, 13, 7200.00, '2023-08-14', '2023-08-14 18:20:00'),
(DEFAULT, 14, 4200.00, '2023-09-02', '2023-09-02 10:00:00'),
(DEFAULT, 15, 9500.00, '2023-10-25', '2023-10-25 16:45:00'),
(DEFAULT, 16, 6000.00, '2023-11-18', '2023-11-18 11:30:00'),
(DEFAULT, 17, 7100.00, '2023-12-10', '2023-12-10 14:15:00'),
(DEFAULT, 18, 7800.00, '2023-07-05', '2023-07-05 15:30:00'),
(DEFAULT, 19, 3300.00, '2023-08-17', '2023-08-17 14:45:00'),
(DEFAULT, 20, 5200.00, '2023-09-01', '2023-09-01 16:15:00'),
(DEFAULT, 21, 7800.00, '2023-12-07', '2023-12-07 15:30:00'),
(DEFAULT, 22, 9800.00, '2023-12-20', '2023-12-20 14:45:00'),
(DEFAULT, 23, 4600.00,'2023-11-01', '2023-11-01 15:00:00'),
(DEFAULT, 24, 6700.00,'2023-11-18', '2023-11-18 13:35:00'),
(DEFAULT, 25, 7200.00,'2023-12-07', '2023-12-07 19:55:00'),
(DEFAULT, 26, 9800.00,'2023-12-20', '2023-12-20 14:15:00'),
(DEFAULT, 27, 5400.00,'2023-01-02', '2023-01-02 17:40:00'),
(DEFAULT, 28, 6700.00,'2023-01-18', '2023-01-18 15:25:00'),
(DEFAULT, 29, 8800.00,'2023-02-05', '2023-02-05 13:50:00'),
(DEFAULT, 30, 4200.00,'2023-02-22', '2023-02-22 11:30:00'),
(DEFAULT, 31, 7600.00,'2023-03-10', '2023-03-10 20:05:00'),
(DEFAULT, 32, 6300.00,'2023-03-25', '2023-03-25 17:20:00'),
(DEFAULT, 33, 4700.00,'2023-04-11', '2023-04-11 15:00:00'),
(DEFAULT, 34, 9000.00,'2023-04-28', '2023-04-28 13:35:00'),
(DEFAULT, 35, 3200.00,'2023-05-15', '2023-05-15 19:55:00'),
(DEFAULT, 36, 5800.00,'2023-06-01', '2023-06-01 14:15:00'),
(DEFAULT, 37, 4900.00,'2023-06-17', '2023-06-17 17:40:00'),
(DEFAULT, 38, 7200.00,'2023-07-04', '2023-07-04 15:25:00'),
(DEFAULT, 39, 6600.00,'2023-07-21', '2023-07-21 13:50:00'),
(DEFAULT, 40, 8700.00,'2023-08-07', '2023-08-07 11:30:00'),
(DEFAULT, 41, 4100.00,'2023-08-24', '2023-08-24 20:05:00'),
(DEFAULT, 42, 7500.00,'2023-09-10', '2023-09-10 17:20:00'),
(DEFAULT, 43, 6300.00,'2023-09-27', '2023-09-27 15:00:00'),
(DEFAULT, 44, 5200.00,'2023-10-14', '2023-10-14 13:35:00'),
(DEFAULT, 45, 9000.00,'2023-10-31', '2023-10-31 19:55:00'),
(DEFAULT, 46, 3400.00,'2023-11-16', '2023-11-16 14:15:00'),
(DEFAULT, 47, 4800.00,'2023-12-03', '2023-12-03 17:40:00'),
(DEFAULT, 48, 7100.00,'2023-12-20', '2023-12-20 15:25:00'),
(DEFAULT, 49, 6500.00,'2023-12-27', '2023-12-27 13:50:00'),
(DEFAULT, 50, 8600.00,'2023-12-30', '2023-12-30 11:30:00');

/*--SELECTS GERAL
SELECT * FROM artista;
SELECT * FROM artistapf;
SELECT * FROM artistapj;
SELECT * FROM casacultura;
SELECT * FROM contratoevento;
SELECT * FROM evento;
SELECT * FROM grupo;
SELECT * FROM linguagem;
SELECT * FROM pagamento;
SELECT * FROM participacao;
SELECT * FROM porte;
*/

/*SELECTS Caso de Uso
--Quantidade de artistas contratatos(3 FORMAS DE SE EXECUTAR A CONSULTA)
SELECT COUNT(*) AS qtdArtistas FROM artista;

SELECT COUNT(idartista) AS qtdArtistas FROM participacao;

SELECT COUNT(p.idArtista) AS qtdArtistas 
FROM participacao p INNER JOIN grupo g
	ON p.idgrupo = g.idgrupo
INNER JOIN contratoevento ct
	ON p.idgrupo = ct.idgrupo;

--Pessoas por etnia
SELECT COUNT(*) AS qtdPessoas, a.etnia FROM Artista a
GROUP BY a.etnia
ORDER BY COUNT(*) DESC, a.etnia;

--Pessoas por genero
SELECT COUNT(a.genero) AS qtdPessoas, a.genero FROM Artista a
GROUP BY a.genero
ORDER BY COUNT(a.genero) DESC;

--Valor das Contratações por mês
SELECT EXTRACT(MONTH FROM ce.datacontrato) AS Mes, SUM(p.valorpag) AS Valor_Total_Mes 
FROM contratoevento ce INNER JOIN pagamento p
	ON p.idcontrato = ce.idcontrato
GROUP BY EXTRACT(MONTH FROM ce.datacontrato)
ORDER BY EXTRACT(MONTH FROM ce.datacontrato);

-- Total e Media investido por região das Casas de Cultura
SELECT COUNT(p.idpagamento) as qtde_eventos,ROUND(AVG(p.valorpag),2) as valor_medio,SUM(p.valorpag) AS total_investido,cc.regiao 
FROM contratoevento c
INNER JOIN casacultura cc ON c.idcasa = cc.idcasa
INNER JOIN pagamento p ON c.idcontrato = p.idcontrato
GROUP BY cc.regiao
ORDER BY qtde_eventos DESC;

-- Total e Media investido Separados por linguagem
SELECT COUNT(p.idpagamento) as qtde_eventos, ROUND(AVG(p.valorpag),2) as valor_medio,SUM(p.valorpag) as valor_total,l.tipo AS linguagem 
FROM contratoevento cc 
INNER JOIN grupo g ON g.idgrupo = cc.idgrupo
INNER JOIN pagamento p ON cc.idcontrato = p.idcontrato
INNER JOIN linguagem l ON l.idlinguagem = g.tipoling
GROUP BY l.tipo
ORDER BY qtde_eventos DESC;
*/