# Gagnagrunnur-Symmetria

Öll gögn sem þarf til að búa til gagnagrunninn ásamt dumpinu (Í dumpinu er gagangrunnurinn í heild og useful_combinations_view viewið, 
sem hægt er að finna undir theView, í theView er ásamt aðsendar PIVOT töflur sem hægt er að runna). 

Undir databasePopulator er hægt að finna scriptuna til að runna gagnagrunninn, schemað, og viewi.

Í mapping er hægt að finna hvar öll nöfn speglast, þannig það er einfalt að finna út ef eitthvað er furðulegt í nöfnunum og kanna afhverju það er. (mapping er að 
sjálfsögðu ekkert gott fyrir scalability, en þar sem þetta er svo rosa lítill gagnagrunnur lætur maður þetta duga).

Síðan í data er hægt að finna öll excel skjölin, með funddata sheetunum á stöðluðu forminu, aftur hægt að finna hvort eitthvað sé skrítið út af þeim, þar sem 
gagnagrunnurinn er allur lesinn frá þeim). þ.e.a.s dumpið kemur einungis frá því sem er hérna.
