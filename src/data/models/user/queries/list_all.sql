-- List all users ordered by creation date
SELECT id, name, email, bio, created_at, updated_at
FROM users
ORDER BY created_at DESC
