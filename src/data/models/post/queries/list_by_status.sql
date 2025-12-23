-- List posts by status with author info
SELECT
    p.id,
    p.title,
    p.body,
    p.status,
    p.created_at,
    p.updated_at,
    u.name AS author_name
FROM posts p
INNER JOIN users u ON u.id = p.user_id
WHERE p.status = $1
ORDER BY p.created_at DESC
