-- List all posts with their authors
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
ORDER BY p.created_at DESC
