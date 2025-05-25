---------------------------------------TAO CAC BANG VA CHEN DU LIEU TU FILE EXCEL-----------------------------------------------------

-- Tao bang cua hang
CREATE TABLE CuaHang (
    MaCH VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaCH, '^CH')), --Rang buoc ma don hang bat dau bang "CH"
    SDT CHAR(11) NOT NULL,
    DiaChi NVARCHAR2(30)NOT NULL,
    Email VARCHAR2(30) CHECK (REGEXP_LIKE(Email, '@gmail\.com$'))
);

-- Tao bang Nha Cung Cap
CREATE TABLE NhaCungCap (
    MaNCC VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaNCC, '^NCC')),
    TenNCC NVARCHAR2(30) NOT NULL,
    DiaChi NVARCHAR2(100)NOT NULL,
    SoDienThoai CHAR(11)NOT NULL,
    Email VARCHAR2(30) NOT NULL 
);

--Tao bang bo phan
CREATE TABLE BoPhan (
    MaBP VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaBP, '^BP')),
    TenBP NVARCHAR2(30) NOT NULL
);

-- Tao bang Nhân Viên
CREATE TABLE NhanVien (
    MaNV VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaNV, '^NV')),
    TenNV NVARCHAR2(30) NOT NULL,
    GioiTinh NVARCHAR2(3) NOT NULL CHECK (GioiTinh IN ('Nam', 'N?')),
    NgaySinh DATE NOT NULL,
    DiaChi VARCHAR2(100) NOT NULL,
    NgayVaoLam DATE NOT NULL,
    SDT CHAR(11) NOT NULL,
    LuongCoBan NUMBER ,
    PhuCap NUMBER ,
    MaBP VARCHAR2(10)NOT NULL,
    MaCH VARCHAR2(10) NOT NULL,
    FOREIGN KEY (MaCH) REFERENCES CuaHang(MaCH),
    FOREIGN KEY (MaBP) REFERENCES BoPhan(MaBP)
);


-- Tao bang Khach Hang
CREATE TABLE KhachHang (
    MaKH VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaKH, '^KH')),
    TenKH NVARCHAR2(30),
    GioiTinh NVARCHAR2(3) CHECK (GioiTinh IN ('Nam', 'N?')),
    NgaySinh DATE ,
    DiaChi NVARCHAR2(30),
    SoDienThoai CHAR(11),
    Hang NVARCHAR2(10) DEFAULT 'Không'
);

-- Tao bang Nhom hang
CREATE TABLE NhomHang (
    MaNH VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaNH, '^NH')),
    TenNhomHang NVARCHAR2(30) NOT NULL
);


-- Tao bang Mat Hang
CREATE TABLE MatHang (
    MaH VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaH, '^MH')),
    TenMatHang NVARCHAR2(30) NOT NULL,
    HanSuDung DATE NOT NULL,
    GiaBanLe NUMBER NOT NULL CHECK (GiaBanLe>0),
    DonViTinh VARCHAR2(10) NOT NULL,
    MaNCC VARCHAR2(10) NOT NULL,
    MaNH VARCHAR2(10) NOT NULL,
    FOREIGN KEY (MaNH) REFERENCES NhomHang(MaNH),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);


-- Tao bang Hoa Don Ban
CREATE TABLE HoaDonBan (
    MaHDB VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaHDB, '^HDB')),
    NgayLap DATE NOT NULL,
    TongTien NUMBER NOT NULL,
    MaCH VARCHAR2(10) NOT NULL,
    MaNV VARCHAR2(10) NOT NULL,
    MaKH VARCHAR2(10) NOT NULL,
    FOREIGN KEY (MaCH) REFERENCES CuaHang(MaCH),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);


