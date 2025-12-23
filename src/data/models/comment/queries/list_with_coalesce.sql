-- Comments with COALESCE and string concatenation
SELECT
    c.id,
    COALESCE(c.body, 'No content') AS body,
    u.name || ' (' || u.email || ')' AS author_info,
    c.created_at
FROM comments c
INNER JOIN users u ON u.id = c.user_id
WHERE c.post_id = $1
