

DROP VIEW IF EXISTS useful_combinations_view;
CREATE VIEW useful_combinations_view AS
SELECT
    f.fund_id AS fund_id,
    f.fund_name AS fund_name,
    sf.subfund_id AS subfund_id,
    sf.subfund_name AS subfund_name,
    sf.subfund_type AS subfund_type,
    fd.attribute1 AS attribute1,
CASE
	WHEN EXTRACT(year from fd.date) > 2015 and attribute2 = 'Hreinar Fjárfestingartekjur' 
		THEN 'Fjárfestingartekjur'
	WHEN EXTRACT(year from fd.date) > 2015 and attribute2 = 'Fjárfestingartekjur' and attribute3 = 'Fjárfestingargjöld' 
		THEN 'Fjárfestingargjöld'
else fd.attribute2
END AS attribute2,
CASE
    WHEN EXTRACT(year from fd.date) > 2015 and fd.attribute3 = 'Fjárfestingargjöld' THEN '(Samtals) Fjárfestingargjöld'
	else fd.attribute3
END AS attribute3,
    fd.attribute4 AS attribute4,
    to_char(fd.date, 'YYYY-MM-DD HH24:MI:SS') AS date,
    fd.value AS value
FROM
    funddata fd
JOIN
    fund f ON fd.fund_id = f.fund_id
JOIN
    subfund sf ON fd.subfund_id = sf.subfund_id
