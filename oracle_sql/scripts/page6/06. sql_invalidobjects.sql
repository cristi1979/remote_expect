select A.Owner Oown,
       A.Object_Name Oname,
       A.Object_Type Otype,
       'Miss Pkg Body' Prob
  from DBA_OBJECTS A
 where A.Object_Type = 'PACKAGE'
   and A.Owner not in ('SYS', 'SYSTEM')
   and not exists (select 'x'
          from DBA_OBJECTS B
         where B.Object_Name = A.Object_Name
           and B.Owner = A.Owner
           and B.Object_Type = 'PACKAGE BODY')
union
select Owner Oown, Object_Name Oname, Object_Type Otype, 'Invalid Obj' Prob
  from DBA_OBJECTS
 where Object_Type in ('PROCEDURE', 'PACKAGE', 'FUNCTION', 'TRIGGER',
        'PACKAGE BODY', 'VIEW')
   and Owner not in ('SYS', 'SYSTEM')
   and Status != 'VALID'
 order by 1, 4, 3, 2;
