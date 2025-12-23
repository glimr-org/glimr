-- List comments pending approval with full context
SELECT
    c.id,
    c.body,
    c.created_at,
    u.id AS author_id,
    u.name AS author_name,
    u.email AS author_email,
    p.id AS post_id,
    p.title AS post_title,
    pa.name AS post_author_name
FROM comments c
INNER JOIN users u ON u.id = c.user_id
INNER JOIN posts p ON p.id = c.post_id
INNER JOIN users pa ON pa.id = p.user_id
WHERE c.is_approved = false
ORDER BY c.created_at ASC
