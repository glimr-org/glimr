-- Find a user by email address
SELECT id, name, email, bio, created_at, updated_at
FROM users
WHERE email = $1
