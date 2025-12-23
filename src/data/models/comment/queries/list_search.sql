-- Search comments by body content with author and post info
SELECT
    c.id,
    c.body,
    c.is_approved,
    c.created_at,
    u.name AS author_name,
    p.title AS post_title
FROM comments c
INNER JOIN users u ON u.id = c.user_id
INNER JOIN posts p ON p.id = c.post_id
WHERE c.body LIKE $1
ORDER BY c.created_at DESC
