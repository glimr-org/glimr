-- Find a post by ID
SELECT id, user_id, title, body, status, created_at, updated_at
FROM posts
WHERE id = $1
