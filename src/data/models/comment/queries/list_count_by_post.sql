-- Count comments per post (aggregation query)
SELECT
    p.id AS post_id,
    p.title AS post_title,
    COUNT(c.id) AS total_comments,
    COUNT(CASE WHEN c.is_approved = true THEN 1 END) AS approved_comments,
    COUNT(CASE WHEN c.is_approved = false THEN 1 END) AS pending_comments
FROM posts p
LEFT JOIN comments c ON c.post_id = p.id
GROUP BY p.id, p.title
ORDER BY total_comments DESC
