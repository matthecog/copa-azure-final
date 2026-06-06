-- =====================================================
-- Migration: 32 jogos do mata-mata FIFA 2026 (datas/horarios em BRASILIA / BRT, sedes oficiais)
-- (R32: 73-88, R16: 89-96, QF: 97-100, SF: 101-102, 3o: 103, Final: 104)
-- Times ficam NULL (preenchidos pelo /api/bracket). Fonte: Wikipedia (local+offset) -> BRT.
-- Ordem dos VALUES = M73..M104. Idempotente: skip se ja existe stage='round_of_32'.
-- =====================================================
IF NOT EXISTS (SELECT 1 FROM dbo.matches WHERE stage = 'round_of_32')
BEGIN
  INSERT INTO dbo.matches (home_team_id, away_team_id, stadium_id, date, time, stage, group_name, status)
  VALUES
    (NULL, NULL, 3, '2026-06-28', '16:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 11, '2026-06-29', '17:30', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 7, '2026-06-29', '22:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 14, '2026-06-29', '14:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 1, '2026-06-30', '18:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 2, '2026-06-30', '14:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 6, '2026-06-30', '22:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 10, '2026-07-01', '13:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 16, '2026-07-01', '21:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 5, '2026-07-01', '17:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 9, '2026-07-02', '20:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 3, '2026-07-02', '16:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 8, '2026-07-03', '00:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 12, '2026-07-03', '19:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 15, '2026-07-03', '22:30', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 2, '2026-07-03', '15:00', 'round_of_32', NULL, 'scheduled'),
    (NULL, NULL, 13, '2026-07-04', '18:00', 'round_of_16', NULL, 'scheduled'),
    (NULL, NULL, 14, '2026-07-04', '14:00', 'round_of_16', NULL, 'scheduled'),
    (NULL, NULL, 1, '2026-07-05', '17:00', 'round_of_16', NULL, 'scheduled'),
    (NULL, NULL, 6, '2026-07-05', '21:00', 'round_of_16', NULL, 'scheduled'),
    (NULL, NULL, 2, '2026-07-06', '16:00', 'round_of_16', NULL, 'scheduled'),
    (NULL, NULL, 5, '2026-07-06', '21:00', 'round_of_16', NULL, 'scheduled'),
    (NULL, NULL, 10, '2026-07-07', '13:00', 'round_of_16', NULL, 'scheduled'),
    (NULL, NULL, 8, '2026-07-07', '17:00', 'round_of_16', NULL, 'scheduled'),
    (NULL, NULL, 11, '2026-07-09', '17:00', 'quarter_final', NULL, 'scheduled'),
    (NULL, NULL, 3, '2026-07-10', '16:00', 'quarter_final', NULL, 'scheduled'),
    (NULL, NULL, 12, '2026-07-11', '18:00', 'quarter_final', NULL, 'scheduled'),
    (NULL, NULL, 15, '2026-07-11', '22:00', 'quarter_final', NULL, 'scheduled'),
    (NULL, NULL, 2, '2026-07-14', '16:00', 'semi_final', NULL, 'scheduled'),
    (NULL, NULL, 10, '2026-07-15', '16:00', 'semi_final', NULL, 'scheduled'),
    (NULL, NULL, 12, '2026-07-18', '18:00', 'third_place', NULL, 'scheduled'),
    (NULL, NULL, 1, '2026-07-19', '16:00', 'final', NULL, 'scheduled');
END
GO

SELECT stage, COUNT(*) AS n FROM dbo.matches WHERE stage IN ('round_of_32','round_of_16','quarter_final','semi_final','third_place','final') GROUP BY stage;
PRINT 'Esperado: R32=16, R16=8, QF=4, SF=2, 3rd=1, Final=1.';
GO
