-- Find comments that are either approved or by a specific user (UNION example)
SELECT id, body, user_id, is_approved, created_at
FROM comments
WHERE is_approved = 1

UNION ALL

SELECT id, body, user_id, is_approved, created_at
FROM comments
WHERE user_id = $1 AND is_approved = 0
