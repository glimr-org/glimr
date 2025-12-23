-- List posts with their comment counts
SELECT
    p.id,
    p.user_id,
    p.title,
    p.body,
    p.status,
    p.created_at,
    p.updated_at,
    COUNT(c.id) AS comment_count
FROM posts p
LEFT JOIN comments c ON c.post_id = p.id
GROUP BY p.id, p.user_id, p.title, p.body, p.status, p.created_at, p.updated_at
ORDER BY p.created_at DESC
