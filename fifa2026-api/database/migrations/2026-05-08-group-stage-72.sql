-- Migration: 72 jogos da fase de grupos FIFA 2026 (horario de BRASILIA / BRT)
-- Fonte: Wikipedia (local+offset) -> BRT. team_id/stadium_id conferidos contra o banco live.
-- Reaproveita IDs 1-12 (UPDATE) e insere 60. Para banco JA populado use scripts/fix-group-stage-brt-apply.sql
SET NOCOUNT ON;

UPDATE dbo.matches SET
  home_team_id = 2, away_team_id = 17, stadium_id = 6,
  date = '2026-06-11', time = '16:00', stage = 'Fase de Grupos', group_name = 'A',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 1;
UPDATE dbo.matches SET
  home_team_id = 18, away_team_id = 19, stadium_id = 17,
  date = '2026-06-11', time = '23:00', stage = 'Fase de Grupos', group_name = 'A',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 2;
UPDATE dbo.matches SET
  home_team_id = 19, away_team_id = 17, stadium_id = 10,
  date = '2026-06-18', time = '13:00', stage = 'Fase de Grupos', group_name = 'A',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 3;
UPDATE dbo.matches SET
  home_team_id = 2, away_team_id = 18, stadium_id = 17,
  date = '2026-06-18', time = '22:00', stage = 'Fase de Grupos', group_name = 'A',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 4;
UPDATE dbo.matches SET
  home_team_id = 19, away_team_id = 2, stadium_id = 6,
  date = '2026-06-24', time = '22:00', stage = 'Fase de Grupos', group_name = 'A',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 5;
UPDATE dbo.matches SET
  home_team_id = 17, away_team_id = 18, stadium_id = 7,
  date = '2026-06-24', time = '22:00', stage = 'Fase de Grupos', group_name = 'A',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 6;
UPDATE dbo.matches SET
  home_team_id = 3, away_team_id = 20, stadium_id = 9,
  date = '2026-06-12', time = '16:00', stage = 'Fase de Grupos', group_name = 'B',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 7;
UPDATE dbo.matches SET
  home_team_id = 21, away_team_id = 22, stadium_id = 16,
  date = '2026-06-13', time = '16:00', stage = 'Fase de Grupos', group_name = 'B',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 8;
UPDATE dbo.matches SET
  home_team_id = 22, away_team_id = 20, stadium_id = 3,
  date = '2026-06-18', time = '16:00', stage = 'Fase de Grupos', group_name = 'B',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 9;
UPDATE dbo.matches SET
  home_team_id = 3, away_team_id = 21, stadium_id = 8,
  date = '2026-06-18', time = '19:00', stage = 'Fase de Grupos', group_name = 'B',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 10;
UPDATE dbo.matches SET
  home_team_id = 22, away_team_id = 3, stadium_id = 8,
  date = '2026-06-24', time = '16:00', stage = 'Fase de Grupos', group_name = 'B',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 11;
UPDATE dbo.matches SET
  home_team_id = 20, away_team_id = 21, stadium_id = 5,
  date = '2026-06-24', time = '16:00', stage = 'Fase de Grupos', group_name = 'B',
  status = 'scheduled', home_score = NULL, away_score = NULL
WHERE id = 12;

