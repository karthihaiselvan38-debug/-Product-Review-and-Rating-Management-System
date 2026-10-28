
create database  review_db;
use review_db;

create table customers (
    customer_id int primary key,
    customer_name varchar(100) not null,
    email varchar(100) unique
);
create table products (
    product_id int primary key,
    product_name varchar(100) not null,
    price decimal(10,2) not null,
    check (price > 0)
);

create table review (
    review_id int primary key auto_increment,
    customer_id int not null,
    product_id int not null,
    rating int not null,
    review_text varchar(500),
    review_date datetime not null default current_timestamp,

    foreign key (customer_id)
        references customers(customer_id),

    foreign key (product_id)
        references products(product_id),

    check (rating between 1 and 5)
);

insert into customers
values
(1, 'arun', 'arun@gmail.com'),
(2, 'bala', 'bala@gmail.com'),
(3, 'divya', 'divya@gmail.com'),
(4, 'kumar', 'kumar@gmail.com'),
(5, 'priya', 'priya@gmail.com');


insert into products
values
(101, 'laptop', 45000.00),
(102, 'mobile', 20000.00),
(103, 'headphone', 1500.00),
(104, 'keyboard', 800.00),
(105, 'mouse', 500.00),
(106, 'smartwatch', 3000.00);

insert into review
(customer_id, product_id, rating, review_text, review_date)
values
(1, 101, 5, 'excellent product', '2026-10-20 10:00:00'),
(2, 101, 4, 'good quality', '2026-10-21 11:00:00'),
(3, 102, 5, 'very nice mobile', '2026-10-22 12:00:00'),
(4, 102, 3, 'average product', '2026-10-23 13:00:00'),
(5, 103, 2, 'sound quality is low', '2026-10-24 14:00:00'),
(1, 103, 4, 'good sound', '2026-10-25 15:00:00'),
(2, 104, 5, 'easy to use', '2026-10-26 16:00:00'),
(3, 104, 3, 'average quality', '2026-10-27 17:00:00'),
(4, 105, 1, 'poor quality', '2026-10-27 18:00:00'),
(5, 106, 5, 'excellent smartwatch', '2026-10-28 10:00:00');

select * from review;

insert into review
(customer_id, product_id, rating, review_text)
values
(1, 102, 5, 'excellent mobile');

select *
from review
where product_id = 101;

select
    c.customer_name,
    p.product_name,
    r.rating,
    r.review_text,
    r.review_date
from review r
join customers c
    on r.customer_id = c.customer_id
join products p
    on r.product_id = p.product_id;
    
select *
from review
order by review_date desc;

select *
from review
where rating > 4;

update review
set review_text = 'excellent quality and performance'
where review_id = 1;

update review
set rating = 4
where review_id = 1;

select
    p.product_id,
    p.product_name,
    round(avg(r.rating), 2) as average_rating
from products p
left join review r
    on p.product_id = r.product_id
group by p.product_id, p.product_name;

select
    p.product_name,
    count(r.review_id) as total_reviews
from products p
left join review r
    on p.product_id = r.product_id
group by p.product_id, p.product_name;

select
    p.product_name,
    round(avg(r.rating), 2) as average_rating
from products p
join review r
    on p.product_id = r.product_id
group by p.product_id, p.product_name
having avg(r.rating) = (
    select max(avg_rating)
    from (
        select avg(rating) as avg_rating
        from review
        group by product_id
    ) as product_ratings
);

select
    p.product_name,
    round(avg(r.rating), 2) as average_rating
from products p
join review r
    on p.product_id = r.product_id
group by p.product_id, p.product_name
having avg(r.rating) > 4;

select
    p.product_name,
    count(r.review_id) as total_reviews
from products p
join review r
    on p.product_id = r.product_id
group by p.product_id, p.product_name
having count(r.review_id) = (
    select max(review_count)
    from (
        select count(*) as review_count
        from review
        group by product_id
    ) as product_reviews
);

select
    p.product_name,
    count(r.review_id) as total_reviews
from products p
left join review r
    on p.product_id = r.product_id
group by p.product_id, p.product_name
order by total_reviews desc;

select
    p.product_name,
    round(avg(r.rating), 2) as average_rating,
    count(r.review_id) as total_reviews
from products p
join review r
    on p.product_id = r.product_id
group by p.product_id, p.product_name
having avg(r.rating) < 3;

select count(*) as five_star_reviews
from review
where rating = 5;

select count(*) as four_star_reviews
from review
where rating = 4;

select count(*) as low_rated_reviews
from review
where rating <= 2;

select
    p.product_id,
    p.product_name,
    count(r.review_id) as total_reviews,
    round(avg(r.rating), 2) as average_rating
from products p
left join review r
    on p.product_id = r.product_id
group by p.product_id, p.product_name
order by average_rating desc;

select
    c.customer_name,
    count(r.review_id) as total_reviews,
    round(avg(r.rating), 2) as average_rating_given
from customers c
left join review r
    on c.customer_id = r.customer_id
group by c.customer_id, c.customer_name;

select
    c.customer_name,
    p.product_name,
    r.review_text,
    r.rating
from review r
join customers c
    on r.customer_id = c.customer_id
join products p
    on r.product_id = p.product_id
where r.rating = 5;

select
    c.customer_name,
    p.product_name,
    r.rating,
    r.review_text
from review r
join customers c
    on r.customer_id = c.customer_id
join products p
    on r.product_id = p.product_id
where r.rating <= 2;

select *
from review
where review_date between '2026-10-20 00:00:00'
and '2026-10-28 23:59:59';

select
    c.customer_name,
    p.product_name,
    r.rating,
    r.review_text,
    r.review_date
from review r
join customers c
    on r.customer_id = c.customer_id
join products p
    on r.product_id = p.product_id
where c.customer_id = 1;

select
    p.product_id,
    p.product_name
from products p
left join review r
    on p.product_id = r.product_id
where r.review_id is null;

select
    rating,
    count(*) as total_reviews
from review
group by rating
order by rating desc;

select
    p.product_name,
    r.rating,
    r.review_text
from products p
left join review r
    on p.product_id = r.product_id
order by p.product_name;

select *
from review
order by rating desc;

select *
from review
order by rating asc;

select count(*) as total_reviews
from review;

select round(avg(rating), 2) as overall_average_rating
from review;

select * from review;
