-- Comments with computed status using CASE
SELECT
    c.id,
    c.body,
    c.user_id,
    c.is_approved,
    CASE
        WHEN c.is_approved = 1 THEN 'approved'
        WHEN c.created_at > datetime('now', '-1 hour') THEN 'pending_review'
        ELSE 'needs_moderation'
    END AS status,
    c.created_at
FROM comments c
WHERE c.post_id = $1
