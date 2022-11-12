--=============== ������ 5. ������ � POSTGRESQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ������ � ������� payment � � ������� ������� ������� �������� ����������� ������� �������� ��������:
--������������ ��� ������� �� 1 �� N �� ����
--������������ ������� ��� ������� ����������, ���������� �������� ������ ���� �� ����
--���������� ����������� ������ ����� ���� �������� ��� ������� ����������, ���������� ������ 
--���� ������ �� ���� �������, � ����� �� ����� ������� �� ���������� � �������
--������������ ������� ��� ������� ���������� �� ��������� ������� �� ���������� � ������� 
--���, ����� ������� � ���������� ��������� ����� ���������� �������� ������.
--����� ��������� �� ������ ����� ��������� SQL-������, � ����� ���������� ��� ������� � ����� �������.

select payment_id, row_number() over(order by payment_date)
from payment --������� 1.1


select customer_id, payment_id, payment_date,
row_number() over (partition by customer_id order by payment_date)
from payment p --������� 1.2


select customer_id, payment_date::date, amount, 
sum(amount) over (partition by customer_id order by payment_date::date, amount)
from payment p --������� 1.3


select customer_id, amount, dense_rank as rank
from
	(select customer_id, payment_id, amount,
	row_number() over (partition by customer_id order by amount desc),
	dense_rank() over (partition by customer_id order by amount desc)
	from payment p) t --������� 1.4


--������� �2
--� ������� ������� ������� �������� ��� ������� ���������� ��������� ������� � ��������� 
--������� �� ���������� ������ �� ��������� �� ��������� 0.0 � ����������� �� ����.

select customer_id, payment_date, amount,
lag(amount, 1, 0.0) over (partition by customer_id order by payment_date) as last_amount
from payment p




--������� �3
--� ������� ������� ������� ����������, �� ������� ������ ��������� ������ ���������� ������ ��� ������ ��������.


select customer_id, payment_id, payment_date, amount,
amount - lead(amount) over (partition by customer_id order by payment_date) as difference
from payment p



--������� �4
--� ������� ������� ������� ��� ������� ���������� �������� ������ � ��� ��������� ������ ������.


select customer_id, payment_id, payment_date, amount
from (
	select customer_id, payment_id, payment_date,
	row_number() over (partition by customer_id order by payment_date desc), amount
	from payment p) t
where row_number = 1



--======== �������������� ����� ==============

--������� �1
--� ������� ������� ������� �������� ��� ������� ���������� ����� ������ �� ������ 2005 ���� 
--� ����������� ������ �� ������� ���������� � �� ������ ���� ������� (��� ����� �������) 
--� ����������� �� ����.




--������� �2
--20 ������� 2005 ���� � ��������� ��������� �����: ���������� ������� ������ ������� �������
--�������������� ������ �� ��������� ������. � ������� ������� ������� �������� ���� �����������,
--������� � ���� ���������� ����� �������� ������




--������� �3
--��� ������ ������ ���������� � �������� ����� SQL-�������� �����������, ������� �������� ��� �������:
-- 1. ����������, ������������ ���������� ���������� �������
-- 2. ����������, ������������ ������� �� ����� ������� �����
-- 3. ����������, ������� ��������� ��������� �����






