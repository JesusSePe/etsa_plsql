/*
Consulta que mostri les dades del comanda que l’usuari introdueix per teclat. Introduirà el codi del venedor (CONSULTA COMANDA CODI).
*/
set verify off
CREATE OR REPLACE FUNCTION CONSULTA_COMANDA_CODI RETURN VARCHAR2 AS 
v_code VARCHAR2(32767):='&codi_de_comanda';
v_num NUMBER;
v_comanda ORDER2%ROWTYPE;
v_client CUSTOMER.CUSTOMER_NAME%TYPE;
v_proveidor SUPPLIER.SUPPLIER_NAME%TYPE;
v_producte PRODUCT.DESCRIPTION%TYPE;
v_txt VARCHAR2(32767);
BEGIN
    IF (VALIDATE_CONVERSION(v_code AS NUMBER) = 1) THEN
        v_num := TO_NUMBER(v_code);
    ELSE
        RAISE VALUE_ERROR;
    END IF;
    SELECT * INTO v_comanda FROM ORDER2 WHERE order_code = v_num;
    SELECT customer_name INTO v_client FROM CUSTOMER WHERE customer_code = v_comanda.customer_code;
    SELECT supplier_name INTO v_proveidor FROM SUPPLIER WHERE supplier_code = v_comanda.supplier_code;
    SELECT description INTO v_producte FROM PRODUCT WHERE product_code = v_comanda.product_code;
    v_txt := (          'Codi de comanda: '||v_num||chr(13)||chr(10)||
                        'Data de comanda: '||v_comanda.order_date||chr(13)||chr(10)||
                        'Client: '|| v_client ||chr(13)||chr(10)||
                        'Proveidor: '||v_proveidor||chr(13)||chr(10)||
                        'Producte: '||v_producte||chr(13)||chr(10)||
                        'Quantitat: '||v_comanda.quantity||chr(13)||chr(10)||
                        'Total: ' || v_comanda.total_amount
            );
    RETURN v_txt;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        v_txt := 'El codi de comanda no ha estat trobat';
        RETURN v_txt;
    WHEN VALUE_ERROR THEN
        v_txt := 'El codi de comanda ha de ser un número';
        RETURN v_txt;
    WHEN OTHERS THEN
        v_txt := 'El codi de comanda ha de ser un número i sense comes o cometes.';
        RETURN v_txt;
END;
/

/*
Consulta que mostri totes les comandes (CONSULTA_COMANDES), ordenats en
ordre pel codi del client i que aparegui a més, l'import total amb IVA
(aplicant un 16% d'IVA).
*/

CREATE OR REPLACE FUNCTION CONSULTA_COMANDES RETURN VARCHAR2 AS
v_txt VARCHAR2(32767);
CURSOR c_com IS SELECT ord.order_code, ord.order_date, cu.customer_name, ord.product_code, ord.quantity, ord.total_amount, ord.total_amount*1.16 AS "TOTAL" 
                FROM ORDER2 ord 
                INNER JOIN CUSTOMER cu ON ord.CUSTOMER_CODE = cu.CUSTOMER_CODE 
                ORDER BY ord.customer_code;
v_com c_com%ROWTYPE;
BEGIN
    OPEN c_com;
    LOOP
        FETCH c_com INTO v_com;
        EXIT WHEN c_com%NOTFOUND;
        v_txt := v_txt||('Codi de comanda: '||v_com.order_code||chr(13)||chr(10)||
                            'Data de comanda: '||v_com.order_date||chr(13)||chr(10)||
                            'Client: '|| v_com.customer_name ||chr(13)||chr(10)||
                            'Producte: '||v_com.product_code||chr(13)||chr(10)||
                            'Quantitat: '||v_com.quantity||chr(13)||chr(10)||
                            'Total: '||v_com.total_amount||'€'||chr(13)||chr(10)||
                            'Total amb IVA: ' || v_com.total||'€'||chr(13)||chr(10)||chr(13)||chr(10)
                                );
    END LOOP;
    return v_txt;