-- Tao bang Chi tiet hoa don ban
CREATE TABLE CT_HoaDonBan (
    MaHDB VARCHAR2(10)NOT NULL,
    MaCH VARCHAR2(10) NOT NULL,
    MaH VARCHAR2(10)NOT NULL,
    SoLuongBan NUMBER NOT NULL,
    GiaBanLe NUMBER NOT NULL,
    GiamGia NUMBER ,
    FOREIGN KEY (MaHDB) REFERENCES HoaDonBan(MaHDB),
    FOREIGN KEY (MaCH) REFERENCES CuaHang(MaCH),
    FOREIGN KEY (MaH) REFERENCES MatHang(MaH)
);
-- Tao bang Hoa don nhap
CREATE TABLE HoaDonNhap (
    MaHDN VARCHAR2(10) PRIMARY KEY CHECK (REGEXP_LIKE(MaHDN, '^HDN')),
    NgayLap DATE NOT NULL,
    TongTien NUMBER NOT NULL,
    MaCH VARCHAR2(10)NOT NULL,
    MaNCC VARCHAR2(10)NOT NULL,
    FOREIGN KEY (MaCH) REFERENCES CuaHang(MaCH),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);

-- Tao bang Chi tiet hoa don nhap
CREATE TABLE CT_HoaDonNhap (
    MaHDN VARCHAR2(10)NOT NULL,
    MaCH VARCHAR2(10)NOT NULL,
    MaH VARCHAR2(10)NOT NULL,
    SoLuongNhap NUMBER NOT NULL,
    GiaNhap NUMBER NOT NULL,
    FOREIGN KEY (MaCH) REFERENCES CuaHang(MaCH),
    FOREIGN KEY (MaHDN) REFERENCES HoaDonNhap(MaHDN),
    FOREIGN KEY (MaH) REFERENCES MatHang(MaH)
);

-- Tao bang Ton kho
CREATE TABLE TonKho (
    MaCH VARCHAR2(10)NOT NULL ,
    MaH VARCHAR2(10)NOT NULL,
    SoLuongTon NUMBER ,
    DonViTinh NVARCHAR2(10)NOT NULL,
    FOREIGN KEY (MaCH) REFERENCES CuaHang(MaCH),
    FOREIGN KEY (MaH) REFERENCES MatHang(MaH)
);
SELECT * FROM CUAHANG;
SELECT * FROM BOPHAN;
SELECT * FROM NHANVIEN;
SELECT * FROM KHACHHANG;
SELECT * FROM NHOMHANG;
SELECT * FROM MATHANG;
SELECT * FROM HOADONBAN;
SELECT * FROM CT_HOADONBAN;
SELECT * FROM HOADONNHAP;
SELECT * FROM CT_HOADONNHAP;
SELECT * FROM TONKHO;



----------------------------DE XUAT VA GIAI QUYET CAC YEU CAU NGHIEP VU BANG SQL VÀ PL/SQL-------------------------------------------

------------------Quan ly ton kho-----------------------------------
-- Kiem tra cac mat hang sap het hang
SELECT T.MACH ,M.MaH, M.TenMatHang, T.SoLuongTon
FROM MatHang M
JOIN TonKho T ON M.MaH = T.MaH
WHERE  T.SoLuongTon < 10;


-- Tao trigger khong cho phep so luong ban lon hon so luong ton
CREATE OR REPLACE TRIGGER check_so_luong_ban
BEFORE INSERT OR UPDATE OF SoLuongBan ON CT_HoaDonBan
FOR EACH ROW
DECLARE
    so_luong_ton INT;
BEGIN
    SELECT SoLuongTon INTO so_luong_ton
    FROM TonKho
    WHERE MaCH = :new.MaCH AND MaH = :new.MaH;

    IF so_luong_ton < :new.SoLuongBan THEN
        RAISE_APPLICATION_ERROR(-20001, 'So luong ban vuot qua so luong ton');
    END IF;
END;

--Tao trigger tu dong cap nhat so luong ton 
--Cap nhat so luong ton dua tren so luong nhap va so luong ban 
CREATE OR REPLACE TRIGGER cap_nhat_so_luong_ton1
AFTER INSERT ON CT_HoaDonNhap
FOR EACH ROW
BEGIN
    UPDATE TonKho
    SET SoLuongTon = SoLuongTon + :new.SoLuongNhap
    WHERE MaCH = :new.MaCH AND MaH = :new.MaH;
