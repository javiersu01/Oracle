
CREATE OR REPLACE TYPE tCliente AS OBJECT (
    CIF varchar(4), 
    razon_social varchar(100), 
    direccion varchar(100), 
    correo_electronico varchar(100),
    num_numero_cuenta integer, 
    telefono integer, 
    MEMBER FUNCTION obtenerDatosCliente RETURN varchar
);


CREATE OR REPLACE TYPE BODY tCliente AS
    -- Método 
    MEMBER FUNCTION obtenerDatosCliente RETURN varchar IS
        resultado varchar(4000);
    BEGIN
        resultado := 'CIF: ' || self.CIF || ', ';
        resultado := resultado || 'Razón Social: ' || self.razon_social || ', ';
        resultado := resultado || 'Dirección: ' || self.direccion || ', ';
        resultado := resultado || 'Correo Electrónico: ' || self.correo_electronico || ', ';
        resultado := resultado || 'Número de Cuenta: ' || self.num_numero_cuenta || ', ';
        resultado := resultado || 'Teléfono: ' || self.telefono;
       
        RETURN resultado;
    END obtenerDatosCliente;
END;


-- Crear la tabla "CLIENTE" que utiliza el tipo de objeto "tCliente"
CREATE TABLE CLIENTE OF tCliente;

ALTER TABLE CLIENTE ADD PRIMARY KEY (CIF);

INSERT INTO CLIENTE VALUES ('C001', 'Empresa DEF', 'Calle Secundaria 456', 'info@empresadef.com', 87654321, 123456789);
INSERT INTO CLIENTE VALUES ('C002', 'Tienda LMN', 'Avenida Lateral 789', 'contacto@tiendalmn.com', 246813579, 135792468);
INSERT INTO CLIENTE VALUES ('C003', 'Fabrica GHI', 'Carretera Comercial 321', 'ventas@fabricaghi.com', 1593572468, 7531592468);
INSERT INTO CLIENTE VALUES ('C004', 'Consultores Expertos S.A.', 'Plaza Financiera 321', 'info@consultoresexpertos.com', 7531592468, 1593572468);
INSERT INTO CLIENTE VALUES ('C005', 'Restaurante Gourmet', 'Calle de los Aromas 890', 'reservas@restaurantegourmet.com', 9517532468, 3579512468);

SELECT c.obtenerDatosCliente() AS "Datos Cliente"
FROM CLIENTE c;

---------------------------------------------------------------------------------
CREATE OR REPLACE TYPE tPedido AS OBJECT (
    id_pedido NUMBER, -- Identificador del pedido
    fecha DATE, -- Fecha del pedido
    CIF VARCHAR2(4),
    DNI_entrega VARCHAR2(10),
    DNI_recoge VARCHAR2(10),
    n_factura NUMBER,
    MEMBER FUNCTION obtenerDatosPedido RETURN VARCHAR
);
CREATE OR REPLACE TYPE BODY tPedido AS
    -- Método para obtener todos los datos del pedido
    MEMBER FUNCTION obtenerDatosPedido RETURN VARCHAR IS
        resultado VARCHAR2(4000);
    BEGIN
        resultado := 'ID Pedido: ' || self.id_pedido || ', ';
        resultado := resultado || 'Fecha: ' || TO_CHAR(self.fecha, 'YYYY-MM-DD') || ', ';
        resultado := resultado || 'CIF: ' || self.CIF || ', ';
        resultado := resultado || 'DNI entrega: ' || self.DNI_entrega || ', ';
        resultado := resultado || 'DNI recoge: ' || self.DNI_recoge || ', ';
        resultado := resultado || 'Número de factura: ' || self.n_factura;
       
        RETURN resultado;
    END obtenerDatosPedido;
END;

CREATE TABLE pedido OF tPedido;
ALTER TABLE pedido ADD PRIMARY KEY (id_pedido);

ALTER TABLE pedido ADD CONSTRAINT fk_pedido_cif FOREIGN KEY (CIF) REFERENCES cliente (CIF);
ALTER TABLE pedido ADD CONSTRAINT fk_pedido_dni_entrega FOREIGN KEY (DNI_entrega) REFERENCES transportistaEntrega (DNI_entrega);
ALTER TABLE pedido ADD CONSTRAINT fk_pedido_dni_recoge FOREIGN KEY (DNI_recoge) REFERENCES transportistaRecoge (DNI_recoge);
ALTER TABLE pedido ADD CONSTRAINT fk_pedido_n_factura FOREIGN KEY (n_factura) REFERENCES factura (n_factura);

