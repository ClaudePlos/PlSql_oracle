#### How to use CASE statement and a parameter in the WHERE clause?
<pre>
SELECT * FROM TABLE
WHERE MY_DATE BETWEEN D_START AND D_END
AND (
      (:REVENUE = 1 AND REV != 0)
      OR
      (:REVENUE = 2 AND REV = 0 )
    )
</pre>
