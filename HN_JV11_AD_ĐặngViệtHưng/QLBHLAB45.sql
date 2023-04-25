create database QLBH_DANGVIETHUNG;
use QLBH_DANGVIETHUNG;

create table Customer(
cID int not null primary key,
cName varchar(25),
cAge tinyint
);

create table `Order`(
oID int not null primary key,
cID int, foreign key (cID)references Customer(cID),
oDate datetime,
oTotalPrice int
);

create table Product(
pID int not null primary key,
pName varchar(25),
pPrice int
);

create table OrderDetail(
oID int,
pID int,
primary key(oID,pID),
foreign key (oID) references `Order` (oID),
foreign key (pID) references Product(pID),
odQTY int
);

insert into Customer(cID,cName,cAge) values
(1,"Minh Quan",10),
(2,"Ngoc Oanh",20),
(3,"Hong Ha",50);

insert into `Order`(oId,cID,oDate,oTotalPrice) values
(1,1,"2006-3-21",null),
(2,2,"2006-3-23",null),
(3,1,"2006-3-16",null);

insert into Product(pID,pName,pPrice)values
(1,"May Giat",3),
(2,"Tu Lanh",5),
(3,"Dieu Hoa",7),
(4,"Quat",1),
(5,"Bep Dien",2);

insert into OrderDetail(oID,pID,odQTY) values
(1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);

-- 2. Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơntrong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóađơn mới hơn nằm trên như hình sau
select oID , oDate, oTotalPrice from `Order` order by oDate desc;

-- 3. Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau:
select pName, pPrice from Product where pPrice =(select max(pPrice) from Product); 

-- 4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau
select cName,pName from Customer join `Order` on Customer.cID = `Order`.cID join OrderDetail on `Order`.oID = OrderDetail.oID join Product on Product.pID = OrderDetail.pID;

-- 5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
select cName from Customer where cID not in (select Customer.cID from Customer join `Order` on Customer.cId = `Order`.cID);

-- 6. Hiển thị chi tiết của từng hóa đơnnhư sau 
select OrderDetail.oID,oDate,odQTY,pName,pPrice from `Order` join OrderDetail on `Order`.oID= OrderDetail.oID join Product on Product.pID = OrderDetail.pID;

-- 7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn(giá mộthóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice) như
select `Order`.oID,oDate, sum(Product.pPrice * OrderDetail.odQTY) as Total from `Order` join OrderDetail on `Order`.oID = OrderDetail.oID join Product on OrderDetail.pId = Product.pID group by oID;

-- 8. Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị như
create view Sales as select sum(Product.pPrice * OrderDetail.odQTY) as Sales from `Order` join OrderDetail on `Order`.oID = OrderDetail.oID join Product on OrderDetail.pId = Product.pID;

-- 9. Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng.
alter table `Order` drop constraint order_ibfk_1;
alter table OrderDetail drop constraint orderdetail_ibfk_1;
alter table OrderDetail drop constraint orderdetail_ibfk_2;
alter table Customer drop primary key;
alter table `Order` drop primary key;
alter table Product drop primary key;
alter table OrderDetail drop primary key;

-- 10
CREATE TRIGGER cusUpdate AFTER UPDATE ON Customer
FOR EACH ROW
BEGIN
    UPDATE `Order` SET cID = NEW.cID WHERE cID = OLD.cID
END

-- 11. Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail:
DELIMITER //
create procedure delProduct(IN pName varchar(25))
begin
select * from OrderDetail;
end //
DELIMITER ;
show create procedure delProduct ;