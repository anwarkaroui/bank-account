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