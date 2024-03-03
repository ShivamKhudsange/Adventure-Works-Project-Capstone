
Create table project.Sales as 
Select * 
from project.fact_internet_sales_new
Union All
Select * 
from project.factinternetsales;

Set Sql_safe_updates = 0;

Alter table project.sales
add Year int;

UPDATE project.sales SET year = EXTRACT(YEAR FROM STR_TO_DATE(orderdate, '%m/%d/%Y'));

Alter table project.sales
add Month int;

UPDATE project.sales SET month = EXTRACT(Month FROM STR_TO_DATE(orderdate, '%m/%d/%Y'));

Alter table project.sales
add Quarter int;

UPDATE project.sales SET quarter = EXTRACT(Quarter FROM STR_TO_DATE(orderdate, '%m/%d/%Y'));

ALTER TABLE project.sales ADD monthname VARCHAR(10);
UPDATE project.sales SET monthname = monthname(STR_TO_DATE(orderdate, '%m/%d/%Y'));

ALTER TABLE project.sales ADD day VARCHAR(10);
UPDATE project.sales SET day = dayname(STR_TO_DATE(orderdate, '%m/%d/%Y'));

ALTER TABLE project.sales ADD weekdayno int;
UPDATE project.sales SET weekdayno = weekday(STR_TO_DATE(orderdate, '%m/%d/%Y'));

ALTER TABLE project.sales add fiscalmonth int;
UPDATE project.sales SET fiscalmonth = month(STR_TO_DATE(orderdate, '%m/%d/%Y'))+6;

ALTER TABLE project.sales add fiscalquarter int;
UPDATE project.sales SET fiscalquarter = quarter(STR_TO_DATE(orderdate, '%m/%d/%Y'))+2;

select * from project.sales;

Select 
sum(SalesAmount)
,sum(TotalProductCost)
,Year
from project.sales
group by year
order by year asc;

Select 
sum(SalesAmount) as Sales
,sum(TotalProductCost) as Cost
,Year
,monthname
from project.sales
group by year,monthname
order by year asc;

Select 
sum(SalesAmount)-sum(TotalProductCost) as Profit
,Year
from project.sales
group by year
order by year asc;

Select 
sum(SalesAmount) as Sales
,Year
,Quarter
from project.sales
group by year,Quarter
order by year asc;

Select 
sum(SalesAmount) as totalSales
,c.SalesTerritoryCountry
from project.sales s inner join project.dimsalesterritory c on s.SalesTerritorykey = c.SalesTerritoryKey
group by c.SalesTerritoryCountry
order by totalSales desc;

Select 
pc.EnglishProductCategoryName
,sc.EnglishProductSubcategoryName
,sum(s.SalesAmount) - sum(s.TotalProductCost) as profit
from project.sales s inner join project.dimproduct p on s.ProductKey = p.ProductKey 
inner join project.dimproductsubcategory sc on p.ProductSubcategoryKey = sc.ProductSubcategoryKey
inner join project.dimproductcategory pc on sc.ProductCategoryKey = pc.ProductCategoryKey
group by pc.EnglishProductCategoryName,sc.EnglishProductSubcategoryName
order by profit desc;

Select 
p.EnglishProductName
,sum(s.SalesAmount) as totalsales
from project.sales s inner join project.dimproduct p on s.ProductKey = p.ProductKey 
inner join project.dimproductsubcategory sc on p.ProductSubcategoryKey = sc.ProductSubcategoryKey
inner join project.dimproductcategory pc on sc.ProductCategoryKey = pc.ProductCategoryKey
group by p.EnglishProductName
order by totalsales desc
limit 15;

select
sum(SalesAmount)
from project.sales;

select
sum(TotalProductCost)
from project.sales;

select
sum(SalesAmount) - sum(TotalProductCost) as Profit
from project.sales;

select
distinct(count(OrderQuantity))
from project.sales;
