use bank
go
select * from bank
select * from branch
select * from account
select * from customer
select * from transactions
go
-- Liệt kê danh sách khách hàng ở Đà Nẵng 
select distinct cust_name, cust_ad from customer
where Cust_ad like N'% Đà Nẵng'


-- Liệt kê những tài khoản loại VIP (type = 1) 
select distinct ac_no, ac_type from account
where ac_type = 1


-- Liệt kê những khách hàng không sử dụng số điện thoại của Mobi phone 
select cust_name, cust_phone from customer
where  LEFT( Cust_phone, 3) IN ('089','090','093','0120','0121','0122','0126','0128','070','079','077','076','078')


-- Liệt kê những khách hàng họ Phan
select *  from customer where Cust_name like 'Phan%'


-- Liệt kê những khách hàng tên chứa chữ g 
select * from customer where [Cust_name] like '%g%' or [Cust_name] like '%g' or [Cust_name] like 'g%'


-- Liệt kê những khách hàng chữ cái thứ 2 là chữ H, T, A, Ê 
select * from customer where SUBSTRING([Cust_name],2,1) in ('h','t','a','ê')


-- Liệt kê những giao dịch diễn ra trong quý IV năm 2016 
select * from transactions where (DATEPART(month,transactions.t_date) Between 9 and 12)
								  AND DATEPART(YEAR,transactions.t_date)=2016

-- Liệt kê những giao dịch bất thường (tiền trong tài khoản âm) 
select * from transactions where transactions.t_amount<0


-- Có bao nhiêu người có tài khoản bất thường 
select ac.Ac_no as stk, cu.Cust_name as chu_tk, ac.ac_balance as tien_tk
from account as ac
inner join customer as cu on ac.cust_id=cu.Cust_id
where ac.ac_balance<0


-- Thống kê số lượng giao dịch, số tiền giao dịch theo loại giao dịch 
select transactions.t_type,count(t_id) as count, sum(t_amount) as sum
from transactions
group by transactions.t_type


-- Có bao nhiêu khách hàng có địa chỉ ở Huế
select * from customer where CHARINDEX(N'HUẾ',UPPER(Cust_ad))>0
select * from customer where Cust_ad like N'%HUẾ%'
select Cust_ad,CHARINDEX(N'HUẾ',Cust_ad) as indexs  from customer 


-- Số tiền trong các tài khoản nhiều nhất là bao nhiêu 
select a.* 
from account a
where a.ac_balance = (	select max(b.ac_balance) 
						from account b )


-- Ngày giao dịch gần đây nhất là ngày bao nhiêu
select TOP 1 (CONCAT(t_time,' ',t_date)) as val
from transactions
order by transactions.t_date desc


-- Có bao nhiêu khách hàng họ Trần và tên Dũng
select count(Cust_id)as count from customer where customer.Cust_name like(N'Huỳnh%Dũng') group by Cust_id


-- Trong năm 2016 và 2017 tổng lượng tiền gửi vào ngân hàng là bao nhiêu 
select  sum(t_amount) as sum from transactions
where (DATEPART(YEAR,transactions.t_date) between 2016 and 2017) 
	  and transactions.t_type=1


-- Trong năm 2016 và 2017 tổng lượng tiền gửi từng năm vào ngân hàng là bao nhiêu 
select DATEPART(YEAR,transactions.t_date)as year, sum(t_amount) as sum from transactions
where (DATEPART(YEAR,transactions.t_date) between 2016 and 2017) 
	  and transactions.t_type=1
group by DATEPART(YEAR,transactions.t_date)


--  Thống kê số lượng tài khoản, số tiền trung bình trong tài khoản theo từng loại 
select ac_type,count(Ac_no) as count, sum(account.ac_balance) as sum
from account
group by ac_type


