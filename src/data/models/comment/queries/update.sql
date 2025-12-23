-- Update a comment
UPDATE comments
SET body = $1, is_approved = $2, updated_at = $3
WHERE id = $4
RETURNING *
