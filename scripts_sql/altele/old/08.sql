select lpad('=',10,'=') || 'modules' || lpad('=',10,'=') from dual;
select m.machinecode, m.modulename, m.moduleversion, max(m.lastupdate)
  from modulesversion m
 where lastupdate > add_months(sysdate, -6)
 group by lastupdate, machinecode, modulename, moduleversion
 order by machinecode; 
