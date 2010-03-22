SELECT callstarted, COUNT(*)
  FROM activecalls
 GROUP BY callstarted
 ORDER BY 1, 2;
