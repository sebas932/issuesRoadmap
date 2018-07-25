SELECT 
    dr.id, dr.download_id, dr.region_id, r.name, dr.region_scope, d.date
FROM
    msp_download_regions dr
        INNER JOIN
    msp_download d ON d.id = dr.download_id
        INNER JOIN
    msp_regions r ON r.id = dr.region_id
;