END;
--Cap nhat so luong ton dua tren so luong ban
CREATE OR REPLACE TRIGGER cap_nhat_so_luong_ton2
AFTER INSERT ON CT_HoaDonBan
FOR EACH ROW
BEGIN
    UPDATE TonKho
    SET SoLuongTon = SoLuongTon - :new.SoLuongBan
    WHERE MaCH = :new.MaCH AND MaH = :new.MaH;
END;


----------NGHEP VU QUAN LY BAN HANG ------------------

--Cap nhat cot giam giá trên bang hóa don bán chi tiet : 
--Neu khách hàng là thành viên thì giam 10%, 
--neu là VIP thì giam 15% trên moi mat hàng 
--sau do cap nhat lai cot tong tien o bang hóa don bán 

                              
UPDATE CT_Hoadonban
SET giamgia = 0.1 * giabanle * Soluongban
WHERE mahdb IN (
    SELECT HDB.mahdb
    FROM HoadonBan HDB
    JOIN khachhang  KH ON HDB.makh = KH.makh
    WHERE KH.hang = 'Thành Viên');

UPDATE CT_Hoadonban
SET giamgia = 0.15 * giabanle * Soluongban
WHERE mahdb IN (
    SELECT HDB.mahdb
    FROM HoadonBan HDB
    JOIN khachhang  KH ON HDB.makh = KH.makh
    WHERE KH.hang = 'VIP');
                           
UPDATE HoaDonBan
SET TongTien = (
    SELECT SUM(GiaBanLe * SoLuongBan -GiamGia)
    FROM CT_HoaDonBan
    WHERE CT_HoaDonBan.MaHDB = HoaDonBan.MaHDB
);

--Tong so tien mua hang cua mot khach hang la bao nhieu
CREATE OR REPLACE FUNCTION TongSoTienMuaHang (MKH IN KhachHang.MaKH%TYPE)
RETURN NUMBER IS
    TongTienMuaHang NUMBER;
BEGIN
    SELECT SUM(TongTien) INTO TongTienMuaHang
    FROM HoaDonBan
    WHERE MaKH = MKH;

    RETURN TongTienMuaHang;
END;

DECLARE
    TongTien NUMBER;
BEGIN
    TongTien := TongSoTienMuaHang('&MKH');
    DBMS_OUTPUT.PUT_LINE('T?ng s? ti?n mua hàng: ' || TongTien);
END;


-- TRIGGER cap nhat hang khach hang khi cham nguong chi tieu
CREATE OR REPLACE TRIGGER CapNhatHangKhachHang
AFTER INSERT OR UPDATE ON HoaDonBan
FOR EACH ROW
DECLARE
    TongTienKhachHang NUMBER;
BEGIN
    -- Tính t?ng ti?n t?t c? hóa ??n c?a khách hàng
    SELECT SUM(TongTien) INTO TongTienKhachHang
    FROM HoaDonBan
    WHERE MaKH = :NEW.MaKH;

    -- Ki?m tra và c?p nh?t h?ng khách hàng d?a trên t?ng ti?n
    IF TongTienKhachHang >= 10000000 THEN
        UPDATE KhachHang
        SET Hang = 'VIP'
        WHERE MaKH = :NEW.MaKH;
    ELSIF TongTienKhachHang >= 000000 THEN
        UPDATE KhachHang
        SET Hang = 'Thành viên'
        WHERE MaKH = :NEW.MaKH;
    END IF;
END;


-------NGHIEP VU QUAN LY SAN PHAM------------------
--Dua ra mat hang het han su dung
SELECT *
FROM MatHang
WHERE Hansudung <= SYSDATE;

--Moi nhom hang co bao nhieu mat hang
SELECT NH.MaNH, NH.TenNhomHang, COUNT(MH.MaH) AS So_luong_mat_hang
FROM Nhomhang NH
LEFT JOIN MatHang MH ON NH.MaNH = MH.MaNH
GROUP BY NH.MaNH, NH.TenNhomHang;


