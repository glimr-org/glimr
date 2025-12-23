-- Find a post with author and comment statistics
SELECT
    p.id,
    p.title,
    p.body,
    p.status,
    p.created_at,
    p.updated_at,
    u.id AS author_id,
    u.name AS author_name,
    COUNT(c.id) AS comment_count,
    COUNT(CASE WHEN c.is_approved = true THEN 1 END) AS approved_comment_count
FROM posts p
INNER JOIN users u ON u.id = p.user_id
LEFT JOIN comments c ON c.post_id = p.id
WHERE p.id = $1
GROUP BY p.id, p.title, p.body, p.status, p.created_at, p.updated_at, u.id, u.name
