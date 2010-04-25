select m.machinecode, m.modulename, m.moduleversion, max(m.lastupdate)
  from modulesversion m
 where lastupdate > add_months(sysdate, -2)
 group by lastupdate, machinecode, modulename, moduleversion
 order by machinecode;
