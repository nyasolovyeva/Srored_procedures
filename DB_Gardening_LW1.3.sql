/*Уровень 1*/
/*1*/
CREATE TABLE Gardener
(
	id int primary key check (id > 0),
	name VARCHAR(100) not null,
	partnership VARCHAR(100) not null,
	benefit int not null check (benefit >= 0 AND benefit <= 100)
);

CREATE TABLE Plant_Nursery
(
	id int primary key check (id > 0),
	name VARCHAR(100) not null,
	partnership VARCHAR(100) not null,
	fee int not null check (fee >= 0 AND fee <= 100)
);

CREATE TABLE Plant
(
	id int primary key check (id > 0),
	sort VARCHAR(100) not null,
	partnership VARCHAR(100),
	price int not null check (price >= 0),
	quantity int not null check (quantity >= 0)
);

CREATE TABLE Purchase
(
	id int primary key,
	date VARCHAR(100) not null check (date IN ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 
                                                 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь')),
	id_Gardener int references Gardener (id) ON UPDATE CASCADE ON DELETE SET NULL,
	id_Plant_Nursery int references Plant_Nursery (id) ON UPDATE CASCADE ON DELETE SET NULL,
	id_Plant int references Plant (id) ON UPDATE CASCADE ON DELETE SET NULL,
	quantity int not null check (quantity > 0),
	Total_cost int not null check (Total_cost >= 0)
);

/*2*/
INSERT INTO Gardener VALUES
    ('001', 'Логовой', 'Радостное', 3),
    ('002', 'Шталенкова', 'Урожай', 3),
    ('003', 'Димин', 'Мичуринское', 3),
    ('004', 'Усольцева', 'Дальнее', 1),
    ('005', 'Кропинов', 'Мичуринское', 0);

INSERT INTO Plant_Nursery VALUES
    ('001', 'Ягодный', 'Радостное', 5),
    ('002', 'N1', 'Дальнее', 3),
    ('003', 'Ерофеев', 'Урожай', 4),
    ('004', '1976', 'Мичуринское', 5),
    ('005', 'N2', 'Дальнее', 3),
    ('006', 'За лесом', 'Солнечное', 6);

INSERT INTO Plant VALUES
    ('001', 'Малина', 'Радостное', 40000, 70),
    ('002', 'Клубника', 'Радостное', 32000, 61),
    ('003', 'Вишня', 'Дальнее', 51000, 28),
    ('004', 'Крыжовник', 'Урожай', 23000, 34),
    ('005', 'Яблоня', 'Солнечное', 47000, 12),
    ('006', 'Слива', 'Урожай', 44000, 7),
    ('007', 'Облепиха', 'Мичуринское', 52000, 9);

INSERT INTO Purchase VALUES
    ('00000', 'Январь', '003', '005', '004', 2, 46000),
    ('00001', 'Январь', '004', '004', '005', 5, 235000),
    ('00002', 'Январь', '004', '006', '002', 12, 384000),
    ('00003', 'Февраль', '001', '003', '003', 5, 255000),
    ('00004', 'Февраль', '001', '005', '006', 7, 308000),
    ('00005', 'Февраль', '002', '002', '003', 10, 510000),
    ('00006', 'Апрель', '003', '003', '005', 5, 235000),
    ('00007', 'Апрель', '004', '001', '001', 5, 200000),
    ('00008', 'Апрель', '005', '001', '006', 1, 44000),
    ('00009', 'Май', '002', '001', '006', 6, 264000),
    ('00010', 'Май', '003', '006', '003', 11, 561000),
    ('00011', 'Май', '004', '002', '001', 7, 280000),
    ('00012', 'Июнь', '002', '003', '005', 3, 141000),
    ('00013', 'Июнь', '002', '001', '002', 6, 202000),
    ('00014', 'Июнь', '004', '004', '004', 1, 23000),
    ('00015', 'Июнь', '005', '002', '001', 8, 320000),
    ('00016', 'Июнь', '002', '001', '003', 2, 102000);

/*3*/
SELECT * FROM Gardener;
SELECT * FROM Plant_Nursery;
SELECT * FROM Plant;
SELECT * FROM Purchase;

/*4*/
SELECT DISTINCT partnership
FROM Plant_Nursery;

SELECT DISTINCT partnership
FROM Plant;

SELECT DISTINCT date
FROM Purchase;

/*5*/
SELECT name, benefit
FROM Gardener
WHERE partnership IN ('Урожай');

SELECT name
FROM Gardener
WHERE partnership IN ('Радостное','Дальнее');

SELECT sort, price
FROM Plant
WHERE partnership IN ('Мичуринское') OR price > 30000;

/*6*/
SELECT Gardener.name, Plant_Nursery.name
FROM Purchase
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
JOIN Plant_Nursery ON Purchase.id_Plant_Nursery = Plant_Nursery.id;

SELECT Purchase.date, Gardener.name, Gardener.benefit, Plant.sort, Purchase.quantity
FROM Purchase
JOIN Plant ON Purchase.id_Plant = Plant.id
JOIN Gardener ON Purchase.id_Gardener = Gardener.id;

/*7*/
SELECT Purchase.id, Purchase.date, Gardener.name
FROM Purchase
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
WHERE Purchase.Total_cost >= 60000;

SELECT Gardener.name, Gardener.partnership, Purchase.date
FROM Purchase
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
JOIN Plant_Nursery ON Purchase.id_Plant_Nursery = Plant_Nursery.id
WHERE Gardener.partnership = Plant_Nursery.partnership
AND Purchase.date !='Январь' AND Purchase.date != 'Февраль'
ORDER BY Gardener.name, Purchase.date;

SELECT DISTINCT Plant_Nursery.partnership
FROM Plant_Nursery
JOIN Purchase ON Plant_Nursery.id = Purchase.id_Plant_Nursery
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
WHERE Plant_Nursery.partnership != 'Дальнее'
AND Gardener.benefit >= 1 AND Gardener.benefit <=2;

SELECT Plant.sort, Plant_Nursery.name AS Plant_Nursery, Purchase.quantity, Purchase.Total_cost
FROM Purchase
JOIN Plant ON Purchase.id_Plant = Plant.id
JOIN Plant_Nursery ON Purchase.id_Plant_Nursery = Plant_Nursery.id
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
WHERE Gardener.partnership = Plant.partnership
ORDER BY Purchase.Total_cost ASC;

/*8*/
UPDATE Purchase
SET Total_cost = Total_cost * (1 - (Gardener.benefit/100.0))
FROM Gardener
WHERE Purchase.id_Gardener = Gardener.id;
SELECT * FROM Purchase;

/*9*/
ALTER TABLE Purchase
ADD COLUMN fee int;
UPDATE Purchase
SET fee = (SELECT Plant_Nursery.fee 
		    FROM Plant_Nursery
			WHERE Purchase.id_Plant_Nursery = Plant_Nursery.id);
SELECT*FROM Purchase;

/*Уровень 2*/
/*10*/
/*a) 7b*/
SELECT Gardener.name, Gardener.partnership, Purchase.date
FROM Purchase
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
WHERE Purchase.id_Plant_Nursery IN (
    SELECT Plant_Nursery.id
    FROM Plant_Nursery
    WHERE Plant_Nursery.partnership = Gardener.partnership
)
AND Purchase.date NOT IN ('Январь', 'Февраль')
ORDER BY Gardener.name, Purchase.date;
/*a) 7d*/
SELECT Plant.sort, Plant_Nursery.name AS Plant_Nursery, Purchase.quantity, Purchase.total_cost
FROM Purchase
JOIN Plant ON Purchase.id_Plant = Plant.id
JOIN Plant_Nursery ON Purchase.id_Plant_Nursery = Plant_Nursery.id
WHERE Purchase.id_Gardener IN (
    SELECT Gardener.id
    FROM Gardener
    WHERE Gardener.partnership IN (
        SELECT Plant.partnership
        FROM Plant
        WHERE Plant.id = Purchase.id_Plant
    )
)
ORDER BY Purchase.total_cost ASC;

/*b)*/
SELECT Gardener.name
FROM Gardener
WHERE Gardener.id NOT IN (
    SELECT Purchase.id_Gardener
    FROM Purchase
    WHERE Purchase.id_Plant_Nursery IN (
        SELECT Plant_Nursery.id
        FROM Plant_Nursery
        WHERE partnership = 'Мичуринское'
    )
);

/*c)*/
SELECT Gardener.name
FROM Gardener
WHERE Gardener.id IN (
    SELECT Purchase.id_Gardener
    FROM Purchase
    WHERE Purchase.id_Plant IN (
        SELECT Plant.id
        FROM Plant
        WHERE sort = 'Вишня'
    )
);

/*11*/
/*a)*/
SELECT DISTINCT sort
FROM Plant 
WHERE Plant.price = ALL (SELECT MAX(price) FROM Plant)
  AND Plant.partnership = ANY (SELECT partnership 
                           FROM Plant_Nursery 
                           WHERE partnership = 'Дальнее');
					
/*b)*/
SELECT name 
FROM Gardener 
WHERE benefit > ALL (SELECT MIN(benefit) 
                     FROM Gardener);
/*c)*/
SELECT Plant_Nursery.name 
FROM Plant_Nursery 
WHERE Plant_Nursery.partnership != 'Урожай' 
  AND fee = ANY (SELECT Plant_Nursery.fee 
                 FROM Plant_Nursery 
                 WHERE Plant_Nursery.partnership = 'Урожай');

SELECT Purchase.id, Purchase.date, Gardener.name 
FROM Purchase
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
WHERE Purchase.Total_cost >= ANY (SELECT Total_cost 
                           FROM Purchase 
                           WHERE Total_cost >= 60000);

/*12*/
SELECT partnership FROM Gardener
UNION 
SELECT partnership FROM Plant_Nursery;

/*13*/
/*a)*/
SELECT DISTINCT Gardener.name
FROM Gardener 
WHERE NOT EXISTS (
    SELECT * FROM Plant 
    WHERE Plant.partnership = 'Солнечное' 
    AND NOT EXISTS (
        SELECT 1
        FROM Purchase
        WHERE Purchase.id_Gardener = Gardener.id
          AND Purchase.id_Plant = Plant.id
          AND Purchase.date IN ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь') 
    )
)
AND EXISTS (
    SELECT * FROM Purchase
    WHERE Purchase.id_Gardener = Gardener.id
      AND Purchase.date IN ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь')
)
AND NOT EXISTS (
    SELECT * FROM Purchase
    WHERE Purchase.id_Gardener = Gardener.id
      AND Purchase.date NOT IN ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь') 
);

/*b)*/
SELECT DISTINCT Plant.sort
FROM Plant 
WHERE EXISTS (
    SELECT 1
    FROM Plant_Nursery 
    WHERE Plant_Nursery.id = Plant.id
      AND Plant_Nursery.partnership = 'Урожай' 
)
AND NOT EXISTS (
    SELECT 1
    FROM Gardener 
    WHERE Gardener.benefit < 3
    AND NOT EXISTS (
        SELECT 1
        FROM Purchase 
        WHERE Purchase.id_Gardener = Gardener.id
          AND Purchase.id_Plant = Plant.id
          AND Purchase.id_Plant_Nursery IN (
              SELECT Plant_Nursery.id
              FROM Plant_Nursery 
              WHERE Plant_Nursery.partnership = 'Урожай' 
          )
    )
);

/*c)*/
SELECT DISTINCT Plant_Nursery.name
FROM Plant_Nursery
WHERE NOT EXISTS (
    SELECT * FROM Gardener 
    WHERE Gardener.benefit > 0 
      AND NOT EXISTS (
          SELECT * FROM Purchase
          WHERE Purchase.id_Gardener = Gardener.id
            AND Purchase.id_Plant_Nursery = Plant_Nursery.id
      )
)
AND NOT EXISTS (
    SELECT * FROM Gardener 
    WHERE Gardener.benefit = 0 
      AND EXISTS (
          SELECT * FROM Purchase
          WHERE Purchase.id_Gardener = Gardener.id
            AND Purchase.id_Plant_Nursery = Plant_Nursery.id
      )
);

/*d)*/
SELECT DISTINCT Gardener.name
FROM Gardener 
WHERE Gardener.benefit > (
    SELECT MIN(benefit)
    FROM Gardener
)
AND NOT EXISTS (
    SELECT * FROM Plant_Nursery 
    WHERE NOT EXISTS (
        SELECT * FROM Purchase 
        WHERE Purchase.id_Gardener = Gardener.id
          AND Purchase.id_Plant_Nursery = Plant_Nursery.id
    )
)
AND EXISTS (
    SELECT * FROM Purchase 
    WHERE Purchase.id_Gardener = Gardener.id
);

/*14*/
/*а)*/
SELECT COUNT(DISTINCT Plant.sort) AS number_of_plants
FROM Purchase
JOIN Plant ON Purchase.id_Plant = Plant.id
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
WHERE Gardener.partnership = 'Дальнее'
  AND Purchase.date IN ('Май', 'Июнь');

/*b)*/
SELECT SUM(Purchase.Total_cost) AS total_sold_cherry
FROM Purchase
JOIN Plant ON Purchase.id_Plant = Plant.id
WHERE Plant.sort = 'Вишня';

/*c)*/
WITH AvgTotalCost AS (
    SELECT AVG(Total_cost) AS Avg_Total_cost
    FROM Purchase)
SELECT Gardener.name, SUM(Purchase.Total_cost) AS Gardener_total_buy
FROM Purchase
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
GROUP BY Gardener.name
HAVING SUM(Purchase.Total_cost) > (SELECT Avg_Total_cost FROM AvgTotalCost);

/*d)*/
WITH AvgBenefit AS (
    SELECT AVG(benefit) AS Avg_benefit
    FROM Gardener),
GardenerLowBenefit AS (
    SELECT id
    FROM Gardener
    WHERE benefit < (SELECT Avg_benefit FROM AvgBenefit)
)
SELECT Plant_Nursery.name
FROM Plant_Nursery 
WHERE NOT EXISTS (
    SELECT * FROM GardenerLowBenefit
    WHERE NOT EXISTS (
        SELECT * FROM Purchase 
        WHERE Purchase.id_Gardener = GardenerLowBenefit.id
          AND Purchase.id_Plant_Nursery = Plant_Nursery.id
    )
);

/*15*/
/*a)*/
SELECT Plant.sort, COUNT(DISTINCT Purchase.id_Gardener) AS Buyers
FROM Plant
LEFT JOIN Purchase ON Plant.id = Purchase.id_Plant
GROUP BY Plant.id, Plant.sort;

/*b)*/
SELECT Purchase.date, SUM(Purchase.Total_cost) AS total_cost_a_month
FROM Purchase
JOIN Plant_Nursery ON Purchase.id_Plant_Nursery = Plant_Nursery.id
WHERE Plant_Nursery.partnership = 'Дальнее'
GROUP BY Purchase.date
HAVING SUM(Purchase.Total_cost) > 700000;

/*c)*/
SELECT Gardener.name, Plant.sort, COALESCE(SUM(Purchase.quantity), 0) AS Total_quantity
FROM Gardener
CROSS JOIN Plant
LEFT JOIN Purchase ON Gardener.id = Purchase.id_Gardener AND Plant.id = Purchase.id_Plant
GROUP BY Gardener.name, Plant.sort;


/*d)*/
SELECT Gardener.name, SUM(Purchase.Total_cost) AS Total_cost
FROM Purchase
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
JOIN Plant ON Purchase.id_Plant = Plant.id
WHERE Plant.sort = 'Крыжовник'
GROUP BY Gardener.name
HAVING SUM(Purchase.Total_cost) > 300000;


/*ЛАБОРАТОРНАЯ 1 МОДУЛЬ 3*/

/*№1*/
CREATE OR REPLACE FUNCTION Gardener_Purchase_Info (gardener_id INT)
RETURNS void 
AS $$
DECLARE
    gardener_info RECORD; 
    last_purchase RECORD;  
BEGIN
    SELECT * INTO gardener_info FROM Gardener WHERE id = gardener_id;
    
    /*Случай "Покупателя нет"*/
    IF NOT FOUND THEN
        RAISE INFO 'Садовод с таким идентификатором не найден';
        RETURN;
    END IF;
    
    SELECT Purchase.id, Purchase.date, Plant.sort, Purchase.Total_cost INTO last_purchase
    FROM Purchase
    JOIN Plant ON Purchase.id_Plant = Plant.id
    WHERE Purchase.id_Gardener = gardener_id
    ORDER BY 
		CASE Purchase.date 
			WHEN 'Январь' THEN 1 
			WHEN 'Февраль' THEN 2 
			WHEN 'Март' THEN 3 
			WHEN 'Апрель' THEN 4
			WHEN 'Май' THEN 5 
			WHEN 'Июнь' THEN 6 
			WHEN 'Июль' THEN 7 
			WHEN 'Август' THEN 8 
			WHEN 'Сентябрь'THEN 9 
			WHEN 'Октябрь' THEN 10
			WHEN 'Ноябрь' THEN 11 
			WHEN 'Декабрь' THEN 12
		END DESC, 
		Purchase.id DESC
    LIMIT 1;
    
    /*Случай "Покупатель есть и покупки не делал"*/
   IF last_purchase IS NULL THEN
        RAISE INFO 'Садовод: %, Товарищество: %. Покупок не совершал.', 
                   gardener_info.name, gardener_info.partnership;
				   
	 /*Случай "Покупатель есть и он делал покупки"*/
    ELSE
        RAISE INFO 'Садовод: %, Товарищество: %, Дата последней покупки: %, Сорт растения: %, Стоимость: %', 
                   gardener_info.name, gardener_info.partnership, last_purchase.date, last_purchase.sort, last_purchase.Total_cost;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT Gardener_Purchase_Info(005);


/*№2*/
DROP TABLE Gardener_Nursery;
DELETE FROM Purchase
WHERE id IN (00017, 00018);

/*№2*/
CREATE TABLE Gardener_Plant_Nursery (
    id INT primary key,
    gardener_id INT references Gardener(id) ON DELETE CASCADE,
    nursery_id INT references Plant_Nursery(id) ON DELETE CASCADE,
    UNIQUE (gardener_id, nursery_id)
);

INSERT INTO Gardener_Plant_Nursery (id, gardener_id, nursery_id) VALUES
    (001, 001, 001), 
	(002, 001, 002),
    (003, 002, 003), 
	(004, 002, 004),
    (005, 003, 005), 
	(006, 003, 006),
    (007, 004, 001), 
	(008, 004, 002), 
	(009, 005, 003),
    (010, 005, 004);

SELECT * FROM Gardener_Plant_Nursery;

CREATE OR REPLACE FUNCTION Add_Purchase_Pos(
    Purchase_id INT,
    Purchase_date VARCHAR(100), 
    Purchase_gardener_id INT, 
    Purchase_nursery_id INT, 
    Purchase_plant_id INT, 
    Purchase_quantity INT, 
    Purchase_total_cost INT
) 
RETURNS void 
AS $$
DECLARE
    work_possibility BOOLEAN;
    Purchase_fee INT;
BEGIN
   
    SELECT EXISTS (
        SELECT * FROM Gardener_Plant_Nursery  
        WHERE gardener_id = Purchase_gardener_id 
          AND nursery_id = Purchase_nursery_id
    ) INTO work_possibility;

    /*Если нет соответствия в таблице*/
    IF NOT work_possibility THEN
        RAISE EXCEPTION 'Садовод % не работает с питомником %', Purchase_gardener_id, Purchase_nursery_id;
    END IF;

    SELECT fee INTO Purchase_fee FROM Plant_Nursery WHERE id = Purchase_nursery_id;

    /*Если соответствие есть в таблице*/
    INSERT INTO Purchase (id, date, id_Gardener, id_Plant_Nursery, id_Plant, quantity, Total_cost, fee)
    VALUES (Purchase_id, Purchase_date, Purchase_gardener_id, Purchase_nursery_id, Purchase_plant_id, Purchase_quantity, Purchase_total_cost, Purchase_fee);
    
    RAISE NOTICE 'Покупка успешно добавлена для садовода %', Purchase_gardener_id;
END;
$$ LANGUAGE plpgsql;

SELECT Add_Purchase_Pos(00018, 'Август', 002, 003, 003, 2, 100000);
SELECT * FROM Purchase;

/*№3*/
CREATE OR REPLACE FUNCTION Calculate_Total_Cost()
RETURNS TRIGGER 
AS $$
DECLARE
    plant_price INT;
    gardener_benefit INT;
    calculated_cost INT;
BEGIN
 
    SELECT price INTO plant_price 
    FROM Plant 
    WHERE id = NEW.id_Plant;

	IF plant_price IS NULL THEN
        RAISE EXCEPTION 'Ошибка: Растение с id % не найдено', NEW.id_Plant;
    END IF;
	
    SELECT benefit INTO gardener_benefit
    FROM Gardener
    WHERE id = NEW.id_Gardener;

	 IF gardener_benefit IS NULL THEN
        RAISE EXCEPTION 'Ошибка: Садовод с id % не найден', NEW.id_Gardener;
    END IF;
    
    IF NEW.quantity IS NULL THEN
        RAISE EXCEPTION 'Ошибка: Количество растений не указано';
    END IF;

    IF NEW.Total_cost IS NULL THEN
        calculated_cost := plant_price * NEW.quantity;
        calculated_cost := calculated_cost * (100 - gardener_benefit) / 100;
        NEW.Total_cost := calculated_cost;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trigger_Calculate_Total_Cost
BEFORE INSERT ON Purchase
FOR EACH ROW
EXECUTE FUNCTION Calculate_Total_Cost();

SELECT Add_Purchase_Pos(00019, 'Февраль', 001, 001, 001, NULL, 34890);
SELECT * FROM Purchase;

/*№4*/
CREATE VIEW Purchase_View_new AS
SELECT 
    Purchase.id AS "Номер покупки", 
    Gardener.name AS "Фамилия садовода",  
    Gardener.benefit AS "Льгота", 
    Plant_Nursery.name AS "Название питомника", 
    Plant.sort AS "Сорт растения",  
    Purchase.date AS "Дата покупки", 
    (Plant.price * Purchase.quantity) 
    - (Plant.price * Purchase.quantity * Gardener.benefit / 100) AS "Стоимость" 
FROM 
    Purchase
JOIN Gardener ON Purchase.id_Gardener = Gardener.id
JOIN Plant_Nursery ON Purchase.id_Plant_Nursery = Plant_Nursery.id
JOIN Plant ON Purchase.id_Plant = Plant.id;

SELECT * FROM Purchase_View_new;

CREATE OR REPLACE FUNCTION Update_Gardener_Benefit()
RETURNS TRIGGER 
AS $$
BEGIN
    IF NEW."Льгота" IS NOT NULL THEN
        UPDATE Gardener 
        SET benefit = NEW."Льгота"
        WHERE name = NEW."Фамилия садовода";
    END IF;
    
UPDATE Purchase
    SET Total_cost = (SELECT (Plant.price * Purchase.quantity) - (Plant.price * Purchase.quantity * Gardener.benefit / 100) 
                      FROM Plant 
                      JOIN Gardener ON Purchase.id_Gardener = Gardener.id  
                      WHERE Plant.id = Purchase.id_Plant) 
    WHERE id = NEW."Номер покупки";  
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trigger_Update_Benefit
INSTEAD OF UPDATE ON Purchase_View_new
FOR EACH ROW
EXECUTE FUNCTION Update_Gardener_Benefit();

UPDATE Purchase_View_new
SET "Льгота" = 4
WHERE "Фамилия садовода" = 'Логовой';


SELECT * FROM Purchase;
SELECT * FROM Gardener;




