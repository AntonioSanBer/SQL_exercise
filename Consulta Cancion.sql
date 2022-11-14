set search_path TO ubd_20211; 

select s.title, s.duration,b.name, a.title 

from song s join album a on (s.id_album = a.id_album)  

join band b on ( b.id_band = a.id_band)  

where (a.year = 1986 and s.duration > '00:03:00'  

	   and b.id_band not in (select b.id_band 

				from musician m  

				join member me on me.id_musician = m.id_musician 

				join band b on me.id_band = b.id_band 

				where m.death is not null)); 