-- Có bao nhiêu khách họ Hồ sử dụng dịch vụ di động của Viettel 
select count(customer.Cust_id) as count from customer
where  LEFT( Cust_phone, 3) IN ('086','096','097','098','0162','032','0163','033','0164','034','0165','035','0166','036','0167','037','0168','038','0169','039')
-- Ngân hàng Vietcombank có tổng cộng bao nhiêu chi nhánh 
select Branch.* 
from Branch
inner join Bank ON Bank.b_id=Branch.B_id
where Bank.b_name =N'Ngân hàng Công thương Việt Nam'


-- Có bao nhiêu khách hàng không ở Quảng Nam 
select count(customer.Cust_id) as count from customer
where customer.Cust_ad not like N'%Quảng Nam%'


-- Có bao nhiêu tài khoản nhiều hơn 300 triệu, tổng tiền trong số các tài khoản đó là bao nhiêu? 
select sum(ac_balance) as sum from account
where ac_balance>300000000


-- Số tiền trung bình của mỗi lần thực hiện giao dịch rút tiền trong năm 2017 là bao nhiêu 
select AVG(transactions.t_amount) as AVG
from transactions
where t_type=0 and DATEPART(YEAR,transactions.t_date)=2017


-- Số tiền rút tiền trung bình vào mùa thu đông năm 2013 của các chi nhánh là bao nhiêu? (thu đông: quý III, IV) 
select AVG(transactions.t_amount)as AVG
from transactions
where transactions.t_type=0
	and(DATEPART(YEAR,transactions.t_date) =2013)
	and(DATEPART(MONTH,transactions.t_date) between 7 and 12)



-- Tháng 08/2015, có bao nhiêu giao dịch rút tiền diễn ra vào buổi tối và đêm (từ 18h ngày hôm trước tới 05h sang ngày hôm sau) 
select count(transactions.t_id) as count
from transactions
where transactions.t_type=0
	and(DATEPART(YEAR,transactions.t_date) =2015)
	and(DATEPART(MONTH,transactions.t_date) =8)
	and (	DATEPART(HOUR,transactions.t_time) >=18 OR
			DATEPART(HOUR,transactions.t_time) <=5  
		)


-- Hiển thị những giao dịch bất thường trong quý I năm 2012. Giao dịch bất thường: giao dịch rút nộp tiền diễn ra ngoài giờ hành chính. 
select transactions.*,customer.*
from transactions
JOIN account ON account.Ac_no = transactions.ac_no
JOIN customer ON customer.Cust_id = account.cust_id
where transactions.t_type=0
	and(DATEPART(YEAR,transactions.t_date) =2012)
	and(DATEPART(MONTH,transactions.t_date) between 1 and 3)
	and (	DATEPART(HOUR,transactions.t_time) >=17 OR
			DATEPART(HOUR,transactions.t_time) <=8  
		)


-- Ông Phạm Duy Khánh có khiếu nại tài khoản của ông ta bị trừ một khoản tiền vô lý (gần 50 triệu) trong tháng 12/2014.
-- Anh/chị hãy truy xuất toàn bộ dữ liệu giao dịch diễn ra trong khoảng thời gian này để giải quyết khiếu nại của ông Khánh.  
select transactions.*,customer.*
from transactions
JOIN account ON account.Ac_no = transactions.ac_no
JOIN customer ON customer.Cust_id = account.cust_id
where transactions.t_type=0
	and(DATEPART(YEAR,transactions.t_date) =2014)
	--and(DATEPART(MONTH,transactions.t_date) =12)
	and Cust_name=N'Phạm Duy Khánh'


-- Tìm người có cùng chi nhánh với ông Phạm Duy Khánh
select cus_a.*,br.*
from  Branch br 
join customer cus_a ON  cus_a.Br_id= br.BR_id
join customer cus_b ON cus_b.Br_id = cus_a.Br_id
where cus_b.Cust_name=N'Phạm Duy Khánh'
	and  cus_a.Cust_name<>N'Phạm Duy Khánh'


