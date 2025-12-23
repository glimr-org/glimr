-- Find a comment by ID
SELECT id, user_id, post_id, body, is_approved, created_at, updated_at
FROM comments
WHERE id = $1
