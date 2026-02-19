-- Опис домашнього завдання

-- 1. Створіть базу даних для керування бібліотекою книг згідно зі структурою, наведеною нижче. 
-- Використовуйте DDL-команди для створення необхідних таблиць та їх зв'язків.
-- Структура БД

-- a) Назва схеми — “LibraryManagement”
CREATE SCHEMA LibraryManagement;

USE LibraryManagement;

-- b) Таблиця "authors":
-- author_id (INT, автоматично зростаючий PRIMARY KEY)
-- author_name (VARCHAR)

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(50)
);
    
-- c) Таблиця "genres":
-- genre_id (INT, автоматично зростаючий PRIMARY KEY)
-- genre_name (VARCHAR)

CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50)
);

-- d) Таблиця "books":
-- book_id (INT, автоматично зростаючий PRIMARY KEY)
-- title (VARCHAR)
-- publication_year (YEAR)
-- author_id (INT, FOREIGN KEY зв'язок з "Authors")
-- genre_id (INT, FOREIGN KEY зв'язок з "Genres")

CREATE TABLE books (
   book_id INT AUTO_INCREMENT PRIMARY KEY,
   title VARCHAR (50),
   publication_year YEAR,
   author_id INT,
   genre_id INT,
   FOREIGN KEY (author_id) REFERENCES authors (author_id),
   FOREIGN KEY (genre_id) REFERENCES genres (genre_id)
);

-- e) Таблиця "users":
-- user_id (INT, автоматично зростаючий PRIMARY KEY)
-- username (VARCHAR)
-- email (VARCHAR)

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR (50),
    email VARCHAR (50)
);