END;
/

/*
Consulta que mostri les comandes d'una data determinada. Aquesta data
l'ha d'introduir l'usuari per teclat. (CONSULTA_COMANDA_DATA);
*/
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE CONSULTA_COMANDA_DATA AS
v_date date;
v_input VARCHAR2(32767):='&Data_de_la_comanda';
CURSOR c_com (input_date DATE) IS SELECT ord.order_code, ord.order_date, cu.customer_name, ord.product_code, ord.quantity, ord.total_amount, ord.total_amount*1.16 AS "TOTAL"  
                                                    FROM ORDER2 ord 
                                                    INNER JOIN CUSTOMER cu ON ord.CUSTOMER_CODE = cu.CUSTOMER_CODE  
                                                    WHERE order_date like to_date(input_date, 'dd-mm-yyyy');
v_com c_com%ROWTYPE;
BEGIN
    IF (VALIDATE_CONVERSION(v_input AS DATE) = 1) THEN
        v_date := TO_DATE(v_input);
    ELSE
        RAISE VALUE_ERROR;
    END IF;
    OPEN c_com(v_date);
    LOOP
        FETCH c_com INTO v_com;
        EXIT WHEN c_com%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Codi de comanda: '||v_com.order_code||chr(13)||chr(10)||
                            'Data de comanda: '||v_com.order_date||chr(13)||chr(10)||
                            'Client: '|| v_com.customer_name ||chr(13)||chr(10)||
                            'Producte: '||v_com.product_code||chr(13)||chr(10)||
                            'Quantitat: '||v_com.quantity||chr(13)||chr(10)||
                            'Total: '||v_com.total_amount||'€'||chr(13)||chr(10)||
                            'Total amb IVA: ' || v_com.total||'€'||chr(13)||chr(10)||chr(13)||chr(10)
                                );
    END LOOP;
    CLOSE c_com;
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE( 'Format de data incorrecte. Torna a intentar-ho amb format dd/mm/yyyy');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se ha trobat cap comanda amb aquesta data.');
END;
/


/*
Consulta que mostri les comandes d'un client determinat. El codi del client ho introduirà per teclat l'usuari.
(CONSULTA_COMANDES_CLIENT)
*/
SET SERVEROUTPUT ON
SET VERIFY OFF
CREATE OR REPLACE PROCEDURE CONSULTA_COMANDES_CLIENT AS 
    v_cod NUMBER(9,0);
    CURSOR c_com (input_cod NUMBER) IS SELECT * from order2 where customer_code = input_cod;
    v_com c_com%ROWTYPE;
    v_count NUMBER;
BEGIN
    v_cod:='&Codi_de_client';
    SELECT COUNT(*) INTO v_count FROM ORDER2 WHERE CUSTOMER_CODE = v_cod;
    IF (v_count = 0) THEN RAISE NO_DATA_FOUND; END IF;
    FOR v_com in c_com(v_cod) LOOP
        DBMS_OUTPUT.PUT_LINE('Codi de comanda: '||v_com.order_code||chr(13)||chr(10)||
                            'Data de comanda: '||v_com.order_date||chr(13)||chr(10)||
                            'Producte: '||v_com.product_code||chr(13)||chr(10)||
                            'Quantitat: '||v_com.quantity||chr(13)||chr(10)||
                            'Total: '||v_com.total_amount||'€'||chr(13)||chr(10)
                            );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se ha trobat el client');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('El codi de client ha de ser numeric');
END;
/
/*
Consulta que mostri les comandes d’un venedor determinat. El codi del venedor ho introduirà per teclat l’usuari
(CONSULTA COMANDES VENEDOR).
*/
SET SERVEROUTPUT ON
SET VERIFY OFF
CREATE OR REPLACE PROCEDURE CONSULTA_COMANDES_VENEDOR AS 
    v_cod NUMBER(9,0);
    CURSOR c_com (input_cod NUMBER) IS SELECT * from order2 where supplier_code = input_cod;
    v_com c_com%ROWTYPE;
    v_count NUMBER;
