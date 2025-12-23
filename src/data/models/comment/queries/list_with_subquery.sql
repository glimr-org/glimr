-- Find comments by users who have more than N comments
SELECT c.id, c.body, c.user_id, c.created_at
FROM comments c
WHERE c.user_id IN (
    SELECT user_id
    FROM comments
    GROUP BY user_id
    HAVING COUNT(*) > $1
)
ORDER BY c.created_at DESC
