-- List all comments ordered by creation date
SELECT id, user_id, post_id, body, is_approved, created_at, updated_at
FROM comments
ORDER BY created_at DESC
