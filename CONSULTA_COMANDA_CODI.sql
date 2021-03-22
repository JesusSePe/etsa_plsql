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
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE(CONSULTA_COMANDA_CODI);
END;
/