INSERT INTO pedido VALUES (1, TO_DATE('2023-05-17', 'YYYY-MM-DD'), 'C001', '34567890J', '34567890J', 1001);
INSERT INTO pedido VALUES (2, TO_DATE('2023-05-18', 'YYYY-MM-DD'), 'C005', '87654321A', '87654321A', 1002);
INSERT INTO pedido VALUES (3, TO_DATE('2023-05-19', 'YYYY-MM-DD'), 'C002', '76543210M', '76543210M', 1003);
INSERT INTO pedido VALUES (4, TO_DATE('2023-05-20', 'YYYY-MM-DD'), 'C003', '23456789K', '23456789K', 1004);
INSERT INTO pedido VALUES (5, TO_DATE('2023-05-21', 'YYYY-MM-DD'), 'C004', '67890123F', '67890123F', 1005);

-- SELECT para mostrar los datos de los pedidos
SELECT p.obtenerDatosPedido() AS "Datos Pedido"
FROM pedido p;


---------------------------------------------------------------------------------
CREATE OR REPLACE TYPE tFactura AS OBJECT (
    n_factura NUMBER, 
    fecha_emision DATE, 
    MEMBER FUNCTION obtenerDatosFactura RETURN VARCHAR
);

CREATE OR REPLACE TYPE BODY tFactura AS
    -- Metodo para obtener todos los datos de la factura
    MEMBER FUNCTION obtenerDatosFactura RETURN VARCHAR IS
        resultado VARCHAR(4000);
    BEGIN
        resultado := 'Número de factura: ' || self.n_factura || ', ';
        resultado := resultado || 'Fecha de emisión: ' || TO_CHAR(self.fecha_emision, 'YYYY-MM-DD');
       
        RETURN resultado;
    END obtenerDatosFactura;
END;

CREATE TABLE factura OF tFactura;

ALTER TABLE factura ADD PRIMARY KEY (n_factura);

INSERT INTO FACTURA VALUES (1001, TO_DATE('2023-05-22', 'YYYY-MM-DD'));
INSERT INTO FACTURA VALUES (1002, TO_DATE('2023-05-23', 'YYYY-MM-DD'));
INSERT INTO FACTURA VALUES (1003, TO_DATE('2023-05-24', 'YYYY-MM-DD'));
INSERT INTO FACTURA VALUES (1004, TO_DATE('2023-05-25', 'YYYY-MM-DD'));
INSERT INTO FACTURA VALUES (1015, TO_DATE('2023-05-26', 'YYYY-MM-DD'));


SELECT f.obtenerDatosFactura() AS "Datos Factura"
FROM factura f;

---------------------------------------------------------------------------------
CREATE OR REPLACE TYPE tProducto AS OBJECT (
    id_producto NUMBER, -- Identificador del producto
    nombre VARCHAR(100), -- Nombre del producto
    descripcion VARCHAR(200), -- Descripcion del producto
    precio NUMBER(10, 2), -- Precio del producto
    disponible VARCHAR2(3), -- Disponibilidad del producto ('SI' o 'NO')
    MEMBER FUNCTION obtenerDatosProducto RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY tProducto AS
    -- Metodo para obtener todos los datos del producto
    MEMBER FUNCTION obtenerDatosProducto RETURN VARCHAR2 IS
    resultado VARCHAR2(4000);
    BEGIN
        resultado := 'ID del producto: ' || TO_CHAR(self.id_producto) || ', ' ||
               'Nombre: ' || self.nombre || ', ' ||
               'Descripción: ' || self.descripcion || ', ' ||
               'Precio: ' || TO_CHAR(self.precio) || ', ' ||
               'Disponible: ' || TO_CHAR(self.disponible);
        RETURN resultado;
    END obtenerDatosProducto;
END;

CREATE TABLE producto OF tProducto;

ALTER TABLE producto ADD PRIMARY KEY (id_producto);

INSERT INTO PRODUCTO VALUES (1, 'Gorra', 'Gorra de beisbol con visera', 14.99, 'SI');
INSERT INTO PRODUCTO VALUES (2, 'Sudadera', 'Sudadera con capucha y bolsillo', 29.99, 'SI');
INSERT INTO PRODUCTO VALUES (3, 'Zapatillas', 'Zapatillas deportivas con suela de goma', 49.99, 'NO');
INSERT INTO PRODUCTO VALUES (4, 'Mochila', 'Mochila con compartimentos y cremalleras', 24.99, 'SI');
INSERT INTO PRODUCTO VALUES (5, 'Gafas de sol', 'Gafas de sol con lentes polarizadas', 19.99, 'SI');


-- SELECT para mostrar los datos de los productos
SELECT p.obtenerDatosProducto() AS "Datos Producto"
FROM producto p;

---------------------------------------------------------------------------------


CREATE OR REPLACE TYPE tAlquila AS OBJECT (
    id_alquila NUMBER,
    precio NUMBER(10, 2), 
    tiempo NUMBER,
    id_pedido NUMBER,
    id_producto NUMBER,
    MEMBER FUNCTION obtenerDatosAlquila RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY tAlquila AS
   
    MEMBER FUNCTION obtenerDatosAlquila RETURN VARCHAR2 IS
    BEGIN
        RETURN 'ID del alquiler: ' || TO_CHAR(self.id_alquila) || ', ' ||
               'Precio: ' || TO_CHAR(self.precio) || ', ' ||
               'Tiempo: ' || TO_CHAR(self.tiempo);
    END obtenerDatosAlquila;
END;


CREATE TABLE alquila OF tAlquila;

ALTER TABLE alquila ADD PRIMARY KEY (id_alquila);
ALTER TABLE pedido ADD CONSTRAINT fk_id_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido);
ALTER TABLE producto ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto);

