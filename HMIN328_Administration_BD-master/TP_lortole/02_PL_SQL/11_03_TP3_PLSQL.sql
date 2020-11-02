/*
Vous d ́efinirez une fonction de calcul de distance kilom ́etrique. Vous g ́ererez pour cette fonction
diff ́erentes exceptions de mani`ere `
a pr ́evenir une grande majorit ́e des erreurs pouvant impacter le
sch ́ema de la table commune. Le calcul de la distance en kilom`etres entre deux points a et b ayant
respectivement une latitude et une longitude not ́ees lat a, long a, et lat b, long b (r ́ef ́erentiel WGS84)
*/

create or replace function radians(valeurEnDegre in float) return float
is
begin
return valeurEnDegre/57.295779513082;
end;
/

create or replace function calc_dist_km(lat_a in float , lat_b in float , long_a in float , long_b in float) return float
is
resultat float;
begin
resultat := 6366*acos(cos(radians(lat_a))*cos(radians(lat_b))*cos(radians(long_b)-radians(long_a))+sin(radians(lat_a))*sin(radians(lat_b)));
return resultat ;
end;
/

BEGIN
dbms_output.put_line(calc_dist_km(1,1,1,1)) ;
END;
/

