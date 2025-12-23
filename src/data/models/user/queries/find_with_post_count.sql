-- Find a user with their post count
SELECT
    u.id,
    u.name,
    u.email,
    u.bio,
    u.created_at,
    u.updated_at,
    COUNT(p.id) AS post_count
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
WHERE u.id = $1
GROUP BY u.id, u.name, u.email, u.bio, u.created_at, u.updated_at
