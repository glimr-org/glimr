-- Comments within a date range
SELECT c.id, c.body, c.user_id, c.created_at
FROM comments c
WHERE c.created_at BETWEEN $1 AND $2
ORDER BY c.created_at DESC