--Nha cung cap dã cung cap nhung mat hang nao
CREATE OR REPLACE PROCEDURE 
NCC_MH (TNCC NhaCungCap.MaNCC%type)
as
begin
    for rec in (select  MH.MaH, MH.TenMatHang
                from mathang MH join Nhacungcap NCC on MH.MaNCC=NCC.MaNCC
                where NCC.TenNCC = TNCC)
    loop
        dbms_output.put_line('Ma mat hang: '||rec.MaH||' Ten mat hang: '||rec.TenMatHang);
    end loop;
end;
EXEC NCC_MH('&TNCC');

--Nhap vao ten hang tra ve ten nha cung cap, ten nhom hang
declare
Cursor cs_ds is 
        select  TenMatHang, TenNhomHang,TenNCC
        from MatHang join Nhacungcap on MatHang.MaNCC=Nhacungcap.MaNCC 
                     join Nhomhang on mathang.maNH=NhomHang.MaNH;
    tmh MatHang.TenMatHang%type;
    TenMH MatHang.TenMatHang%type;
    tnh NhomHang.TenNhomHang%type;
    tncc Nhacungcap.TenNCC%type;
begin 
    TenMH:='&tmh';
    open cs_ds;
    loop
        fetch cs_ds into tmh,tnh,tncc;
            exit when cs_ds%notfound;
        if tmh = TenMH then 
            dbms_output.put_line('Ten mat hang: '||tmh||'|| Ten nhom hang: '||tnh|| '||Ten nha cung cap : '||tncc);
        end if;
    end loop;
    close cs_ds;
end;




----------NGHEP VU BAO CAO & THONG KE ------------------

--DUA RA 10 MAT HANG BAN CHAY NHAT
SELECT MH.MaH, MH.TenMatHang,SUM(CT.SoLuongBan) AS Tong_so_luong_ban
FROM MatHang MH
JOIN CT_HoaDonBan CT ON MH.MaH = CT.MaH
GROUP BY MH.MaH, MH.TenMatHang
ORDER BY Tong_so_luong_ban DESC
FETCH FIRST 10 ROWS ONLY;

--DUA RA NHUNG MAT HANG KHONG BAN DUOC
SELECT MH.*
FROM MatHang MH
LEFT JOIN CT_HoaDonBan CT ON MH.MaH = CT.MaH
WHERE CT.MaHDB IS NULL;

--Tinh Doanh thu thang 01 cua moi cua hang
SELECT CH.MaCH,CH.DiaChi, Sum(HDB.TongTien) "Doanh Thu"
FROM HoaDonBan HDB Join CuaHang CH on HDB.MaCH= CH.MaCH
WHERE EXTRACT(MONTH FROM NgayLap)=1
GROUP BY CH.MaCH,CH.DiaChi;


--Tong so tien hang da nhap trong thang 08 cua môi cua hang
SELECT CH.MaCH,CH.DiaChi, Sum(HDN.TongTien) "Tong Tien"
FROM HoaDonNhap HDN Join CuaHang CH on HDN.MaCH= CH.MaCH
WHERE EXTRACT(MONTH FROM NgayLap)= 8
GROUP BY CH.MaCH,CH.DiaChi;


--Tinh doanh thu theo thang cua cua hang có ma CH01
SELECT 
    EXTRACT(MONTH FROM NgayLap) AS Thang,
    SUM(TongTien) AS DoanhThu
FROM 
    HoaDonBan
WHERE 
    MaCH = 'CH01'
    AND EXTRACT(YEAR FROM NgayLap) = 2023 
GROUP BY 
    EXTRACT(MONTH FROM NgayLap)
ORDER BY 
    Thang;


----------NGHEP VU QUAN LY NHAN SU------------------