INSERT INTO alquila VALUES (1, 50.99, 3, 1, 1);
INSERT INTO alquila VALUES (2, 75.50, 5, 2, 2);
INSERT INTO alquila VALUES (3, 30.25, 2, 3, 3);
INSERT INTO alquila VALUES (4, 100.00, 7, 4, 4);
INSERT INTO alquila VALUES (5, 45.75, 4, 5, 5);

-- SELECT para mostrar los datos de los alquileres
SELECT a.obtenerDatosAlquila() AS "Datos Alquila"
FROM alquila a;

---------------------------------------------------------------------------------

-- Definir el tipo de objeto "tTransportista" con sus atributos
CREATE OR REPLACE TYPE tTransportistaRecoge AS OBJECT (
    DNI_recoge varchar2(10), -- Numero de identificacion del transportista
    nombre_empresa varchar2(100), -- Nombre de la empresa de transporte
    telefono varchar2(20), -- Numero de telefono del transportista
    vehiculo varchar2(50), -- Descripcion del vehiculo utilizado
    MEMBER FUNCTION obtenerDatosTransportista RETURN varchar2
);

-- Implementacion de los metodos del tipo de objeto "tTransportistaRecoge"
CREATE OR REPLACE TYPE BODY tTransportistaRecoge AS
    -- Método para obtener todos los datos del transportista
    MEMBER FUNCTION obtenerDatosTransportista RETURN VARCHAR2 IS
        resultado VARCHAR2(4000);
    BEGIN
        resultado := 'DNI del transportista: ' || self.DNI_recoge || ', ';
        resultado := resultado || 'Nombre de la empresa: ' || self.nombre_empresa || ', ';
        resultado := resultado || 'Teléfono: ' || self.telefono || ', ';
        resultado := resultado || 'Vehículo: ' || self.vehiculo;
       
        RETURN resultado;
    END obtenerDatosTransportista;
END;


-- Crear la tabla "transportista" que utiliza el tipo de objeto "tTransportistaRecoge"
CREATE TABLE transportista OF tTransportistaRecoge;
-- AÃ±adir PK
ALTER TABLE transportista ADD PRIMARY KEY (DNI_recoge);

-- Insertar Datos
INSERT INTO TRANSPORTISTA VALUES ('12345678Z', 'Transportes DEF', '623456789', 'Camion');
INSERT INTO TRANSPORTISTA VALUES ('23456789X', 'Logistica LMN', '987654321', 'Furgoneta');
INSERT INTO TRANSPORTISTA VALUES ('34567890C', 'Envios Rapidos GHI', '655123456', 'Motocicleta');
INSERT INTO TRANSPORTISTA VALUES ('45678901V', 'Transporte Seguro JKL', '689456123', 'Camion');
INSERT INTO TRANSPORTISTA VALUES ('56789012B', 'Envios Express MNO', '621654987', 'Furgoneta');




---------------------------------------------------------------------------------

CREATE OR REPLACE TYPE tTransportistaEntrega AS OBJECT (
    DNI_entrega varchar2(10), -- Numero de identificacion del transportista
    nombre_empresa varchar2(100), -- Nombre de la empresa de transporte
    telefono varchar2(20), -- Numero de telefono del transportista
    vehiculo varchar2(50), -- Descripcion del vehiculo utilizado
    MEMBER FUNCTION obtenerDatosTransportistaEntrega RETURN varchar2
);


