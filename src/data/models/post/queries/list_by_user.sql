-- List all posts by a specific user
SELECT id, user_id, title, body, status, created_at, updated_at
FROM posts
WHERE user_id = $1
ORDER BY created_at DESC
