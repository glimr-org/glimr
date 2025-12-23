-- Comments with row numbers per post (window function)
SELECT
    c.id,
    c.body,
    c.post_id,
    ROW_NUMBER() OVER (PARTITION BY c.post_id ORDER BY c.created_at) AS row_num,
    c.created_at
FROM comments c
WHERE c.user_id = $1