--Cap nhat luong va phu cap cho nhan vien 
UPDATE NhanVien
SET LuongCoBan = 
    (SELECT 
        CASE 
            WHEN TENBP = 'Nhân s?' THEN 15000000
            WHEN TENBP = 'Bán hàng' THEN 8000000
            WHEN TENBP = 'Kho hàng' THEN 14000000
            ELSE 18000000
        END
    FROM BoPhan
    WHERE BoPhan.MaBP = NhanVien.MaBP);
    
select * from nhanvien;

UPDATE NhanVien
SET PhuCap = 
    CASE 
        WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM Ngayvaolam) >= 5 THEN 4000000
        ELSE 1500000
    END;

SELECT MaCH, COUNT(MaNV) AS So_luong_nhan_vien
FROM  NhanVien
GROUP BY MaCH;

-- Dua ra nhan vien thuoc bo phan ban hang nhung khong ban duoc don hang nao
SELECT NhanVien.MaNV, NhanVien.TenNV
FROM NhanVien
INNER JOIN BOPHAN BP ON NHANVIEN.MABP = BP.MABP
LEFT JOIN HoaDonBan ON NhanVien.MaNV = HoaDonBan.MaNV
WHERE HoaDonBan.MaHDB IS NULL AND TENBP ='Bán Hàng';

--Dua ra nhan vien ban duoc nhieu don hang nhat
SELECT NV.MaNV, NV.TenNV, COUNT(HDB.MaHDB) AS So_luong_don_hang
FROM NhanVien NV
JOIN HoaDonBan HDB ON NV.MaNV = HDB.MaNV
GROUP BY NV.MaNV, NV.TenNV
ORDER BY So_luong_don_hang DESC
FETCH FIRST 1 ROW ONLY;



-- Nhap vao ma nhan vien tra ve tat ca thong tin cua nhan vien
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE GetEmployeeInfo(
    MNV NhanVien.MaNV%TYPE
)
AS
    rowNV NhanVien%ROWTYPE;
