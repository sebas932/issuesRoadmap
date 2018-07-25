SELECT 
	dg.id,
    d.id as 'download_id',
    d.user_id,
    d.institute,
    d.intended_use,
    CONCAT(p.first_name, ' ', p.last_name) AS 'person_name',
    p.email,
    p.registered,
    dg.guideline_id,
    g.code,
    g.name,
    g.source,
    g.type,
    d.date
FROM
    msp_download_guidelines dg
        INNER JOIN
    msp_download d ON d.id = dg.download_id
        INNER JOIN
    msp_guidelines g ON g.id = dg.guideline_id
        INNER JOIN
    msp_person p ON p.id = d.user_id
WHERE
    g.active;
    