CREATE OR REPLACE TYPE BODY tTransportistaEntrega AS
   
    MEMBER FUNCTION obtenerDatosTransportistaEntrega RETURN varchar2 IS
    BEGIN
        RETURN 'DNI del transportista de entrega: ' || self.DNI_entrega || ', ' ||
               'Nombre de la empresa: ' || self.nombre_empresa || ', ' ||
               'Teléfono: ' || self.telefono || ', ' ||
               'Vehículo: ' || self.vehiculo;
    END obtenerDatosTransportistaEntrega;
END;


CREATE TABLE transportistaEntrega OF tTransportistaEntrega;

ALTER TABLE transportistaEntrega ADD PRIMARY KEY (DNI_entrega);


INSERT INTO TRANSPORTISTAENTREGA VALUES ('12345678Z', 'Transportes DEF', '623456789', 'Camion');
INSERT INTO TRANSPORTISTAENTREGA VALUES ('23456789X', 'Logistica LMN', '987654321', 'Furgoneta');
INSERT INTO TRANSPORTISTAENTREGA VALUES ('34567890C', 'Envios Rapidos GHI', '655123456', 'Motocicleta');
INSERT INTO TRANSPORTISTAENTREGA VALUES ('45678901V', 'Transporte Seguro JKL', '689456123', 'Camion');
INSERT INTO TRANSPORTISTAENTREGA VALUES ('56789012B', 'Envios Express MNO', '621654987', 'Furgoneta');


SELECT te.obtenerDatosTransportistaEntrega() AS "Datos Transportista Entrega"
FROM transportistaEntrega te;




SELECT c.obtenerDatosCliente() AS "Datos Cliente", p.obtenerDatosPedido() AS "Datos Pedido"
FROM CLIENTE c
INNER JOIN PEDIDO p ON c.CIF = p.CIF;


SELECT p.obtenerDatosPedido() AS "Datos Pedido", f.obtenerDatosFactura() AS "Datos Factura"
FROM PEDIDO p
INNER JOIN FACTURA f ON p.n_factura = f.n_factura;



SELECT a.obtenerDatosAlquila() AS "Datos Alquila", p.obtenerDatosPedido() AS "Datos Pedido"
FROM ALQUILA a
INNER JOIN PEDIDO p ON a.id_pedido = p.id_pedido;


SELECT a.obtenerDatosAlquila() AS "Datos Alquila", pr.obtenerDatosProducto() AS "Datos Producto"
FROM ALQUILA a
INNER JOIN PRODUCTO pr ON a.id_producto = pr.id_producto;


SELECT p.obtenerDatosPedido() AS "Datos Pedido", c.obtenerDatosCliente() AS "Datos Cliente"
FROM pedido p
INNER JOIN cliente c ON p.CIF = c.CIF;

SELECT pr.obtenerDatosProducto() AS "Datos Producto", a.obtenerDatosAlquila() AS "Datos Alquila"
FROM alquila a
INNER JOIN producto pr ON a.id_producto = pr.id_producto;



SELECT pr.obtenerDatosProducto() AS "Datos Producto", a.obtenerDatosAlquila() AS "Datos Alquila", p.obtenerDatosPedido() AS "Datos Pedido", c.obtenerDatosCliente() AS "Datos Cliente"
FROM alquila a
INNER JOIN producto pr ON a.id_producto = pr.id_producto
INNER JOIN pedido p ON a.id_pedido = p.id_pedido
INNER JOIN cliente c ON p.CIF = c.CIF;




SELECT c.obtenerDatosCliente() AS "Datos Cliente"
FROM CLIENTE c;

SELECT p.obtenerDatosPedido() AS "Datos Pedido"
FROM PEDIDO p;


SELECT f.obtenerDatosFactura() AS "Datos Factura"
FROM FACTURA f;

SELECT pr.obtenerDatosProducto() AS "Datos Producto"
FROM PRODUCTO pr;

SELECT a.obtenerDatosAlquila() AS "Datos Alquila"
FROM ALQUILA a;



SELECT c.obtenerDatosCliente() AS "Datos Cliente", p.obtenerDatosPedido() AS "Datos Pedido"
FROM cliente c, pedido p
WHERE c.CIF = p.CIF;




SELECT c.obtenerDatosCliente() AS "Datos Cliente"
FROM CLIENTE c;

SELECT tr.obtenerDatosTransportista() AS "Datos Transportista Recoge"
FROM transportista tr;

SELECT te.obtenerDatosTransportistaEntrega() AS "Datos Transportista Entrega"
FROM transportistaEntrega te;