-- VCB Đà Nẵng có bao nhiêu khách hàng, tổng tiền trung bình giao dịch trong 1 năm
select DATEPART(YEAR,tr.t_date) as year , AVG(tr.t_amount) as AVG
from transactions tr
inner join account ac ON ac.Ac_no = tr.ac_no
inner join customer cu ON cu.Cust_id= ac.cust_id
inner join Branch br ON br.BR_id = cu.Br_id
where br.BR_name like N'Vietcombank Đà Nẵng'
group by  DATEPART(YEAR,tr.t_date) 

select count(cu.Cust_id) as count
from transactions tr
inner join account ac ON ac.Ac_no = tr.ac_no
inner join customer cu ON cu.Cust_id= ac.cust_id
inner join Branch br ON br.BR_id = cu.Br_id
where br.BR_name like N'Vietcombank Đà Nẵng'
-- Trong tháng 4 năm 2014, VCM chi nhánh Huế xử lý bao nhiêu giao dịch rút tiền
select count(tr.t_id) as count
from transactions tr
inner join account ac ON ac.Ac_no = tr.ac_no
inner join customer cu ON cu.Cust_id= ac.cust_id
inner join Branch br ON br.BR_id = cu.Br_id
where	br.BR_name like N'Vietcombank Huế'
		AND DATEPART(YEAR,tr.t_date) =2014 
		AND DATEPART(MONTH,tr.t_date) =2
		AND tr.t_type=0
-- VCB Hà Nội đang quản lý bao nhiêu tài khoản, tổng số tiền trong tài khoản = bn?
select count(cu.Cust_id) as count,sum(ac.ac_balance) as sum
from  account ac
inner join customer cu ON cu.Cust_id= ac.cust_id
inner join Branch br ON br.BR_id = cu.Br_id
where	br.BR_name like N'Vietcombank Hà Nội'

-- Ông PDK thuộc chi nhánh ngân hàng nào, có bao nhiêu tài khoản trong ngân hàng, giao dịch gần đây nhất thực hiện vào time nào

select br.BR_name as Branch, ac.ac_balance as balance, MAX(CONCAT(tr.t_date,' ',tr.t_time)) as last_transaction
from transactions tr
inner join account ac ON ac.Ac_no = tr.ac_no
inner join customer cu ON cu.Cust_id= ac.cust_id
inner join Branch br ON br.BR_id = cu.Br_id
where cu.Cust_name like N'Phạm Duy Khánh'
group by br.BR_name, ac.ac_balance 
-- Ai là người có tiền nhiều nhất trong VCB hiện nay
select cu.Cust_id,cu.Cust_name, ac.Ac_no as AC_NO, ac.ac_balance as balance, br.BR_name as branch, ba.b_name as bank
from  account ac
inner join customer cu ON cu.Cust_id= ac.cust_id
inner join Branch br ON br.BR_id = cu.Br_id
inner join Bank ba ON ba.b_id = br.B_id
where ac.ac_balance = (select MAX(account.ac_balance) from account)
	AND ba.b_name like N'Ngân hàng Công thương Việt Nam'
group by cu.Cust_id,cu.Cust_name, ac.Ac_no, ac.ac_balance, br.BR_name, ba.b_name

-- Tìm người gửi tiền nhiều nhất vào VCB trong tháng 12 năm 2012
select cu.Cust_id,cu.Cust_name, ac.Ac_no as AC_NO, ac.ac_balance as balance, br.BR_name as branch, ba.b_name as bank
from transactions tr
inner join account ac ON ac.Ac_no = tr.ac_no
inner join customer cu ON cu.Cust_id= ac.cust_id
inner join Branch br ON br.BR_id = cu.Br_id
inner join Bank ba ON ba.b_id = br.B_id
where	ba.b_name like N'Ngân hàng Công thương Việt Nam'
		AND DATEPART(YEAR,tr.t_date) =2012 
		AND DATEPART(MONTH,tr.t_date) =12
		AND tr.t_type=1
group by cu.Cust_id,cu.Cust_name, ac.Ac_no, ac.ac_balance, br.BR_name, ba.b_name