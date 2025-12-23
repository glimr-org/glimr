-- Find top commenters and their latest comment using CTE
WITH top_commenters AS (
    SELECT user_id, COUNT(*) as comment_count
    FROM comments
    GROUP BY user_id
    ORDER BY comment_count DESC
    LIMIT 10
)
SELECT c.id, c.body, c.user_id, c.created_at, tc.comment_count
FROM comments c
INNER JOIN top_commenters tc ON tc.user_id = c.user_id
WHERE c.id = (
    SELECT MAX(id) FROM comments WHERE user_id = c.user_id
)