BEGIN
    SELECT *
    INTO rowNV
    FROM NhanVien
    WHERE MaNV = MNV;
    -- Hi?n th? thông tin
    DBMS_OUTPUT.PUT_LINE('Tên nhân viên: ' || rowNV.TenNv);
    DBMS_OUTPUT.PUT_LINE('Gioi tính: ' || rowNV.Gioitinh);
    DBMS_OUTPUT.PUT_LINE('Ngày sinh: ' || TO_CHAR(rowNV.Ngaysinh, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('Ngày vào làm: ' || TO_CHAR(rowNV.Ngayvaolam, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('Dia chi: ' || rowNV.Diachi);
    DBMS_OUTPUT.PUT_LINE('So dien thoai: ' || rowNV.SDT);
    DBMS_OUTPUT.PUT_LINE('Luong co ban: ' || rowNV.Luongcoban);
    DBMS_OUTPUT.PUT_LINE('Phu cap: ' || rowNV.Phucap);
    DBMS_OUTPUT.PUT_LINE('Mã bo phan: ' || rowNV.MaBP);
    DBMS_OUTPUT.PUT_LINE('Mã cua hàng: ' ||rowNV.MaCH);
END;
EXEC GetEmployeeInfo('&MNV');

--Nhap vao ma cua hang tra ve danh sach nhan vien lam viec trong cua hang do
CREATE OR REPLACE PROCEDURE GetEmployeesByStore(
    MCH IN CuaHang.MaCH%TYPE
)
AS
BEGIN
    FOR rec IN (
        SELECT *
        FROM NhanVien
        WHERE MaCH = MCH
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Tên nhân viên: ' || rec.TenNV);
        DBMS_OUTPUT.PUT_LINE('Gioi tính: ' || rec.Gioitinh);
        DBMS_OUTPUT.PUT_LINE('Ngày sinh: ' || TO_CHAR(rec.Ngaysinh, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Ngày vào làm: ' || TO_CHAR(rec.Ngayvaolam, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Dia chi: ' || rec.DiaChi);
        DBMS_OUTPUT.PUT_LINE('So dien thoai: ' || rec.SDT);
        DBMS_OUTPUT.PUT_LINE('Mã bo phan: ' || rec.MaBP);
        DBMS_OUTPUT.PUT_LINE('-----------------------');
    END LOOP;
END;
EXEC GetEmployeesByStore('&MCH');


-- Xoa nhung nhan vien thuoc bo phan ban hang nhung khong ban duoc hoa don nao
BEGIN
    FOR rec IN (
        SELECT NhanVien.MaNV
        FROM NhanVien
        INNER JOIN BOPHAN BP ON NHANVIEN.MABP = BP.MABP
        LEFT JOIN HoaDonBan ON NhanVien.MaNV = HoaDonBan.MaNV
        WHERE HoaDonBan.MaHDB IS NULL AND TENBP ='Bán Hàng'
    )
    LOOP
        -- Xóa nhân viên
        DELETE FROM NhanVien
        WHERE MaNV = rec.MaNV;

        DBMS_OUTPUT.PUT_LINE('Da xóa nhân viên có mã ' || rec.MaNV);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Hoàn tat!');
END;

CREATE OR REPLACE PROCEDURE DanhSachNhanVienTheoBoPhan(MBP VARCHAR2) IS
BEGIN
  -- L?p qua m?i nhân viên trong b? ph?n ?ó và in ra thông tin
  FOR r IN (SELECT MaNV, TenNV, Gioitinh, Ngaysinh, Diachi, SDT, Luongcoban, Phucap
            FROM NhanVien
            WHERE MaBP = MBP) LOOP
    DBMS_OUTPUT.PUT_LINE(r.MaNV || ' | ' || 
                         r.TenNV || ' | ' || 
                         r.Gioitinh || ' | ' || 
                         TO_CHAR(r.Ngaysinh, 'DD-MM-YYYY') || ' | ' || 
                         r.Diachi || ' | ' || 
                         r.SDT || ' | ' || 
                         r.Luongcoban || ' | ' || 
                         r.Phucap);
  END LOOP;
END;
execute DanhSachNhanVienTheoBoPhan('&mbp');


    
------------------------------------------------------------TAO TABLESPACE-----------------------------------------

CREATE TEMPORARY TABLESPACE temp_ts
TEMPFILE 'C:\app\oracle\oradata\QLBH\temp_ts1.dbf' 
SIZE 100M 
AUTOEXTEND ON 
NEXT 10M MAXSIZE UNLIMITED; 

CREATE TABLESPACE data_ts
DATAFILE 'C:\app\oracle\oradata\QLBH\data_ts1.dbf' 
SIZE 500M 
AUTOEXTEND ON 
NEXT 10M MAXSIZE UNLIMITED;

------------------------------------------------------------TAO PROFILE QUY DINH HAN MUC ------------------------------------------------
CREATE PROFILE user_profile LIMIT
    SESSIONS_PER_USER          2         -- T?i ?a s? phiên m?i ng??i dùng có th? m?
    CONNECT_TIME               180       -- T?i ?a th?i gian k?t n?i (phút)
    IDLE_TIME                  15        -- T?i ?a th?i gian không ho?t ??ng (phút)
    FAILED_LOGIN_ATTEMPTS      5         -- S? l?n ??ng nh?p th?t b?i t?i ?a tr??c khi khoá tài kho?n
    PASSWORD_LIFE_TIME         90        -- Th?i gian t?i ?a c?a m?t kh?u (ngày)
    PASSWORD_LOCK_TIME         3;         -- Th?i gian khoá tài kho?n sau quá nhi?u l?n ??ng nh?p th?t b?i (ngày)
    
-----------------------------------------------------------------TAO USER VA ROLE ------------------------------------------------
--TAO USER CHO GIAM DOC
CREATE USER GIAMDOC
IDENTIFIED BY 12345
DEFAULT TABLESPACE data_ts
QUOTA UNLIMITED ON data_ts
ACCOUNT UNLOCK
TEMPORARY TABLESPACE temp_ts;

--CAP QUYEN CHO GIAM DOC
GRANT CREATE SESSION TO GIAMDOC;
GRANT DBA TO GIAMDOC;

--TAO USER NHÂN VIÊN THU NGAN
CREATE USER NVBH
IDENTIFIED BY 12345
DEFAULT TABLESPACE data_ts
QUOTA 100M ON data_ts
ACCOUNT UNLOCK
TEMPORARY TABLESPACE temp_ts
PROFILE user_profile;
--TAO ROLE NHÂN VIÊN THU NGÂN
CREATE ROLE role_banhang;
GRANT CREATE SESSION TO role_banhang;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.HOADONBAN TO role_banhang;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.CT_HOADONBAN TO role_banhang;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.KHACHHANG TO role_banhang;
--CAP QUYEN CHO USER 
GRANT role_banhang TO NVBH;


--TAO USER NHAN VIEN KHO
CREATE USER NVKHO
IDENTIFIED BY 12345
DEFAULT TABLESPACE data_ts
QUOTA 100M ON data_ts
ACCOUNT UNLOCK
TEMPORARY TABLESPACE temp_ts
PROFILE user_profile;
--TAO ROLE CHO NHÂN VIÊN KHO
CREATE ROLE role_kho;
GRANT CREATE SESSION TO role_kho;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.TONKHO TO role_kho;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.HOADONNHAP TO role_kho;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.CT_HOADONNHAP TO role_kho;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.NHACUNGCAP TO role_kho;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.NHOMHANG TO role_kho;
GRANT SELECT, INSERT, UPDATE ON GIAMDOC.MATHANG TO role_kho;
--CAP QUYEN CHO NHAN VIEN KHO 
GRANT role_kho TO NVKHO;
GRANT EXECUTE ON GIAMDOC.NCC_MH TO NVKHO; --NHA CUNG CAP CUNG CAP NHUNG MAT HANG NAO

--TAO USER NHAN VIEN KE TOAN
CREATE USER KETOAN
IDENTIFIED BY 12345
DEFAULT TABLESPACE data_ts
QUOTA 100M ON data_ts
ACCOUNT UNLOCK
TEMPORARY TABLESPACE temp_ts
PROFILE user_profile;
--TAO ROLE CHO NHAN VIEN KE TOAN
CREATE ROLE role_ketoan;
GRANT CREATE SESSION TO role_ketoan;
GRANT CREATE VIEW TO role_ketoan;
GRANT SELECT ON GIAMDOC.HOADONNHAP TO role_ketoan;
GRANT SELECT ON GIAMDOC.CT_HOADONNHAP TO role_ketoan;
GRANT SELECT ON GIAMDOC.HOADONBAN TO role_ketoan;
GRANT SELECT ON GIAMDOC.CT_HOADONBAN TO role_ketoan;
GRANT EXECUTE ON user1.procedure_name TO user2;
--CAP QUYEN CHO NHAN VIEN KE TOAN
GRANT role_ketoan TO KETOAN;


--TAO USER NHAN VIEN QUAN LY NHAN SU
CREATE USER HR1
IDENTIFIED BY 12345
DEFAULT TABLESPACE data_ts
QUOTA 100M ON data_ts
ACCOUNT UNLOCK
TEMPORARY TABLESPACE temp_ts
PROFILE user_profile;
--TAO ROLE CHO NHAN VIEN QUAN LÝ NHÂN SU 
CREATE ROLE role_nhansu;
GRANT CREATE SESSION TO role_nhansu;
GRANT SELECT, INSERT, UPDATE, DELETE ON GIAMDOC.NHANVIEN TO role_nhansu;
GRANT SELECT ON GIAMDOC.HOADONBAN TO role_nhansu;
GRANT SELECT ON GIAMDOC.CUAHANG TO role_nhansu;
GRANT SELECT ON GIAMDOC.BOPHAN TO role_nhansu;
--CAP QUYEN 
GRANT role_nhansu TO HR1;
GRANT EXECUTE ON GIAMDOC.GetEmployeeInfo TO HR1;
GRANT EXECUTE ON GIAMDOC.GetEmployeesByStore TO HR1;



