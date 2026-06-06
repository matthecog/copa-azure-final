-- ============================================================
-- APPLY (auto-commit) -- FASE DE GRUPOS -> horario de BRASILIA (BRT)
-- Resolve team_id por CODIGO e stadium_id por NOME (robusto a qualquer mapeamento de id).
-- Atribui os 72 jogos canonicos as 72 linhas por ROW_NUMBER(ORDER BY id), preservando id.
-- Valida: 72 jogos, 6/grupo, sem cross-grupo, sem time/sede NULL. SO comita se tudo passar.
-- ============================================================
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRAN;

IF (SELECT COUNT(*) FROM dbo.matches WHERE stage='Fase de Grupos') <> 72
BEGIN RAISERROR('Pre-check: nao ha 72 jogos de fase de grupos.',16,1); ROLLBACK TRAN; RETURN; END;

DECLARE @canon TABLE (rn INT, home_code NVARCHAR(3), away_code NVARCHAR(3), stad_like NVARCHAR(50), [date] DATE, [time] NVARCHAR(5), group_name NVARCHAR(1));
INSERT INTO @canon (rn,home_code,away_code,stad_like,[date],[time],group_name) VALUES
(1, 'MEX', 'RSA', '%Azteca%', '2026-06-11', '16:00', 'A'),
(2, 'KOR', 'CZE', '%Akron%', '2026-06-11', '23:00', 'A'),
(3, 'CZE', 'RSA', '%Mercedes%', '2026-06-18', '13:00', 'A'),
(4, 'MEX', 'KOR', '%Akron%', '2026-06-18', '22:00', 'A'),
(5, 'CZE', 'MEX', '%Azteca%', '2026-06-24', '22:00', 'A'),
(6, 'RSA', 'KOR', '%BBVA%', '2026-06-24', '22:00', 'A'),
(7, 'CAN', 'BIH', '%BMO%', '2026-06-12', '16:00', 'B'),
(8, 'QAT', 'SUI', '%Levi%', '2026-06-13', '16:00', 'B'),
(9, 'SUI', 'BIH', '%SoFi%', '2026-06-18', '16:00', 'B'),
(10, 'CAN', 'QAT', '%BC Place%', '2026-06-18', '19:00', 'B'),
(11, 'SUI', 'CAN', '%BC Place%', '2026-06-24', '16:00', 'B'),
(12, 'BIH', 'QAT', '%Lumen%', '2026-06-24', '16:00', 'B'),
(13, 'BRA', 'MAR', '%MetLife%', '2026-06-13', '19:00', 'C'),
(14, 'HAI', 'SCO', '%Gillette%', '2026-06-13', '22:00', 'C'),
(15, 'SCO', 'MAR', '%Gillette%', '2026-06-19', '19:00', 'C'),
(16, 'BRA', 'HAI', '%Lincoln%', '2026-06-19', '21:30', 'C'),
(17, 'SCO', 'BRA', '%Hard Rock%', '2026-06-24', '19:00', 'C'),
(18, 'MAR', 'HAI', '%Mercedes%', '2026-06-24', '19:00', 'C'),
(19, 'USA', 'PAR', '%SoFi%', '2026-06-12', '22:00', 'D'),
(20, 'AUS', 'TUR', '%BC Place%', '2026-06-14', '01:00', 'D'),
(21, 'USA', 'AUS', '%Lumen%', '2026-06-19', '16:00', 'D'),
(22, 'TUR', 'PAR', '%Levi%', '2026-06-20', '00:00', 'D'),
(23, 'TUR', 'USA', '%SoFi%', '2026-06-25', '23:00', 'D'),
(24, 'PAR', 'AUS', '%Levi%', '2026-06-25', '23:00', 'D'),
(25, 'CIV', 'ECU', '%Lincoln%', '2026-06-14', '20:00', 'E'),
(26, 'GER', 'CUR', '%NRG%', '2026-06-14', '14:00', 'E'),
(27, 'GER', 'CIV', '%BMO%', '2026-06-20', '17:00', 'E'),
(28, 'ECU', 'CUR', '%Arrowhead%', '2026-06-20', '21:00', 'E'),
(29, 'CUR', 'CIV', '%Lincoln%', '2026-06-25', '17:00', 'E'),
(30, 'ECU', 'GER', '%MetLife%', '2026-06-25', '17:00', 'E'),
(31, 'NED', 'JPN', '%AT&T%', '2026-06-14', '17:00', 'F'),
(32, 'SWE', 'TUN', '%BBVA%', '2026-06-14', '23:00', 'F'),
(33, 'NED', 'SWE', '%NRG%', '2026-06-20', '14:00', 'F'),
(34, 'TUN', 'JPN', '%BBVA%', '2026-06-21', '01:00', 'F'),
(35, 'JPN', 'SWE', '%AT&T%', '2026-06-25', '20:00', 'F'),
(36, 'TUN', 'NED', '%Arrowhead%', '2026-06-25', '20:00', 'F'),
(37, 'IRN', 'NZL', '%SoFi%', '2026-06-15', '22:00', 'G'),
(38, 'BEL', 'EGY', '%Lumen%', '2026-06-15', '16:00', 'G'),
(39, 'BEL', 'IRN', '%SoFi%', '2026-06-21', '16:00', 'G'),
(40, 'NZL', 'EGY', '%BC Place%', '2026-06-21', '22:00', 'G'),
(41, 'EGY', 'IRN', '%Lumen%', '2026-06-27', '00:00', 'G'),
(42, 'NZL', 'BEL', '%BC Place%', '2026-06-27', '00:00', 'G'),
(43, 'KSA', 'URU', '%Hard Rock%', '2026-06-15', '19:00', 'H'),
(44, 'ESP', 'CPV', '%Mercedes%', '2026-06-15', '13:00', 'H'),
(45, 'URU', 'CPV', '%Hard Rock%', '2026-06-21', '19:00', 'H'),
(46, 'ESP', 'KSA', '%Mercedes%', '2026-06-21', '13:00', 'H'),
(47, 'CPV', 'KSA', '%NRG%', '2026-06-26', '21:00', 'H'),
(48, 'URU', 'ESP', '%Akron%', '2026-06-26', '21:00', 'H'),
(49, 'FRA', 'SEN', '%MetLife%', '2026-06-16', '16:00', 'I'),
(50, 'IRQ', 'NOR', '%Gillette%', '2026-06-16', '19:00', 'I'),
(51, 'FRA', 'IRQ', '%Lincoln%', '2026-06-22', '18:00', 'I'),
(52, 'NOR', 'SEN', '%MetLife%', '2026-06-22', '21:00', 'I'),
(53, 'NOR', 'FRA', '%Gillette%', '2026-06-26', '16:00', 'I'),
(54, 'SEN', 'IRQ', '%BMO%', '2026-06-26', '16:00', 'I'),
(55, 'ARG', 'ALG', '%Arrowhead%', '2026-06-16', '22:00', 'J'),
(56, 'AUT', 'JOR', '%Levi%', '2026-06-17', '01:00', 'J'),
(57, 'ARG', 'AUT', '%AT&T%', '2026-06-22', '14:00', 'J'),
(58, 'JOR', 'ALG', '%Levi%', '2026-06-23', '00:00', 'J'),
(59, 'ALG', 'AUT', '%Arrowhead%', '2026-06-27', '23:00', 'J'),
(60, 'JOR', 'ARG', '%AT&T%', '2026-06-27', '23:00', 'J'),
(61, 'POR', 'COD', '%NRG%', '2026-06-17', '14:00', 'K'),
(62, 'UZB', 'COL', '%Azteca%', '2026-06-17', '23:00', 'K'),
(63, 'POR', 'UZB', '%NRG%', '2026-06-23', '14:00', 'K'),
(64, 'COL', 'COD', '%Akron%', '2026-06-23', '23:00', 'K'),
(65, 'COL', 'POR', '%Hard Rock%', '2026-06-27', '20:30', 'K'),
(66, 'COD', 'UZB', '%Mercedes%', '2026-06-27', '20:30', 'K'),
(67, 'ENG', 'CRO', '%AT&T%', '2026-06-17', '17:00', 'L'),
(68, 'GHA', 'PAN', '%BMO%', '2026-06-17', '20:00', 'L'),
(69, 'ENG', 'GHA', '%Gillette%', '2026-06-23', '17:00', 'L'),
(70, 'PAN', 'CRO', '%BMO%', '2026-06-23', '20:00', 'L'),
(71, 'PAN', 'ENG', '%MetLife%', '2026-06-27', '18:00', 'L'),
(72, 'CRO', 'GHA', '%Lincoln%', '2026-06-27', '18:00', 'L');

