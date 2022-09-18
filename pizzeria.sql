-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`provincia` (
  `id_provincia` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_provincia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`localidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`localidad` (
  `id_localidad` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `id_provincia` INT NOT NULL,
  PRIMARY KEY (`id_localidad`),
  INDEX `fk_localidad_provincia_idx` (`id_provincia` ASC) VISIBLE,
  CONSTRAINT `fk_localidad_provincia`
    FOREIGN KEY (`id_provincia`)
    REFERENCES `pizzeria`.`provincia` (`id_provincia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido1` VARCHAR(45) NOT NULL,
  `apellido2` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `codigo_postal` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NULL DEFAULT NULL,
  `id_localidad` INT NOT NULL,
  PRIMARY KEY (`id_cliente`),
  INDEX `fk_cliente_localidad_idx` (`id_localidad` ASC) VISIBLE,
  CONSTRAINT `fk_cliente_localidad`
    FOREIGN KEY (`id_localidad`)
    REFERENCES `pizzeria`.`localidad` (`id_localidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `pizzeria`.`tienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`tienda` (
  `id_tienda` INT NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(45) NOT NULL,
  `codigo_postal` VARCHAR(45) NOT NULL,
  `id_localidad` INT NOT NULL,
  PRIMARY KEY (`id_tienda`),
  INDEX `fk_tienda_localidad1_idx` (`id_localidad` ASC) VISIBLE,
  CONSTRAINT `fk_tienda_localidad1`
    FOREIGN KEY (`id_localidad`)
    REFERENCES `pizzeria`.`localidad` (`id_localidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `fecha_hora` TIMESTAMP NOT NULL,
  `tipo` ENUM('domicilio', 'tienda') NOT NULL,
  `id_cliente` INT NOT NULL,
  `id_tienda` INT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedido_cliente1_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_pedido_tienda1_idx` (`id_tienda` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_cliente1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `pizzeria`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_tienda1`
    FOREIGN KEY (`id_tienda`)
    REFERENCES `pizzeria`.`tienda` (`id_tienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`categoria` (
  `id_categoria` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`id_categoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`producto` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(200) NULL,
  `imagen` VARCHAR(256) NULL,
  `precio_unitario` DECIMAL(6,2) NOT NULL,
  `id_categoria` INT NULL,
  PRIMARY KEY (`id_producto`),
  INDEX `fk_producto_categoria1_idx` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_producto_categoria1`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `pizzeria`.`categoria` (`id_categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`empleado` (
  `id_empleado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido1` VARCHAR(45) NOT NULL,
  `apellido2` VARCHAR(45) NULL,
  `nif` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NULL,
  `tipo` ENUM('cocinero', 'repartidor') NOT NULL,
  `id_tienda` INT NOT NULL,
  PRIMARY KEY (`id_empleado`),
  INDEX `fk_empleado_tienda1_idx` (`id_tienda` ASC) VISIBLE,
  CONSTRAINT `fk_empleado_tienda1`
    FOREIGN KEY (`id_tienda`)
    REFERENCES `pizzeria`.`tienda` (`id_tienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`delivery` (
  `Id_pedido` INT NOT NULL,
  `Id_empleado` INT NOT NULL,
  `fecha_hora` TIMESTAMP NOT NULL,
  PRIMARY KEY (`Id_pedido`, `Id_empleado`),
  INDEX `fk_delivery_empleado1_idx` (`Id_empleado` ASC) VISIBLE,
  CONSTRAINT `fk_delivery_pedido1`
    FOREIGN KEY (`Id_pedido`)
    REFERENCES `pizzeria`.`pedido` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_delivery_empleado1`
    FOREIGN KEY (`Id_empleado`)
    REFERENCES `pizzeria`.`empleado` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pedido_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pedido_producto` (
  `id_pedido` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`id_pedido`, `id_producto`),
  INDEX `fk_pedido_producto_pedido1_idx` (`id_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_producto_producto1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `pizzeria`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_producto_pedido1`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `pizzeria`.`pedido` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