-- f) Таблиця "borrowed_books":
-- borrow_id (INT, автоматично зростаючий PRIMARY KEY)
-- book_id (INT, FOREIGN KEY зв'язок з "Books")
-- user_id (INT, FOREIGN KEY зв'язок з "Users")
-- borrow_date (DATE)
-- return_date (DATE)

CREATE TABLE borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
	book_id INT,
	user_id INT,
	borrow_date DATE ,
	return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books (book_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- 2. Заповніть таблиці простими видуманими тестовими даними. 
-- Достатньо одного-двох рядків у кожну таблицю.

INSERT INTO authors (author_id, author_name) 
VALUES (1, 'Sergii Zhadan');

INSERT INTO genres (genre_id, genre_name)
VALUES (1, 'Historical');

INSERT INTO books (book_id, title, publication_year, author_id, genre_id)
VALUES (1, 'History', 1998, 1, 1);

INSERT INTO users (user_id, username, email)
VALUES (1, 'Vasyl Petrenko', 'Vaska@gmail.com');

INSERT INTO borrowed_books (borrow_id, book_id, user_id, borrow_date, return_date)
VALUES (1, 1, 1, '2026-02-18', '2026-04-01');


-- 3. Перейдіть до бази даних, з якою працювали у темі 3. 
-- Напишіть запит за допомогою операторів FROM та INNER JOIN, 
-- що об’єднує всі таблиці даних, які ми завантажили з файлів: 
-- order_details, orders, customers, products, categories, employees, shippers, suppliers. 
-- Для цього ви маєте знайти спільні ключі.

-- Перевірте правильність виконання запиту.

USE topic3;

SELECT * 
FROM order_details od
 INNER JOIN orders o
 ON od.order_id = o.id
  INNER JOIN customers cust
  ON o.customer_id = cust.id
   INNER JOIN products p
   ON od.product_id = p.id
    INNER JOIN categories cat
    ON p.category_id = cat.id
     INNER JOIN employees e
     ON o.employee_id = e.employee_id
      INNER JOIN shippers sh
      ON o.shipper_id = sh.id
       INNER JOIN suppliers sup
       ON p.supplier_id = sup.id ; 

-- 4. Виконайте запити, перелічені нижче.
-- 4.1. Визначте, скільки рядків ви отримали (за допомогою оператора COUNT).
-- 💡 Не забувайте робити скриншоти результатів і запитів
SELECT count(*) as number_of_rows_inner
FROM order_details od
 INNER JOIN orders o
 ON od.order_id = o.id
  INNER JOIN customers cust
  ON o.customer_id = cust.id
   INNER JOIN products p
   ON od.product_id = p.id
    INNER JOIN categories cat
    ON p.category_id = cat.id
     INNER JOIN employees e
     ON o.employee_id = e.employee_id
      INNER JOIN shippers sh
      ON o.shipper_id = sh.id
       INNER JOIN suppliers sup
       ON p.supplier_id = sup.id ; -- Відповідь: ми отримали 518 рядків

-- 4.2. Змініть декілька операторів INNER на LEFT чи RIGHT. 
-- Визначте, що відбувається з кількістю рядків. Чому? Напишіть відповідь у текстовому файлі.
SELECT count(*) as number_of_rows_left_right_inner
FROM order_details od
 RIGHT JOIN orders o
 ON od.order_id = o.id
  INNER JOIN customers cust
  ON o.customer_id = cust.id
   LEFT JOIN products p
   ON od.product_id = p.id
    INNER JOIN categories cat
    ON p.category_id = cat.id
     RIGHT JOIN employees e
     ON o.employee_id = e.employee_id
      LEFT JOIN shippers sh
      ON o.shipper_id = sh.id
       INNER JOIN suppliers sup
       ON p.supplier_id = sup.id ; -- Відповідь: ми знову отримали 518 рядків

-- check manually
-- SELECT count(distinct id) from orders; -- Відповідь: 196
-- SELECT count(distinct order_id) from order_details; -- Відповідь: 196


-- У випадку зміни INNER JOIN на LEFT JOIN чи RIGHT JOIN кількість рядків залишається незмінною = 518, 
-- оскільки в усіх таблицях з FOREIGN KEY присутні всі зразки з кожної таблиці з PRIMARY KEY, 
-- і навпаки в усіх таблицях з PRIMARY KEY присутні всі зразки з кожної таблиці з FOREIGN KEY.
-- Це явище називається Referential Integrity (цілісність посилань). 
-- В ідеальній базі даних (як навчальна topic3) немає "сиріт" 
-- (ордерів без клієнтів або товарів без категорій).
-- У реальному житті, якби ми змінили INNER на LEFT JOIN для таблиці customers, 
-- а в замовленнях був би customer_id, якого вже не існує в таблиці клієнтів (або NULL), 
-- кількість рядків могла б змінитися або з'явилися б NULL значення.

-- 4.3. На основі запита з пункта 3 виконайте наступне: оберіть тільки ті рядки, 
-- 4.3.1. де employee_id > 3 та ≤ 10.
-- 4.3.2. Згрупуйте за іменем категорії, порахуйте кількість рядків у групі, 
-- середню кількість товару (кількість товару знаходиться в order_details.quantity)
-- 4.3.3. Відфільтруйте рядки, де середня кількість товару більша за 21.
-- 4.3.4. Відсортуйте рядки за спаданням кількості рядків.
-- 4.3.5. Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком.

SELECT cat.name, COUNT(od.id) as number_of_rows_inner, AVG(od.quantity) as average_quantity 
FROM order_details od
 INNER JOIN orders o
 ON od.order_id = o.id
  INNER JOIN customers cust
  ON o.customer_id = cust.id
   INNER JOIN products p
   ON od.product_id = p.id
    INNER JOIN categories cat
    ON p.category_id = cat.id
     INNER JOIN employees e
     ON o.employee_id = e.employee_id
      INNER JOIN shippers sh
      ON o.shipper_id = sh.id
       INNER JOIN suppliers sup
       ON p.supplier_id = sup.id
WHERE  o.employee_id > 3 AND o.employee_id <= 10
GROUP BY cat.name
HAVING average_quantity > 21
ORDER BY number_of_rows_inner DESC
LIMIT 4
OFFSET 1
;



