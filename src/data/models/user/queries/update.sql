-- Update a user
UPDATE users
SET name = $2, email = $3, bio = $4, updated_at = $5
WHERE id = $1
RETURNING *