BEGIN
    v_cod:='&Codi_de_venedor';
    SELECT COUNT(*) INTO v_count FROM ORDER2 WHERE SUPPLIER_CODE = v_cod;
    IF (v_count = 0) THEN RAISE NO_DATA_FOUND; END IF;
    FOR v_com in c_com(v_cod) LOOP
        DBMS_OUTPUT.PUT_LINE('Codi de comanda: '||v_com.order_code||chr(13)||chr(10)||
                            'Data de comanda: '||v_com.order_date||chr(13)||chr(10)||
                            'Producte: '||v_com.product_code||chr(13)||chr(10)||
                            'Quantitat: '||v_com.quantity||chr(13)||chr(10)||
                            'Total: '||v_com.total_amount||'€'||chr(13)||chr(10)
                            );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se ha trobat el venedor');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('El codi de venedor ha de ser numeric');
END;
/

/*Consulta que mostri les comandes d’un producte determinat. El codi del producte ho 
introduirà per teclat l’usuari (CONSULTA COMANDES PRODUCTE).*/

SET SERVEROUTPUT ON
SET VERIFY OFF
CREATE OR REPLACE PROCEDURE CONSULTA_COMANDES_PRODUCTE AS 
    v_cod VARCHAR2(8);
    CURSOR c_com (input_cod VARCHAR) IS SELECT * from order2 where product_code = input_cod;
    v_com c_com%ROWTYPE;
    v_count NUMBER;
BEGIN
    v_cod:='&Codi_de_producte';
    SELECT COUNT(*) INTO v_count FROM ORDER2 WHERE PRODUCT_CODE = v_cod;
    IF (v_count = 0) THEN RAISE NO_DATA_FOUND; END IF;
    FOR v_com in c_com(v_cod) LOOP
        DBMS_OUTPUT.PUT_LINE('Codi de comanda: '||v_com.order_code||chr(13)||chr(10)||
                            'Data de comanda: '||v_com.order_date||chr(13)||chr(10)||
                            'Producte: '||v_com.product_code||chr(13)||chr(10)||
                            'Quantitat: '||v_com.quantity||chr(13)||chr(10)||
                            'Total: '||v_com.total_amount||'€'||chr(13)||chr(10)
                            );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se ha trobat el producte.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('El codi de venedor ha de ser alfanumeric de 8 caracters.');
END;
/
/*
Tractament històrics comandes : la idea és tenir la possibilitat de poder passar les comandes que estan a S
a una nova taula i esborrar-les de la taula COMANDA. Aquesta nova tala s’anomenarà COMANDA HISTORIC i serà de
la mateixa estructura que la taula COMANDA. Aquesta opció es realitzarà quan l’usuari cregui convenient.
*/
CREATE OR REPLACE PROCEDURE create_order_history AS
BEGIN
    EXECUTE IMMEDIATE 'create table ORDER_HISTORY(ORDER_CODE NUMBER(6,0), ORDER_DATE DATE, CUSTOMER_CODE NUMBER(9,0), SUPPLIER_CODE NUMBER(5,0), PRODUCT_CODE VARCHAR2(8), QUANTITY NUMBER(4,0), TOTAL_AMOUNT NUMBER(7,2), ORDER_DROP VARCHAR2(1))';
    COMMIT;
END;
/

SET SERVEROUTPUT ON
--SET VERIFY OFF
CREATE OR REPLACE PROCEDURE PURGE_ORDERS AS
    CURSOR c_data IS SELECT * FROM ORDER2;
    v_data c_data%ROWTYPE;
BEGIN
    FOR v_data in c_data LOOP
        INSERT INTO order_history VALUES (v_data.order_code, v_data.order_date, v_data.customer_code, v_data.supplier_code, v_data.product_code, v_data.quantity, v_data.total_amount, v_data.order_drop);
        DELETE FROM ORDER2 WHERE order_code = v_data.order_code;
    END LOOP;
END;
/


