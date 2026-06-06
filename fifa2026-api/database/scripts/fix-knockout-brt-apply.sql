-- ============================================================
-- APPLY (auto-commit) -- mata-mata: datas/horarios (BRT) e sedes oficiais
-- Atualiza os 32 jogos de mata-mata existentes por ROW_NUMBER(ORDER BY id) -> M73..M104.
-- Resolve stadium_id por NOME (robusto a diferencas de id). Times permanecem como estao.
-- Valida 32 jogos e que toda sede resolveu; SO comita se passar (XACT_ABORT + rollback).
-- ============================================================
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRAN;

IF (SELECT COUNT(*) FROM dbo.matches WHERE stage IN ('round_of_32','round_of_16','quarter_final','semi_final','third_place','final')) <> 32
BEGIN RAISERROR('Pre-check: nao ha 32 jogos de mata-mata.',16,1); ROLLBACK TRAN; RETURN; END;

DECLARE @k TABLE (rn INT, [date] DATE, [time] NVARCHAR(5), stad_like NVARCHAR(50));
INSERT INTO @k (rn,[date],[time],stad_like) VALUES
(1, '2026-06-28', '16:00', '%SoFi%'),
(2, '2026-06-29', '17:30', '%Gillette%'),
(3, '2026-06-29', '22:00', '%BBVA%'),
(4, '2026-06-29', '14:00', '%NRG%'),
(5, '2026-06-30', '18:00', '%MetLife%'),
(6, '2026-06-30', '14:00', '%AT&T%'),
(7, '2026-06-30', '22:00', '%Azteca%'),
(8, '2026-07-01', '13:00', '%Mercedes%'),
(9, '2026-07-01', '21:00', '%Levi%'),
(10, '2026-07-01', '17:00', '%Lumen%'),
(11, '2026-07-02', '20:00', '%BMO%'),
(12, '2026-07-02', '16:00', '%SoFi%'),
(13, '2026-07-03', '00:00', '%BC Place%'),
(14, '2026-07-03', '19:00', '%Hard Rock%'),
(15, '2026-07-03', '22:30', '%Arrowhead%'),
(16, '2026-07-03', '15:00', '%AT&T%'),
(17, '2026-07-04', '18:00', '%Lincoln%'),
(18, '2026-07-04', '14:00', '%NRG%'),
(19, '2026-07-05', '17:00', '%MetLife%'),
(20, '2026-07-05', '21:00', '%Azteca%'),
(21, '2026-07-06', '16:00', '%AT&T%'),
(22, '2026-07-06', '21:00', '%Lumen%'),
(23, '2026-07-07', '13:00', '%Mercedes%'),
(24, '2026-07-07', '17:00', '%BC Place%'),
(25, '2026-07-09', '17:00', '%Gillette%'),
(26, '2026-07-10', '16:00', '%SoFi%'),
(27, '2026-07-11', '18:00', '%Hard Rock%'),
(28, '2026-07-11', '22:00', '%Arrowhead%'),
(29, '2026-07-14', '16:00', '%AT&T%'),
(30, '2026-07-15', '16:00', '%Mercedes%'),
(31, '2026-07-18', '18:00', '%Hard Rock%'),
(32, '2026-07-19', '16:00', '%MetLife%');

;WITH cur AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
  FROM dbo.matches WHERE stage IN ('round_of_32','round_of_16','quarter_final','semi_final','third_place','final')
)
UPDATE m SET
  m.[date] = k.[date],
  m.[time] = k.[time],
  m.stadium_id = (SELECT TOP 1 id FROM dbo.stadiums WHERE name LIKE k.stad_like AND name NOT LIKE '%legacy%' ORDER BY id)
FROM dbo.matches m JOIN cur ON cur.id=m.id JOIN @k k ON k.rn=cur.rn;

-- Pos-check: nenhuma sede ficou NULL
IF EXISTS (SELECT 1 FROM dbo.matches WHERE stage IN ('round_of_32','round_of_16','quarter_final','semi_final','third_place','final') AND stadium_id IS NULL)
BEGIN RAISERROR('Pos-check: alguma sede nao resolveu (NULL).',16,1); ROLLBACK TRAN; RETURN; END;

COMMIT TRAN;
PRINT 'OK: 32 jogos do mata-mata atualizados (datas/horarios BRT + sedes) e commitados.';

SELECT m.[date], m.[time], m.stage, s.name AS sede
FROM dbo.matches m JOIN dbo.stadiums s ON s.id=m.stadium_id
WHERE m.stage IN ('round_of_32','round_of_16','quarter_final','semi_final','third_place','final')
ORDER BY m.[date], m.[time];
