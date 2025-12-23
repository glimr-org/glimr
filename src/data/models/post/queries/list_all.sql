-- List all posts ordered by creation date
SELECT id, user_id, title, body, status, created_at, updated_at
FROM posts
ORDER BY created_at DESC
