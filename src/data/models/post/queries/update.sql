-- Update a post
UPDATE posts
SET title = $1, body = $2, status = $3, updated_at = $4
WHERE id = $5
RETURNING *
