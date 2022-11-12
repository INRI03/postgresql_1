--=============== МОДУЛЬ 5. РАБОТА С POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
--Пронумеруйте все платежи от 1 до N по дате
--Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате
--Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна 
--быть сперва по дате платежа, а затем по сумме платежа от наименьшей к большей
--Пронумеруйте платежи для каждого покупателя по стоимости платежа от наибольших к меньшим 
--так, чтобы платежи с одинаковым значением имели одинаковое значение номера.
--Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.

select payment_id, row_number() over(order by payment_date)
from payment --задание 1.1


select customer_id, payment_id, payment_date,
row_number() over (partition by customer_id order by payment_date)
from payment p --задание 1.2


select customer_id, payment_date::date, amount, 
sum(amount) over (partition by customer_id order by payment_date::date, amount)
from payment p --задание 1.3


select customer_id, amount, dense_rank as rank
from
	(select customer_id, payment_id, amount,
	row_number() over (partition by customer_id order by amount desc),
	dense_rank() over (partition by customer_id order by amount desc)
	from payment p) t --задание 1.4


--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате.

select customer_id, payment_date, amount,
lag(amount, 1, 0.0) over (partition by customer_id order by payment_date) as last_amount
from payment p




--ЗАДАНИЕ №3
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.


select customer_id, payment_id, payment_date, amount,
amount - lead(amount) over (partition by customer_id order by payment_date) as difference
from payment p



--ЗАДАНИЕ №4
--С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.


select customer_id, payment_id, payment_date, amount
from (
	select customer_id, payment_id, payment_date,
	row_number() over (partition by customer_id order by payment_date desc), amount
	from payment p) t
where row_number = 1
