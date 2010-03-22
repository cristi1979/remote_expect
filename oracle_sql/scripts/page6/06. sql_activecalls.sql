SELECT mts, callstarted, status, COUNT(*)
  FROM activecalls
 GROUP BY mts, callstarted, status
 ORDER BY 1, 2;
 