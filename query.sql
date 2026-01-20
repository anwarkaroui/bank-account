UPDATE otc.t_referentialvalue rv
SET label = CASE
    WHEN rv.label = 'Visa' THEN 'CbVisa'
    WHEN rv.label = 'Mastercard' THEN 'CbMaster'
END
FROM otc.t_binrange br
JOIN otc.t_issuer i ON i.id = br.issuer_id
JOIN otc.t_bank b ON b.id = i.externalbankid
WHERE br.producttype_id = rv.id
  AND b.bankcode = '25648'
  AND br.bincardtrackstart = '4700000000000000000'
  AND br.bincardtrackend   = '4851111111111111111'
  AND rv.label IN ('Visa', 'Mastercard');


SELECT rv.id, rv.label, b.bankcode, br.bincardtrackstart, br.bincardtrackend
FROM otc.t_referentialvalue rv
JOIN otc.t_binrange br ON br.producttype_id = rv.id
JOIN otc.t_issuer i ON i.id = br.issuer_id
JOIN otc.t_bank b ON b.id = i.externalbankid
WHERE b.bankcode = '25648'
  AND br.bincardtrackstart = '4700000000000000000'
  AND br.bincardtrackend   = '4851111111111111111'
  AND rv.label IN ('Visa', 'Mastercard');

SELECT br.id, br.bincardtrackstart, br.bincardtrackend, br.issuer_id, br.producttype_id, b.bankcode
FROM otc.t_binrange br
JOIN otc.t_issuer i ON i.id = br.issuer_id
JOIN otc.t_bank b ON b.id = i.externalbankid
WHERE b.bankcode = '25648';


SELECT rv.id, rv.label, b.bankcode, br.bincardtrackstart, br.bincardtrackend
FROM otc.t_referentialvalue rv
JOIN otc.t_binrange br ON br.producttype_id = rv.id
JOIN otc.t_issuer i ON i.id = br.issuer_id
JOIN otc.t_bank b ON b.id = i.externalbankid
WHERE b.bankcode = '25648'
  AND br.bincardtrackstart = '4900000000000000000'
  AND br.bincardtrackend   = '4999999999999999999'
  AND rv.label IN ('Visa', 'Mastercard');

UPDATE otc.t_referentialvalue rv
SET label = CASE
    WHEN rv.label = 'Visa' THEN 'CbVisa'
    WHEN rv.label = 'Mastercard' THEN 'CbMaster'
END
FROM otc.t_binrange br
JOIN otc.t_issuer i ON i.id = br.issuer_id
JOIN otc.t_bank b ON b.id = i.externalbankid
WHERE br.producttype_id = rv.id
  AND b.bankcode = '25648'
  AND br.bincardtrackstart = '4900000000000000000'
  AND br.bincardtrackend   = '4999999999999999999'
  AND rv.label IN ('Visa', 'Mastercard');

SELECT
  br.id,
  b.bankcode,
  br.bincardtrackstart,
  br.bincardtrackend,
  br.producttype_id,
  rv_old.label AS current_label
FROM otc.t_binrange br
JOIN otc.t_issuer i ON i.id = br.issuer_id
JOIN otc.t_bank b ON b.id = i.externalbankid
JOIN otc.t_referentialvalue rv_old ON rv_old.id = br.producttype_id
WHERE b.bankcode = :bankcode
  AND br.bincardtrackstart = :bincardtrackstart
  AND br.bincardtrackend = :bincardtrackend
  AND rv_old.label IN ('Visa', 'Mastercard');

SELECT
  br.id                  AS binrange_id,
  b.bankcode,
  br.bincardtrackstart,
  br.bincardtrackend,
  rv.id                  AS producttype_id,
  rv.label               AS producttype_label
FROM otc.t_binrange br
JOIN otc.t_issuer i              ON i.id = br.issuer_id
JOIN otc.t_bank b                ON b.id = i.externalbankid
JOIN otc.t_referentialvalue rv   ON rv.id = br.producttype_id
WHERE (
    (b.bankcode = '12345'
     AND br.bincardtrackstart = '485454545454545400'
     AND br.bincardtrackend   = '4854865656999595999')
 OR
    (b.bankcode = '25648'
     AND br.bincardtrackstart = '4900000000000000000'
     AND br.bincardtrackend   = '4999999999999999999')
)
AND rv.label IN ('Visa', 'Mastercard');

UPDATE otc.t_binrange br
SET producttype_id = CASE
  WHEN br.producttype_id = 13 THEN 48  -- Visa -> CbVisa
  WHEN br.producttype_id = 14 THEN 49  -- Mastercard -> CbMaster
  ELSE br.producttype_id
END
FROM otc.t_issuer i
JOIN otc.t_bank b ON b.id = i.externalbankid
WHERE br.issuer_id = i.id
  AND (
    (b.bankcode = '12345'
     AND br.bincardtrackstart = '485454545454545400'
     AND br.bincardtrackend   = '4854865656999595999')
    OR
    (b.bankcode = '25648'
     AND br.bincardtrackstart = '4900000000000000000'
     AND br.bincardtrackend   = '4999999999999999999')
  )
  AND br.producttype_id IN (13, 14);

‐----‐---------------------
UPDATE otc.t_binrange br
SET producttype_id = CASE
  WHEN rv_old.label = 'Visa' THEN (
    SELECT rv_new.id
    FROM otc.t_referentialvalue rv_new
    WHERE rv_new.label = 'CbVisa'
    LIMIT 1
  )
  WHEN rv_old.label = 'Mastercard' THEN (
    SELECT rv_new.id
    FROM otc.t_referentialvalue rv_new
    WHERE rv_new.label = 'CbMaster'
    LIMIT 1
  )
  ELSE br.producttype_id
END
FROM otc.t_issuer i
JOIN otc.t_bank b ON b.id = i.externalbankid
JOIN otc.t_referentialvalue rv_old ON rv_old.id = br.producttype_id
WHERE br.issuer_id = i.id
  AND b.bankcode = :bankcode
  AND br.bincardtrackstart = :bincardtrackstart
  AND br.bincardtrackend   = :bincardtrackend
  AND rv_old.label IN ('Visa', 'Mastercard');


SELECT
  b.bankcode,
  br.bincardtrackstart,
  br.bincardtrackend,
  rv.label AS producttype_label
FROM otc.t_binrange br
JOIN otc.t_issuer i ON i.id = br.issuer_id
JOIN otc.t_bank b ON b.id = i.externalbankid
JOIN otc.t_referentialvalue rv ON rv.id = br.producttype_id
WHERE b.bankcode = :bankcode
  AND br.bincardtrackstart = :bincardtrackstart
  AND br.bincardtrackend   = :bincardtrackend;