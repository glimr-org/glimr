-- Find a comment with author and post details (multiple JOINs)
SELECT
    c.id,
    c.body,
    c.is_approved,
    c.created_at,
    c.updated_at,
    u.id AS author_id,
    u.name AS author_name,
    u.email AS author_email,
    p.id AS post_id,
    p.title AS post_title,
    p.user_id AS post_author_id
FROM comments c
INNER JOIN users u ON u.id = c.user_id
INNER JOIN posts p ON p.id = c.post_id
WHERE c.id = $1
