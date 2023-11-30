-- no.1
SELECT menu.* FROM menu
WHERE lower(menu.M_Nama) NOT LIKE "%ayam%" AND lower(menu.M_Deskripsi) NOT LIKE "%ayam%";

-- no.2
SELECT GROUP_CONCAT(menu.M_Nama) AS listMenu, SUM(menu.M_Harga) AS totalUang FROM menu
JOIN menu_transaksi ON menu_transaksi.Menu_M_ID = menu.M_ID
JOIN transaksi ON transaksi.T_ID = menu_transaksi.Transaksi_T_ID
WHERE transaksi.Customer_C_ID = (
    SELECT customer.C_ID FROM customer
    WHERE customer.C_Nama = "Lisa Davis"
)
GROUP BY transaksi.Customer_C_ID;

-- no.3
SELECT menu_transaksi.Transaksi_T_ID AS T_ID, SUM(menu.M_Harga) AS totalHarga, count(menu_transaksi.Menu_M_ID) AS totalMenu FROM menu
JOIN menu_transaksi ON menu_transaksi.Menu_M_ID = menu.M_ID
GROUP BY menu_transaksi.Transaksi_T_ID
ORDER BY totalMenu DESC, totalHarga DESC;

-- no.4
SELECT driver.* FROM driver
WHERE driver.D_Rating > (
    SELECT AVG(driver.D_Rating) FROM driver
);

-- no.5
SELECT transaksi.T_WaktuPesanan AS waktuOrder, COUNT(transaksi.T_ID) AS jumlahTransaksiPerHari FROM transaksi
GROUP BY transaksi.T_WaktuPesanan
ORDER BY transaksi.T_WaktuPesanan DESC;

-- no.6
SELECT pegawai.P_Jabatan, count(*) AS jumlahPegawai, avg(pegawai.P_Gaji) AS rataRataGaji FROM pegawai
GROUP BY pegawai.P_Jabatan;

-- no.7
SELECT pegawai.P_Nama, COUNT(*) AS totalTransaksiYangTelahDilayani FROM pegawai
JOIN transaksi ON transaksi.Pegawai_P_ID = pegawai.P_ID
GROUP BY pegawai.P_Nama
ORDER BY totalTransaksiYangTelahDilayani DESC;

-- no.8
SELECT 0.4 * (
    SELECT SUM(menu.M_Harga) FROM menu
    JOIN menu_transaksi ON menu_transaksi.Menu_M_ID = menu.M_ID
    JOIN transaksi ON transaksi.T_ID = menu_transaksi.Transaksi_T_ID
    WHERE month(transaksi.T_WaktuPesanan) = 11
    AND transaksi.T_MetodePembayaran = "Cash"
) + 0.4 * (
    SELECT SUM(menu.M_Harga) * 0.95 FROM menu
    JOIN menu_transaksi ON menu_transaksi.Menu_M_ID = menu.M_ID
    JOIN transaksi ON transaksi.T_ID = menu_transaksi.Transaksi_T_ID
    WHERE month(transaksi.T_WaktuPesanan) = 11
    AND transaksi.T_MetodePembayaran = "Debit Card"
    OR transaksi.T_MetodePembayaran = "Credit Card"
) AS profitNovember2023

-- no.9
SELECT (
	SELECT COUNT(*) FROM transaksi
    WHERE dayofweek(transaksi.T_WaktuPesanan) IN (2, 3, 4, 5, 6)
) - (
    SELECT COUNT(*) FROM transaksi
    WHERE dayofweek(transaksi.T_WaktuPesanan) IN (7, 1)
) AS selisih_transaksi, (
    SELECT SUM(menu.M_Harga) FROM menu
    JOIN menu_transaksi ON menu_transaksi.Menu_M_ID = menu.M_ID
    JOIN transaksi ON transaksi.T_ID = menu_transaksi.Transaksi_T_ID
    WHERE dayofweek(transaksi.T_WaktuPesanan) IN (2, 3, 4, 5, 6)
) - (
    SELECT SUM(menu.M_Harga) FROM menu
    JOIN menu_transaksi ON menu_transaksi.Menu_M_ID = menu.M_ID
    JOIN transaksi ON transaksi.T_ID = menu_transaksi.Transaksi_T_ID
    WHERE dayofweek(transaksi.T_WaktuPesanan) IN (1, 7)
) AS selisih_pendapatan;

-- no.10
SELECT driver.D_Nama, COUNT(*) as totalMenu FROM driver
JOIN transaksi ON transaksi.Driver_D_ID = driver.D_ID
JOIN menu_transaksi ON menu_transaksi.Transaksi_T_ID = transaksi.T_ID
GROUP BY driver.D_ID
ORDER BY totalMenu DESC;