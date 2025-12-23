-- List all comments for a specific post with author info
SELECT
    c.id,
    c.body,
    c.is_approved,
    c.created_at,
    c.updated_at,
    u.id AS author_id,
    u.name AS author_name
FROM comments c
INNER JOIN users u ON u.id = c.user_id
WHERE c.post_id = $1
ORDER BY c.created_at ASC
