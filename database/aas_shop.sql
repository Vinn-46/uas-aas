-- MySQL Workbench Synchronization
-- Generated: 2026-11-27 15:42
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Kelvin Adrian

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER SCHEMA `aas_shop`  DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_general_ci ;

CREATE TABLE IF NOT EXISTS `aas_shop`.`pengguna` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `saldo` INT(11) NOT NULL,
  `no_telp` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `role` ENUM('admin', 'penjual', 'pembeli') NOT NULL,
  `foto_profil` TEXT NOT NULL,
  `token` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nama_UNIQUE` (`nama` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `aas_shop`.`kategori` (
  `id` INT(11) NOT NULL,
  `nama_kategori` VARCHAR(45) NOT NULL,
  `deskripsi` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `aas_shop`.`barang` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `kategori_id` INT(11) NOT NULL,
  `toko_id` INT(11) NOT NULL,
  `nama_barang` VARCHAR(100) NOT NULL,
  `deskripsi` TEXT NOT NULL,
  `harga_beli` INT(11) NOT NULL,
  `harga_jual` INT(11) NOT NULL,
  `stok` INT(11) NOT NULL,
  `gambar_barang` TEXT NOT NULL,
  `is_preorder` TINYINT(1) NOT NULL,
  `estimasi_po` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_barang_kategori_idx` (`kategori_id` ASC),
  INDEX `fk_barang_toko1_idx` (`toko_id` ASC),
  CONSTRAINT `fk_barang_kategori`
    FOREIGN KEY (`kategori_id`)
    REFERENCES `aas_shop`.`kategori` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_barang_toko1`
    FOREIGN KEY (`toko_id`)
    REFERENCES `aas_shop`.`toko` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `aas_shop`.`toko` (
  `id` INT(11) NOT NULL,
  `nama_toko` VARCHAR(100) NOT NULL,
  `pemilik_toko_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_toko_pengguna1_idx` (`pemilik_toko_id` ASC),
  CONSTRAINT `fk_toko_pengguna1`
    FOREIGN KEY (`pemilik_toko_id`)
    REFERENCES `aas_shop`.`pengguna` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `aas_shop`.`transaksi` (
  `id` INT(11) NOT NULL,
  `nomor_nota` VARCHAR(45) NOT NULL,
  `tanggal_beli` DATETIME NOT NULL,
  `status_pesanan` ENUM('menunggu_bayar', 'diproses', 'dikirim', 'selesai', 'batal') NOT NULL,
  `status_pembayaran` ENUM('pending', 'lunas', 'batal') NOT NULL,
  `total_bayar` INT(11) NOT NULL,
  `jenis_transaksi` ENUM('reguler', 'po') NOT NULL,
  `pengguna_id` INT(11) NOT NULL,
  `alamat_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pembelian_pengguna1_idx` (`pengguna_id` ASC),
  INDEX `fk_pembelian_alamat1_idx` (`alamat_id` ASC),
  CONSTRAINT `fk_pembelian_pengguna1`
    FOREIGN KEY (`pengguna_id`)
    REFERENCES `aas_shop`.`pengguna` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pembelian_alamat1`
    FOREIGN KEY (`alamat_id`)
    REFERENCES `aas_shop`.`alamat` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `aas_shop`.`detail_transaksi` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `transaksi_id` INT(11) NOT NULL,
  `barang_id` INT(11) NOT NULL,
  `jumlah` INT(11) NOT NULL,
  `harga_satuan` INT(11) NOT NULL,
  `subtotal` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_detail_pembelian_pembelian1_idx` (`transaksi_id` ASC),
  INDEX `fk_detail_pembelian_barang1_idx` (`barang_id` ASC),
  CONSTRAINT `fk_detail_pembelian_pembelian1`
    FOREIGN KEY (`transaksi_id`)
    REFERENCES `aas_shop`.`transaksi` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detail_pembelian_barang1`
    FOREIGN KEY (`barang_id`)
    REFERENCES `aas_shop`.`barang` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `aas_shop`.`audit_logs` (
  `id` INT(11) NOT NULL,
  `pengguna_id` INT(11) NOT NULL,
  `aksi` VARCHAR(45) NOT NULL,
  `target_table` VARCHAR(45) NOT NULL,
  `keterangan` TEXT NOT NULL,
  `waktu` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_audit_logs_pengguna1_idx` (`pengguna_id` ASC),
  CONSTRAINT `fk_audit_logs_pengguna1`
    FOREIGN KEY (`pengguna_id`)
    REFERENCES `aas_shop`.`pengguna` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `aas_shop`.`alamat` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `alamat_lengkap` TEXT NOT NULL,
  `is_deleted` TINYINT(1) NOT NULL,
  `pengguna_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_alamat_pengguna1_idx` (`pengguna_id` ASC),
  CONSTRAINT `fk_alamat_pengguna1`
    FOREIGN KEY (`pengguna_id`)
    REFERENCES `aas_shop`.`pengguna` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
