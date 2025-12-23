-- Find a user by ID
SELECT id, name, email, bio, created_at, updated_at
FROM users
WHERE id = $1