WHERE
    (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Iðgjöld' AND fd.attribute3 = '(Samtals) Iðgjöld')
    OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Lífeyrir' AND fd.attribute3 = '(Samtals) Lífeyrir')
    OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Hreinar Fjárfestingartekjur' AND fd.attribute3 = '(Samtals) Hreinar fjárfestingartekjur')
    OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Fjárfestingartekjur' AND fd.attribute3 = '(Samtals) Fjárfestingartekjur')
    OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Rekstrarkostnaður' AND fd.attribute3 = '(Samtals) Rekstrarkostnaður')
    OR (fd.attribute1 = 'Efnahagsreikningur' AND fd.attribute2 = '(Samtals) Hrein eign til greiðslu lífeyris')
    OR (fd.attribute1 = 'Efnahagsreikningur' AND fd.attribute2 = 'Eignir' AND fd.attribute3 = '(Samtals) Eignir samtals')
    OR (fd.attribute1 = 'Efnahagsreikningur' AND fd.attribute2 = 'Skuldir' AND fd.attribute3 = '(Samtals) Skuldir samtals')
	
	OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Fjárfestingargjöld' AND fd.attribute3 = '(Samtals) Fjárfestingargjöld')
	OR (fd.attribute1 = 'Rekstur' AND fd.attribute2 = 'Hreinar Fjárfestingartekjur' AND fd.attribute3 = 'Fjárfestingargjöld')
	
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Hrein raunávöxtun (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Ellilífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Örorkulífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Makalífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Barnalífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Annar lífeyrir (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Stöðugildi')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Lífeyrisbyrði')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Lífeyrisbyrði (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Fjárfestingargjöld (bein og áætluð/reiknuð)' AND fd.attribute3 = 'Hlutfall fjárfestingargjalda alls af heildareignum (%)')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Skrifstofu og stjórnunarkostnaður (alls) í % af meðalstöðu eigna')
    OR (fd.attribute1 = 'Lífeyrisþegar' AND fd.attribute2 ='Örorku')
    OR (fd.attribute1 = 'Framtíðariðgjöld')
    OR (fd.attribute1 = 'Ellilífeyrir á mán (þús. kr.)' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Samtals sjóðfélagar og lífeyrisþegar')
    OR (fd.attribute1 = 'Iðgjöld ársins (þús. kr.)' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Fjöldi ellilífeyrisþega' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Óvirkir sjóðfélagar')
    OR (fd.attribute1 = 'Heildarstaða %' AND fd.attribute2 ='NaN')
    OR (fd.attribute1 = 'Lífeyrisþegar' AND fd.attribute2 ='Elli')
    OR (fd.attribute1 = 'Iðgjöld ársins (þús. kr.)' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Áætlaðar launagr.' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Eignir í tryggingafræðilegu mati')
    OR (fd.attribute1 = 'Heildarstaða samtals')
    OR (fd.attribute1 = 'Áætlað iðgjöld %')
    OR (fd.attribute1 = 'Framtíðarstaða %')
    OR (fd.attribute1 = 'Ellilífeyrir á mán (þús. kr.)' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Fjöldi iðgjaldagreiðenda' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Heildarskuldbindingar' AND fd.attribute2 ='NaN')
    OR (fd.attribute1 = 'Virkir sjóðfélagar')
    OR (fd.attribute1 = 'Fjöldi iðgjaldagreiðenda' AND fd.attribute2 ='Konur')
    OR (fd.attribute1 = 'Heildareignir')
    OR (fd.attribute1 = 'Áfallnar skuldbindingar')
    OR (fd.attribute1 = 'Áfallin staða')
    OR (fd.attribute1 = 'Lífeyrisþegar' AND fd.attribute2 ='Barna')
    OR (fd.attribute1 = 'Lífeyrisþegar' AND fd.attribute2 ='Maka')
    OR (fd.attribute1 = 'Fjöldi ellilífeyrisþega' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Framtíðarskuldbinding')
    OR (fd.attribute1 = 'Áfallin staða %')
    OR (fd.attribute1 = 'Framtíðarstaða')
    OR (fd.attribute1 = 'Áætlaðar launagr.' AND fd.attribute2 ='Karlar')
    OR (fd.attribute1 = 'Samtals sjóðfélagar')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Fjárfestingargjöld (bein og áætluð/reiknuð)' AND fd.attribute3 = 'Umsýsluþóknanir vegna útvistunar eignastýringar')
    OR (fd.attribute1 = 'Kennitölur' AND fd.attribute2 = 'Áætluð umsýsluþóknun alls');


SELECT count(*) FROM useful_combinations_view


-- PIVOT TABLE 

DROP view if exists main_fund_data;

create view main_fund_data
as
select cast(left(date,4) as int) as yr,fund_id,fund_name,subfund_id,
                 subfund_name, subfund_type,
                 max(CASE WHEN attribute1 = 'Efnahagsreikningur' and attribute2 = 'Eignir' THEN coalesce(value,0) ELSE null END) as total_assets,
                 max(CASE WHEN attribute1 = 'Rekstur' and attribute2 = 'Iðgjöld' THEN coalesce(value,0) ELSE null END) as contributions,
                 max(CASE WHEN attribute1 = 'Rekstur' and attribute2 = 'Lífeyrir' THEN coalesce(value,0) ELSE null END) as pensions,
                 max(CASE WHEN attribute1 = 'Rekstur' and attribute2 = 'Rekstrarkostnaður' THEN coalesce(value,0) ELSE null END) as office_cost,
                 max(CASE WHEN attribute1 = 'Rekstur' and attribute2 = 'Fjárfestingargjöld' THEN coalesce(value,0) ELSE null END) as investment_fees,
                 max(CASE WHEN attribute1 = 'Rekstur' and attribute2 = 'Rekstrarkostnaður' THEN coalesce(value,0) ELSE null END) +
                 sum(CASE WHEN attribute1 = 'Rekstur' and attribute2 in ('Rekstrarkostnaður','Fjárfestingargjöld') THEN coalesce(value,0) ELSE null END) as total_cost,
                 max(CASE WHEN attribute1 = 'Heildarstaða %' THEN coalesce(value,0) ELSE null END) as surplus_ratio,
                 max(CASE WHEN attribute1 = 'Kennitölur' and attribute2 = 'Hrein raunávöxtun (%)' THEN coalesce(value,0) ELSE null END) as real_return,
                 max(CASE WHEN attribute1 = 'Samtals sjóðfélagar' THEN coalesce(value,0) ELSE null END) as member_count,
                 max(CASE WHEN attribute1 = 'Virkir sjóðfélagar' THEN coalesce(value,0) ELSE null END) as active_member_count,
                 max(CASE WHEN attribute1 = 'Lífeyrisþegar' and attribute2 = 'Elli' THEN coalesce(value,0) ELSE null END) as old_age_benefit_count,
                 max(CASE WHEN attribute1 = 'Lífeyrisþegar' and attribute2 = 'Örorku' THEN coalesce(value,0) ELSE null END) as disability_benefit_count,
                 max(CASE WHEN attribute1 = 'Lífeyrisþegar' and attribute2 = 'Maka' THEN coalesce(value,0) ELSE null END) as spouse_benefit_count,
                 max(CASE WHEN attribute1 = 'Lífeyrisþegar' and attribute2 = 'Barna' THEN coalesce(value,0) ELSE null END) as child_benefit_count,
                 max(CASE WHEN attribute1 = 'Kennitölur' and attribute2 = 'Ellilífeyrir (%)' THEN coalesce(value,0) ELSE null END) as old_age_benefit_percentage,
                 max(CASE WHEN attribute1 = 'Kennitölur' and attribute2 = 'Örorkulífeyrir (%)' THEN coalesce(value,0) ELSE null END) as disability_benefit_percentage,
                 max(CASE WHEN attribute1 = 'Kennitölur' and attribute2 = 'Makalífeyrir (%)' THEN coalesce(value,0) ELSE null END) as spouse_benefit_percentage,
                 max(CASE WHEN attribute1 = 'Kennitölur' and attribute2 = 'Barnalífeyrir (%)' THEN coalesce(value,0) ELSE null END) as child_benefit_percentage,
                 max(CASE WHEN attribute1 = 'Kennitölur' and attribute2 = 'Lífeyrisbyrði' THEN coalesce(value,0) ELSE null END) as liquidity_ratio,
                 max(CASE WHEN attribute1 = 'Kennitölur' and attribute2 = 'Stöðugildi' THEN coalesce(value,0) ELSE null END) as employee_count
                 from useful_combinations_view
                 group by cast(left(date,4) as int),fund_id,fund_name,subfund_id,subfund_name, subfund_type
 
SELECT * FROM main_fund_data;

DROP view if exists total_fund_data
create view total_fund_data
as
select yr,subfund_type,
                            sum(total_assets) as total_assets,
                            sum(contributions) as total_contributions,
                             sum(pensions) as total_pensions,
                             sum(office_cost) as total_office_cost,
                            sum(investment_fees) as total_investment_fees,
                             sum(total_cost) as total_cost,
              sum(surplus_ratio*total_assets)/sum(total_assets) as total_surplus_ratio,
              sum(real_return*total_assets)/sum(total_assets) as total_real_return,
                            sum(member_count) as total_member_count,
                      sum(active_member_count) as total_active_member_count,
                     sum(old_age_benefit_count) as total_old_age_benefit_count,
                   sum(disability_benefit_count) as total_disability_benefit_count,
                       sum(spouse_benefit_count) as total_spouse_benefit_count,
                           sum(child_benefit_count) as total_child_benefit_count,
              sum(old_age_benefit_percentage*pensions)/sum(pensions) as total_old_age_benefit_percentage,
              sum(disability_benefit_percentage*pensions)/sum(pensions) as total_disability_benefit_percentage,
              sum(spouse_benefit_percentage*pensions)/sum(pensions) as total_spouse_benefit_percentage,
              sum(child_benefit_percentage*pensions)/sum(pensions) as total_child_benefit_percentage,
              sum(pensions)/sum(contributions) as total_liquidity_ratio,
                            sum(employee_count) as total_employee_count
from
              main_fund_data
Group by yr,subfund_type
order by yr

SELECT * FROM total_fund_data