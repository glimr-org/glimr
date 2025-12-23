-- Find a comment only if the user has other approved comments (EXISTS)
SELECT c.id, c.body, c.user_id, c.created_at
FROM comments c
WHERE c.id = $1
  AND EXISTS (
      SELECT 1 FROM comments c2
      WHERE c2.user_id = c.user_id
        AND c2.is_approved = 1
        AND c2.id != c.id
  )
