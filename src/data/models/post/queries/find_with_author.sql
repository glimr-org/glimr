-- Find a post with its author details
SELECT
    p.id,
    p.title,
    p.body,
    p.status,
    p.created_at,
    p.updated_at,
    u.id AS author_id,
    u.name AS author_name,
    u.email AS author_email
FROM posts p
INNER JOIN users u ON u.id = p.user_id
WHERE p.id = $1
