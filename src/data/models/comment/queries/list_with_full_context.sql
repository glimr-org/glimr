-- List all comments with full context (comment author, post, post author)
-- This tests multiple JOINs including self-referential patterns
SELECT
    c.id AS comment_id,
    c.body AS comment_body,
    c.is_approved,
    c.created_at AS comment_created_at,
    ca.id AS comment_author_id,
    ca.name AS comment_author_name,
    ca.email AS comment_author_email,
    p.id AS post_id,
    p.title AS post_title,
    p.status AS post_status,
    pa.id AS post_author_id,
    pa.name AS post_author_name
FROM comments c
INNER JOIN users ca ON ca.id = c.user_id
INNER JOIN posts p ON p.id = c.post_id
INNER JOIN users pa ON pa.id = p.user_id
ORDER BY c.created_at DESC
