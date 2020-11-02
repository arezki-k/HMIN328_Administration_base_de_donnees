col value for 99999999999.99
select 1- (phy.value / ( cons.value + db.value - phy.value)) 
from v$sysstat phy, v$sysstat cons, v$sysstat db
where phy.name ='physical reads' and cons.name ='consistent gets' and db.name ='db block gets';