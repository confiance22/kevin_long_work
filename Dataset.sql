-- create_tables.sql

CREATE TABLE customers (
  customer_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  region VARCHAR2(50),
  created_date DATE
);

CREATE TABLE products (
  product_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  category VARCHAR2(50),
  price NUMBER(12,2)
);

CREATE TABLE transactions (
  transaction_id NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES customers(customer_id),
  product_id NUMBER REFERENCES products(product_id),
  sale_date DATE,
  quantity NUMBER,
  amount NUMBER(12,2)
);



-- sample_inserts.sql
-- Insert multiple customers
INSERT INTO customers VALUES (1001, 'John Doe', 'Kigali', TO_DATE('2022-01-10','YYYY-MM-DD'));
INSERT INTO customers VALUES (1002, 'Alice Mwami', 'Gisenyi', TO_DATE('2022-02-05','YYYY-MM-DD'));
INSERT INTO customers VALUES (1003, 'Emmanuel K', 'Butare', TO_DATE('2022-03-12','YYYY-MM-DD'));
INSERT INTO customers VALUES (1004, 'Grace N', 'Kigali', TO_DATE('2022-04-20','YYYY-MM-DD'));
INSERT INTO customers VALUES (1005, 'Paul T', 'Gisenyi', TO_DATE('2023-01-08','YYYY-MM-DD'));
INSERT INTO customers VALUES (1006, 'Sara L', 'Butare', TO_DATE('2023-02-11','YYYY-MM-DD'));
INSERT INTO customers VALUES (1007, 'Mark R', 'Kigali', TO_DATE('2023-03-09','YYYY-MM-DD'));
INSERT INTO customers VALUES (1008, 'Nadine O', 'Gisenyi', TO_DATE('2023-05-21','YYYY-MM-DD'));

-- Insert products
INSERT INTO products VALUES (2001, 'Coffee Beans - Arabica', 'Beverages', 25.00);
INSERT INTO products VALUES (2002, 'Instant Coffee 200g', 'Beverages', 12.50);
INSERT INTO products VALUES (2003, 'French Press', 'Accessories', 40.00);
INSERT INTO products VALUES (2004, 'Mug - Ceramic', 'Accessories', 6.00);
INSERT INTO products VALUES (2005, 'Espresso Roast', 'Beverages', 22.00);
INSERT INTO products VALUES (2006, 'Cold Brew Bottle', 'Accessories', 15.00);

-- Insert transactions (spanning 2024 months, varied values)
INSERT INTO transactions VALUES (3001, 1001, 2001, TO_DATE('2024-01-15','YYYY-MM-DD'), 2, 50.00);
INSERT INTO transactions VALUES (3002, 1002, 2002, TO_DATE('2024-01-20','YYYY-MM-DD'), 1, 12.50);
INSERT INTO transactions VALUES (3003, 1003, 2001, TO_DATE('2024-02-10','YYYY-MM-DD'), 3, 75.00);
INSERT INTO transactions VALUES (3004, 1004, 2003, TO_DATE('2024-02-15','YYYY-MM-DD'), 1, 40.00);
INSERT INTO transactions VALUES (3005, 1001, 2002, TO_DATE('2024-02-20','YYYY-MM-DD'), 2, 25.00);
INSERT INTO transactions VALUES (3006, 1002, 2004, TO_DATE('2024-03-05','YYYY-MM-DD'), 4, 24.00);
INSERT INTO transactions VALUES (3007, 1005, 2001, TO_DATE('2024-03-18','YYYY-MM-DD'), 5, 125.00);
INSERT INTO transactions VALUES (3008, 1006, 2005, TO_DATE('2024-04-01','YYYY-MM-DD'), 2, 44.00);
INSERT INTO transactions VALUES (3009, 1007, 2001, TO_DATE('2024-04-12','YYYY-MM-DD'), 1, 25.00);
INSERT INTO transactions VALUES (3010, 1008, 2006, TO_DATE('2024-04-22','YYYY-MM-DD'), 3, 45.00);
INSERT INTO transactions VALUES (3011, 1001, 2005, TO_DATE('2024-05-05','YYYY-MM-DD'), 2, 44.00);
INSERT INTO transactions VALUES (3012, 1002, 2001, TO_DATE('2024-05-15','YYYY-MM-DD'), 1, 25.00);
INSERT INTO transactions VALUES (3013, 1003, 2002, TO_DATE('2024-06-07','YYYY-MM-DD'), 2, 25.00);
INSERT INTO transactions VALUES (3014, 1004, 2004, TO_DATE('2024-06-20','YYYY-MM-DD'), 6, 36.00);
INSERT INTO transactions VALUES (3015, 1005, 2003, TO_DATE('2024-07-03','YYYY-MM-DD'), 1, 40.00);
INSERT INTO transactions VALUES (3016, 1006, 2001, TO_DATE('2024-07-10','YYYY-MM-DD'), 4, 100.00);
INSERT INTO transactions VALUES (3017, 1007, 2005, TO_DATE('2024-08-12','YYYY-MM-DD'), 1, 22.00);
INSERT INTO transactions VALUES (3018, 1008, 2002, TO_DATE('2024-08-21','YYYY-MM-DD'), 2, 25.00);
INSERT INTO transactions VALUES (3019, 1001, 2001, TO_DATE('2024-09-01','YYYY-MM-DD'), 3, 75.00);
INSERT INTO transactions VALUES (3020, 1002, 2006, TO_DATE('2024-09-05','YYYY-MM-DD'), 1, 15.00);
INSERT INTO transactions VALUES (3021, 1003, 2001, TO_DATE('2024-10-14','YYYY-MM-DD'), 2, 50.00);
INSERT INTO transactions VALUES (3022, 1004, 2003, TO_DATE('2024-10-20','YYYY-MM-DD'), 1, 40.00);
INSERT INTO transactions VALUES (3023, 1005, 2001, TO_DATE('2024-11-03','YYYY-MM-DD'), 2, 50.00);
INSERT INTO transactions VALUES (3024, 1006, 2004, TO_DATE('2024-11-22','YYYY-MM-DD'), 5, 30.00);
INSERT INTO transactions VALUES (3025, 1007, 2002, TO_DATE('2024-12-01','YYYY-MM-DD'), 3, 37.50);
INSERT INTO transactions VALUES (3026, 1008, 2005, TO_DATE('2024-12-15','YYYY-MM-DD'), 2, 44.00);

COMMIT;

