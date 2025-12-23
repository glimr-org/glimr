-- Update a user
UPDATE users
SET name = $1, email = $2, bio = $3, updated_at = $4
WHERE id = $5
RETURNING *