INSERT INTO dbo.matches (home_team_id, away_team_id, stadium_id, date, time, stage, group_name, status)
VALUES
  (5, 12, 1, '2026-06-13', '19:00', 'Fase de Grupos', 'C', 'scheduled'),
  (29, 30, 11, '2026-06-13', '22:00', 'Fase de Grupos', 'C', 'scheduled'),
  (30, 12, 11, '2026-06-19', '19:00', 'Fase de Grupos', 'C', 'scheduled'),
  (5, 29, 13, '2026-06-19', '21:30', 'Fase de Grupos', 'C', 'scheduled'),
  (30, 5, 12, '2026-06-24', '19:00', 'Fase de Grupos', 'C', 'scheduled'),
  (12, 29, 10, '2026-06-24', '19:00', 'Fase de Grupos', 'C', 'scheduled'),
  (1, 23, 3, '2026-06-12', '22:00', 'Fase de Grupos', 'D', 'scheduled'),
  (24, 25, 8, '2026-06-14', '01:00', 'Fase de Grupos', 'D', 'scheduled'),
  (1, 24, 5, '2026-06-19', '16:00', 'Fase de Grupos', 'D', 'scheduled'),
  (25, 23, 16, '2026-06-20', '00:00', 'Fase de Grupos', 'D', 'scheduled'),
  (25, 1, 3, '2026-06-25', '23:00', 'Fase de Grupos', 'D', 'scheduled'),
  (23, 24, 16, '2026-06-25', '23:00', 'Fase de Grupos', 'D', 'scheduled'),
  (27, 28, 13, '2026-06-14', '20:00', 'Fase de Grupos', 'E', 'scheduled'),
  (7, 26, 14, '2026-06-14', '14:00', 'Fase de Grupos', 'E', 'scheduled'),
  (7, 27, 9, '2026-06-20', '17:00', 'Fase de Grupos', 'E', 'scheduled'),
  (28, 26, 15, '2026-06-20', '21:00', 'Fase de Grupos', 'E', 'scheduled'),
  (26, 27, 13, '2026-06-25', '17:00', 'Fase de Grupos', 'E', 'scheduled'),
  (28, 7, 1, '2026-06-25', '17:00', 'Fase de Grupos', 'E', 'scheduled'),
  (14, 8, 2, '2026-06-14', '17:00', 'Fase de Grupos', 'F', 'scheduled'),
  (31, 32, 7, '2026-06-14', '23:00', 'Fase de Grupos', 'F', 'scheduled'),
  (14, 31, 14, '2026-06-20', '14:00', 'Fase de Grupos', 'F', 'scheduled'),
  (32, 8, 7, '2026-06-21', '01:00', 'Fase de Grupos', 'F', 'scheduled'),
  (8, 31, 2, '2026-06-25', '20:00', 'Fase de Grupos', 'F', 'scheduled'),
  (32, 14, 15, '2026-06-25', '20:00', 'Fase de Grupos', 'F', 'scheduled'),
  (35, 36, 3, '2026-06-15', '22:00', 'Fase de Grupos', 'G', 'scheduled'),
  (33, 34, 5, '2026-06-15', '16:00', 'Fase de Grupos', 'G', 'scheduled'),
  (33, 35, 3, '2026-06-21', '16:00', 'Fase de Grupos', 'G', 'scheduled'),
  (36, 34, 8, '2026-06-21', '22:00', 'Fase de Grupos', 'G', 'scheduled'),
  (34, 35, 5, '2026-06-27', '00:00', 'Fase de Grupos', 'G', 'scheduled'),
  (36, 33, 8, '2026-06-27', '00:00', 'Fase de Grupos', 'G', 'scheduled'),
  (44, 16, 12, '2026-06-15', '19:00', 'Fase de Grupos', 'H', 'scheduled'),
  (10, 43, 10, '2026-06-15', '13:00', 'Fase de Grupos', 'H', 'scheduled'),
  (16, 43, 12, '2026-06-21', '19:00', 'Fase de Grupos', 'H', 'scheduled'),
  (10, 44, 10, '2026-06-21', '13:00', 'Fase de Grupos', 'H', 'scheduled'),
  (43, 44, 14, '2026-06-26', '21:00', 'Fase de Grupos', 'H', 'scheduled'),
  (16, 10, 17, '2026-06-26', '21:00', 'Fase de Grupos', 'H', 'scheduled'),
  (9, 37, 1, '2026-06-16', '16:00', 'Fase de Grupos', 'I', 'scheduled'),
  (38, 39, 11, '2026-06-16', '19:00', 'Fase de Grupos', 'I', 'scheduled'),
  (9, 38, 13, '2026-06-22', '18:00', 'Fase de Grupos', 'I', 'scheduled'),
  (39, 37, 1, '2026-06-22', '21:00', 'Fase de Grupos', 'I', 'scheduled'),
  (39, 9, 11, '2026-06-26', '16:00', 'Fase de Grupos', 'I', 'scheduled'),
  (37, 38, 9, '2026-06-26', '16:00', 'Fase de Grupos', 'I', 'scheduled'),
  (6, 42, 15, '2026-06-16', '22:00', 'Fase de Grupos', 'J', 'scheduled'),
  (40, 41, 16, '2026-06-17', '01:00', 'Fase de Grupos', 'J', 'scheduled'),
  (6, 40, 2, '2026-06-22', '14:00', 'Fase de Grupos', 'J', 'scheduled'),
  (41, 42, 16, '2026-06-23', '00:00', 'Fase de Grupos', 'J', 'scheduled'),
  (42, 40, 15, '2026-06-27', '23:00', 'Fase de Grupos', 'J', 'scheduled'),
  (41, 6, 2, '2026-06-27', '23:00', 'Fase de Grupos', 'J', 'scheduled'),
  (11, 46, 14, '2026-06-17', '14:00', 'Fase de Grupos', 'K', 'scheduled'),
  (45, 4, 6, '2026-06-17', '23:00', 'Fase de Grupos', 'K', 'scheduled'),
  (11, 45, 14, '2026-06-23', '14:00', 'Fase de Grupos', 'K', 'scheduled'),
  (4, 46, 17, '2026-06-23', '23:00', 'Fase de Grupos', 'K', 'scheduled'),
  (4, 11, 12, '2026-06-27', '20:30', 'Fase de Grupos', 'K', 'scheduled'),
  (46, 45, 10, '2026-06-27', '20:30', 'Fase de Grupos', 'K', 'scheduled'),
  (13, 47, 2, '2026-06-17', '17:00', 'Fase de Grupos', 'L', 'scheduled'),
  (48, 49, 9, '2026-06-17', '20:00', 'Fase de Grupos', 'L', 'scheduled'),
  (13, 48, 11, '2026-06-23', '17:00', 'Fase de Grupos', 'L', 'scheduled'),
  (49, 47, 9, '2026-06-23', '20:00', 'Fase de Grupos', 'L', 'scheduled'),
  (49, 13, 1, '2026-06-27', '18:00', 'Fase de Grupos', 'L', 'scheduled'),
  (47, 48, 13, '2026-06-27', '18:00', 'Fase de Grupos', 'L', 'scheduled');

SELECT COUNT(*) AS total_grupos FROM dbo.matches WHERE stage = 'Fase de Grupos';
PRINT 'Esperado: 72 jogos, 6 por grupo.';
