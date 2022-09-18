-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`fabricante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`fabricante` (
  `codigo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `optica`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`producto` (
  `codigo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `precio` DOUBLE NOT NULL,
  `codigo_fabricante` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `codigo_fabricante` (`codigo_fabricante` ASC) VISIBLE,
  CONSTRAINT `producto_ibfk_1`
    FOREIGN KEY (`codigo_fabricante`)
    REFERENCES `optica`.`fabricante` (`codigo`))
ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`adress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`adress` (
  `id_adress` INT NOT NULL AUTO_INCREMENT,
  `carrer` VARCHAR(45) NOT NULL,
  `numero` VARCHAR(45) NOT NULL,
  `piso` VARCHAR(20) NULL DEFAULT NULL,
  `puerta` VARCHAR(10) NULL DEFAULT NULL,
  `ciudad` VARCHAR(45) NOT NULL,
  `codigo_postal` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_adress`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `optica`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`proveedor` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `id_adress` INT NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `fax` VARCHAR(15) NULL DEFAULT NULL,
  `nif` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id_proveedor`),
  UNIQUE INDEX `id_proveedor_UNIQUE` (`id_proveedor` ASC) VISIBLE,
  INDEX `id_adress_idx` (`id_adress` ASC) VISIBLE,
  CONSTRAINT `id_adress`
    FOREIGN KEY (`id_adress`)
    REFERENCES `optica`.`adress` (`id_adress`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `optica`.`marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`marca` (
  `id_marca` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `id_proveedor` INT NOT NULL,
  PRIMARY KEY (`id_marca`),
  INDEX `fk_marca_proveedor1_idx` (`id_proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_marca_proveedor1`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `optica`.`proveedor` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`cristal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`cristal` (
  `id_cristal` INT NOT NULL AUTO_INCREMENT,
  `graduacion` DECIMAL(4,2) NOT NULL,
  `color` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_cristal`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`montura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`montura` (
  `id_montura` INT NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('flotante', 'pasta', 'metalica') NOT NULL,
  `color` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_montura`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`gafas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`gafas` (
  `id_gafas` INT NOT NULL,
  `id_marca` INT NOT NULL,
  `precio` DECIMAL(6,2) NULL,
  `id_cristal_izquierdo` INT NOT NULL,
  `id_cristal_derecho` INT NOT NULL,
  `id_montura` INT NOT NULL,
  PRIMARY KEY (`id_gafas`),
  INDEX `fk_gafas_marca1_idx` (`id_marca` ASC) VISIBLE,
  INDEX `fk_gafas_cristal1_idx` (`id_cristal_izquierdo` ASC) VISIBLE,
  INDEX `fk_gafas_cristal2_idx` (`id_cristal_derecho` ASC) VISIBLE,
  INDEX `fk_gafas_montura1_idx` (`id_montura` ASC) VISIBLE,
  CONSTRAINT `fk_gafas_marca1`
    FOREIGN KEY (`id_marca`)
    REFERENCES `optica`.`marca` (`id_marca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gafas_cristal1`
    FOREIGN KEY (`id_cristal_izquierdo`)
    REFERENCES `optica`.`cristal` (`id_cristal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gafas_cristal2`
    FOREIGN KEY (`id_cristal_derecho`)
    REFERENCES `optica`.`cristal` (`id_cristal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gafas_montura1`
    FOREIGN KEY (`id_montura`)
    REFERENCES `optica`.`montura` (`id_montura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `id_adress` INT NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `correo_electronico` VARCHAR(45) NULL,
  `fecha_registro` DATE NOT NULL,
  PRIMARY KEY (`id_cliente`),
  INDEX `fk_cliente_adress1_idx` (`id_adress` ASC) VISIBLE,
  CONSTRAINT `fk_cliente_adress1`
    FOREIGN KEY (`id_adress`)
    REFERENCES `optica`.`adress` (`id_adress`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`cliente_recomendacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`cliente_recomendacion` (
  `id_cliente` INT NOT NULL,
  `id_cliente_recomendador` INT NOT NULL,
  PRIMARY KEY (`id_cliente`),
  INDEX `fk_cliente_recomendacion_cliente1_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_cliente_recomendacion_cliente2_idx` (`id_cliente_recomendador` ASC) VISIBLE,
  CONSTRAINT `fk_cliente_recomendacion_cliente1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `optica`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cliente_recomendacion_cliente2`
    FOREIGN KEY (`id_cliente_recomendador`)
    REFERENCES `optica`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`empleado` (
  `id_empleado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_empleado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`venta` (
  `id_venta` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `id_empleado` INT NOT NULL,
  PRIMARY KEY (`id_venta`),
  INDEX `fk_venta_cliente1_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_venta_empleado1_idx` (`id_empleado` ASC) VISIBLE,
  CONSTRAINT `fk_venta_cliente1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `optica`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venta_empleado1`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `optica`.`empleado` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`venta_gafas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`venta_gafas` (
  `id_venta` INT NOT NULL,
  `id_gafas` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`id_venta`, `id_gafas`),
  INDEX `fk_venta_gafas_gafas1_idx` (`id_gafas` ASC) VISIBLE,
  CONSTRAINT `fk_venta_gafas_venta1`
    FOREIGN KEY (`id_venta`)
    REFERENCES `optica`.`venta` (`id_venta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venta_gafas_gafas1`
    FOREIGN KEY (`id_gafas`)
    REFERENCES `optica`.`gafas` (`id_gafas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
