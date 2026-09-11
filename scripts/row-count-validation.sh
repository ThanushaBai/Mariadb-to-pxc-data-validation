#!/bin/bash
# Compares row counts between source and target.

echo "===== ROW COUNT VALIDATION ====="
echo ""
echo "SOURCE (port 3306):"
sudo docker exec source-mysql mysql -uroot -pmy-secret-pw -N \
  -e "SELECT COUNT(*) FROM sample_db.users;" 2>/dev/null
echo ""
echo "TARGET (port 3307):"
sudo docker exec target-mysql mysql -uroot -pmy-secret-pw -N \
  -e "SELECT COUNT(*) FROM sample_db.users;" 2>/dev/null
echo ""
echo "================================"