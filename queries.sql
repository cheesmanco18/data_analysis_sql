-- isolate the transactions of each cardholder
CREATE VIEW transactions_by_cardholder AS
SELECT credit_card.cardholder_id, transaction.date, transaction.amount
FROM credit_card
INNER JOIN transaction ON credit_card.card = transaction.card
ORDER BY credit_card.cardholder_id;


-- count transactions that are less than $2.00 per cardholder
CREATE VIEW num_transactions_under_2_by_cardholder AS
SELECT credit_card.cardholder_id, COUNT(transaction.id) as number_transactions
FROM credit_card
INNER JOIN transaction ON credit_card.card = transaction.card
WHERE transaction.amount < 2.00
GROUP BY credit_card.cardholder_id;


-- identify the highest transactions made between 7-9am
CREATE VIEW highest_transactions_7_to_9 AS
SELECT *
FROM transaction
WHERE EXTRACT(HOUR FROM transaction.date) >= 7
AND EXTRACT(HOUR FROM transaction.date) < 9
ORDER BY transaction.amount DESC
LIMIT 100;

-- identify the highest transactions made outside of 7-9am
CREATE VIEW highest_transactions_outside_7_to_9 AS
SELECT *
FROM transaction
WHERE EXTRACT(HOUR FROM transaction.date) < 7
OR EXTRACT(HOUR FROM transaction.date) >= 9
ORDER BY transaction.amount DESC
LIMIT 100;


-- Top 5 merchants prone to being hacked using small transactions
CREATE VIEW num_small_transactions_by_merchant AS
SELECT merchant.name, COUNT(transaction.id) as number_transactions
FROM merchant
INNER JOIN transaction ON merchant.id = transaction.id_merchant
WHERE transaction.amount < 2.00
GROUP BY merchant.id
ORDER BY number_transactions DESC
LIMIT 5;