;WITH cur AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
  FROM dbo.matches WHERE stage='Fase de Grupos'
)
UPDATE m SET
  m.home_team_id = (SELECT id FROM dbo.teams WHERE code = c.home_code),
  m.away_team_id = (SELECT id FROM dbo.teams WHERE code = c.away_code),
  m.stadium_id   = (SELECT TOP 1 id FROM dbo.stadiums WHERE name LIKE c.stad_like AND name NOT LIKE '%legacy%' ORDER BY id),
  m.[date] = c.[date], m.[time] = c.[time], m.group_name = c.group_name,
  m.status = 'scheduled', m.home_score = NULL, m.away_score = NULL
FROM dbo.matches m JOIN cur ON cur.id=m.id JOIN @canon c ON c.rn=cur.rn;

-- POS-CHECK 1: nenhum time/sede NULL (codigo/nome nao resolveu)
IF EXISTS (SELECT 1 FROM dbo.matches WHERE stage='Fase de Grupos' AND (home_team_id IS NULL OR away_team_id IS NULL OR stadium_id IS NULL))
BEGIN RAISERROR('Pos-check: codigo de time ou nome de sede nao resolveu (NULL).',16,1); ROLLBACK TRAN; RETURN; END;

-- POS-CHECK 2: 6 jogos por grupo
IF EXISTS (SELECT 1 FROM (SELECT group_name, COUNT(*) c FROM dbo.matches WHERE stage='Fase de Grupos' GROUP BY group_name) x WHERE x.c<>6)
BEGIN RAISERROR('Pos-check: algum grupo nao tem 6 jogos.',16,1); ROLLBACK TRAN; RETURN; END;

-- POS-CHECK 3: nenhum confronto cross-grupo
IF EXISTS (
  SELECT 1 FROM dbo.matches m
  JOIN dbo.teams th ON th.id=m.home_team_id
  JOIN dbo.teams ta ON ta.id=m.away_team_id
  WHERE m.stage='Fase de Grupos' AND (th.group_name<>m.group_name OR ta.group_name<>m.group_name))
BEGIN RAISERROR('Pos-check: existe confronto cross-grupo.',16,1); ROLLBACK TRAN; RETURN; END;

COMMIT TRAN;
PRINT 'OK: 72 jogos da fase de grupos corrigidos para BRT e commitados.';

SELECT m.[date], m.[time], th.code AS home, ta.code AS away, s.name AS sede, m.group_name AS grp
FROM dbo.matches m
JOIN dbo.teams th ON th.id=m.home_team_id
JOIN dbo.teams ta ON ta.id=m.away_team_id
JOIN dbo.stadiums s ON s.id=m.stadium_id
WHERE m.stage='Fase de Grupos' ORDER BY m.[date], m.[time];
