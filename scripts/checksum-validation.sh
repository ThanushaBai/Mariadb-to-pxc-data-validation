#!/bin/bash
# Compares MD5 checksums between source and target.

echo "===== CHECKSUM VALIDATION ====="
echo ""
echo "SOURCE (port 3306):"
sudo docker exec source-mysql mysql -uroot -pmy-secret-pw -N -e "
SELECT MD5(GROUP_CONCAT(id, '|', name, '|', email ORDER BY id SEPARATOR '#'))
FROM sample_db.users;" 2>/dev/null
echo ""
echo "TARGET (port 3307):"
sudo docker exec target-mysql mysql -uroot -pmy-secret-pw -N -e "
SELECT MD5(GROUP_CONCAT(id, '|', name, '|', email ORDER BY id SEPARATOR '#'))
FROM sample_db.users;" 2>/dev/null
echo ""
echo "================================"