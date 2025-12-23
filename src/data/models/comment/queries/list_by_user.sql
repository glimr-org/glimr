-- List all comments by a specific user with post info
SELECT
    c.id,
    c.body,
    c.is_approved,
    c.created_at,
    c.updated_at,
    p.id AS post_id,
    p.title AS post_title
FROM comments c
INNER JOIN posts p ON p.id = c.post_id
WHERE c.user_id = $1
ORDER BY c.created_at DESC
