------------------------------------------------------------
-- Script Postgre 
--
-- Créé le : 07/03/2016
-- Modifié le : 11/04/2016
--
-- Par : Tony VINCENT
------------------------------------------------------------


-- Schema: bd_territoire

-- DROP SCHEMA bd_territoire;

CREATE SCHEMA bd_territoire
  AUTHORIZATION postgres;


------------------------------------------------------------
-- Table: bd_territoire.tm_appartenance_geo_com_libelle
------------------------------------------------------------ 

-- DROP TABLE bd_territoire.tm_appartenance_geo_com_libelle;

CREATE TABLE bd_territoire.tm_appartenance_geo_com_libelle AS
  SELECT * FROM ref_zonage_terri.t_appartenance_geo_com_libelle;

ALTER TABLE bd_territoire.tm_appartenance_geo_com_libelle ADD PRIMARY KEY (numcom);

------------------------------------------------------------
-- Table: bd_territoire.tm_appartenance_geo_com_epci
------------------------------------------------------------ 

-- DROP TABLE bd_territoire.tm_appartenance_geo_com_terricontract;

CREATE TABLE bd_territoire.tm_appartenance_geo_com_terricontract AS
  SELECT * FROM ref_zonage_terri.t_appartenance_geo_com_terricontract;

ALTER TABLE bd_territoire.tm_appartenance_geo_com_terricontract ADD PRIMARY KEY (numcom);

------------------------------------------------------------
-- Table: bd_territoire.tm_appartenance_geo_com_cae
------------------------------------------------------------ 

-- DROP TABLE bd_territoire.tm_appartenance_geo_com_cae;

CREATE TABLE bd_territoire.tm_appartenance_geo_com_cae AS
  SELECT * FROM ref_zonage_terri.t_appartenance_geo_com_cae;

ALTER TABLE bd_territoire.tm_appartenance_geo_com_cae ADD PRIMARY KEY (numcom,numcae);

    
  
------------------------------------------------------------
-- Table: t_civilite
------------------------------------------------------------
CREATE TABLE bd_territoire.t_civilite(
	tciv_id      SERIAL NOT NULL ,
	tciv_code    VARCHAR (10)  ,
	tciv_libelle VARCHAR (255)  ,
	CONSTRAINT prk_constraint_t_civilite PRIMARY KEY (tciv_id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: t_parti_politique
------------------------------------------------------------
CREATE TABLE bd_territoire.t_parti_politique(
	tpp_id      SERIAL NOT NULL ,
	tpp_code    VARCHAR (25) NOT NULL UNIQUE,
	tpp_libelle VARCHAR (255)  ,
	CONSTRAINT prk_constraint_t_parti_politique PRIMARY KEY (tpp_id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: t_utilisateur
------------------------------------------------------------
CREATE TABLE bd_territoire.t_acteur(
	tact_id       SERIAL NOT NULL ,
	tact_code     VARCHAR (25) NOT NULL UNIQUE ,
	tact_nom      VARCHAR (100)  NOT NULL,
	tact_prenom   VARCHAR (100)  ,
	tact_mail     VARCHAR (100)  ,
	tact_tel      VARCHAR (10)  ,
	tact_portable VARCHAR (10)  ,
	tact_fax      VARCHAR (10)  ,
	tact_actif    BOOL   ,
	tciv_code     VARCHAR (10)  NOT NULL  DEFAULT 'NR',
	tpp_code      VARCHAR (25) NOT NULL  DEFAULT 'NR',
	CONSTRAINT prk_constraint_t_acteur PRIMARY KEY (tact_id)
)WITHOUT OIDS;
ALTER TABLE bd_territoire.t_civilite ADD CONSTRAINT t_civilite_tciv_code_key UNIQUE(tciv_code);
ALTER TABLE bd_territoire.t_acteur ADD CONSTRAINT FK_t_acteur_tciv_code FOREIGN KEY (tciv_code) REFERENCES bd_territoire.t_civilite(tciv_code);
ALTER TABLE bd_territoire.t_acteur ADD CONSTRAINT t_acteur_tact_code_key UNIQUE(tact_code);
ALTER TABLE bd_territoire.t_acteur ADD CONSTRAINT FK_t_acteur_tpp_code FOREIGN KEY (tpp_code) REFERENCES bd_territoire.t_parti_politique(tpp_code);


------------------------------------------------------------
-- Table: t_fonction
------------------------------------------------------------
CREATE TABLE bd_territoire.t_fonction(
	tfct_id      SERIAL NOT NULL ,
	tfct_code    VARCHAR (25) NOT NULL UNIQUE,
	tfct_libelle VARCHAR (255) NOT NULL ,
	CONSTRAINT prk_constraint_t_fonction PRIMARY KEY (tfct_id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: t_structure_type
------------------------------------------------------------
CREATE TABLE bd_territoire.t_structure_type(
	tstructt_id      SERIAL NOT NULL ,
	tstructt_code    VARCHAR (25) NOT NULL UNIQUE,
	tstructt_libelle VARCHAR (255) NOT NULL ,
	CONSTRAINT prk_constraint_t_structure_type PRIMARY KEY (tstructt_id)
)WITHOUT OIDS;


------------------------------------------------------------
-- Table: t_service
------------------------------------------------------------
CREATE TABLE bd_territoire.t_service(
	tserv_id           SERIAL NOT NULL ,
	tserv_code         VARCHAR (10) NOT NULL UNIQUE,
	tserv_libelle      VARCHAR (255) NOT NULL ,
	tserv_tel          VARCHAR (10) ,
	tserv_portable     VARCHAR (10) ,
	tserv_fax          VARCHAR (10) ,
	tserv_mail         VARCHAR (100) ,
	tserv_web          VARCHAR (255) ,
	tserv_adresse      VARCHAR (255)  ,
	tserv_boite_postal VARCHAR (30)  ,
	tserv_code_postal  VARCHAR (6)  ,
	tserv_num_com      VARCHAR (6)  ,
	tserv_nom_com      VARCHAR (255)  ,
	tservt_code        VARCHAR (10)  NOT NULL DEFAULT 'NR',
	CONSTRAINT prk_constraint_t_service PRIMARY KEY (tserv_id)
)WITHOUT OIDS;
--ALTER TABLE bd_territoire.t_service_type ADD CONSTRAINT t_service_type_tservt_code_key UNIQUE(tservt_code);
ALTER TABLE bd_territoire.t_service ADD CONSTRAINT FK_t_service_tservt_code FOREIGN KEY (tservt_code) REFERENCES bd_territoire.t_service_type(tservt_code);


------------------------------------------------------------
-- Table: t_acteur
------------------------------------------------------------
--DROP TABLE bd_territoire.t_structure;

CREATE TABLE bd_territoire.t_structure
(
  tstruct_id serial NOT NULL,
  tstruct_code_officiel character varying(15) NOT NULL,
  tstruct_code character varying(25) NOT NULL UNIQUE,
  tstruct_libelle character varying(255),
  tstruct_siret character varying(25),
  tstruct_adresse character varying(255),
  tstruct_boite_postal character varying(30),
  tstruct_nom_com character varying(255),
  tstruct_code_postal character varying(6),
  tstruct_num_com character varying(6),
  tstruct_tel character varying(10),
  tstruct_fax character varying(10),
  tstruct_mail character varying(100),
  tstruct_web character varying(255),
  tstructt_code character varying(25) NOT NULL DEFAULT 'NR'::character varying,
  CONSTRAINT prk_constraint_t_structure PRIMARY KEY (tstruct_code_officiel,tstructt_code),
  CONSTRAINT fk_t_structure_tactt_code FOREIGN KEY (tstructt_code)
      REFERENCES bd_territoire.t_structure_type (tstructt_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
--ALTER TABLE bd_territoire.t_structure ADD CONSTRAINT FK_t_structure_tactt_code FOREIGN KEY (tstructt_code) REFERENCES bd_territoire.t_structure_type(tstructt_code);
ALTER TABLE bd_territoire.t_structure ADD CONSTRAINT prk_constraint_t_structure UNIQUE(tstruct_code_officiel,tstructt_code);

------------------------------------------------------------
-- Table: tr_emploi
------------------------------------------------------------
DROP TABLE bd_territoire.tr_emploi;

CREATE TABLE bd_territoire.tr_emploi
(
  tact_code 	character varying(25) NOT NULL,
  tfct_code 	character varying(25) NOT NULL,
  tstruct_code_officiel	character varying(25) NOT NULL,
  tserv_code 	character varying(25) NOT NULL,
  CONSTRAINT prk_constraint_tr_emploi PRIMARY KEY (tact_code, tfct_code, tstruct_code_officiel, tserv_code),
  CONSTRAINT fk_tr_emploi_tact_code FOREIGN KEY (tact_code)
      REFERENCES bd_territoire.t_acteur (tact_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_tr_emploi_tfct_code FOREIGN KEY (tfct_code)
      REFERENCES bd_territoire.t_fonction (tfct_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_tr_emploi_tstruct_code_officiel FOREIGN KEY (tstruct_code_officiel)
      REFERENCES bd_territoire.t_structure (tstruct_code_officiel) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_tr_emploi_tserv_code FOREIGN KEY (tserv_code)
      REFERENCES bd_territoire.t_service (tserv_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bd_territoire.tr_emploi
  OWNER TO postgres;
 

------------------------------------------------------------
-- Table: tr_strucut_rattache
------------------------------------------------------------
DROP TABLE bd_territoire.tr_struct_rattache;

CREATE TABLE bd_territoire.tr_struct_rattache
(
  tstruct_code_officiel character varying(25) NOT NULL,
  numcom 	character varying(5) NOT NULL,
  CONSTRAINT prk_constraint_tr_struct_rattache PRIMARY KEY (tstruct_code_officiel, numcom),
  CONSTRAINT fk_tr_struct_rattache_numcom FOREIGN KEY (numcom)
      REFERENCES bd_territoire.tm_appartenance_geo_com_libelle (numcom) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_tr_struct_rattache_tstruct_code_officiel FOREIGN KEY (tstruct_code_officiel)
      REFERENCES bd_territoire.t_structure (tstruct_code_officiel) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bd_territoire.tr_struct_rattache
  OWNER TO postgres;



------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- View
------------------------------------------------------------
------------------------------------------------------------


------------------------------------------------------------
-- View: bd_territoire.v_annuaire_elu (Union de toute les sélections)
--
-- Liste des élus par mandats
------------------------------------------------------------
DROP VIEW bd_territoire.v_annuaire_elu;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu AS 
(SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom AS numzone, v1.nomcom aS nomzone,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numcom::text
		AND tfct_code = 'MAIRE'
	) v1,
	(SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('MAIRE')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text)
UNION
  (SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numdep as numzone, v1.nomdep as nomzone,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numdep, t2.nomdep ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numdep::text
		AND tfct_code IN ('PDT','VPDT')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PDT','VPDT')
			AND t3.tstructt_code  IN ('COLDEP','COLREG')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
ORDER BY v2.tstructt_code,v2.tfct_code,v1.numdep ASC) 
UNION
(
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcae as numzone, v1.nomcae as nomzone,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numcae, t2.nomcae
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_cae t2
		WHERE t1.tstruct_code_officiel::text = t2.numcae::text
		AND tfct_code = 'CG'
	) v1,
	(SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('CG')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
)
UNION
(
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numdep as numzone, v1.nomdep as numzone,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numdep, t2.nomdep ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numdep::text
		AND tfct_code IN ('PREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PREF')
			AND t3.tstructt_code  IN ('ETATDEP')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
ORDER BY v2.tstructt_code,v2.tfct_code,v1.numdep ASC
)
UNION
(
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numreg as numzone, v1.nomreg as numzone,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numreg, t2.nomreg ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numreg::text
		AND tfct_code IN ('PREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PREF')
			AND t3.tstructt_code  IN ('ETATNAT')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
ORDER BY v2.tstructt_code,v2.tfct_code,v1.numreg ASC
)
UNION
(
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numarr as numzone, v1.nomarr as nomzone,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numarr, t2.nomarr ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numarr::text
		AND tfct_code IN ('SOUSPREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('SOUSPREF')
			AND t3.tstructt_code  IN ('ETATDEP','ETATNAT')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
)
UNION
(
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numdep as numzone, v1.nomdep as nomzone, 
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numdep, t2.nomdep, t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numdep::text
		AND tfct_code IN ('SEN')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('SEN')
			AND t3.tstructt_code  IN ('CIRCDEP')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
)
UNION(
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numarr, v1.nomarr, v1.numcae, v1.nomcae, v1.numepci, v1.nomepci,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, t4.numepci, t4.nomepci
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2,
		    bd_territoire.tm_appartenance_geo_com_cae t3,
		    bd_territoire.tm_appartenance_geo_com_epci t4
		WHERE t1.tstruct_code_officiel::text = t2.numdep::text
		AND t2.numcom = t3.numcom
		AND t3.numcom = t4.numcom
		AND tfct_code IN ('PREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PREF')
			AND t3.tstructt_code  IN ('ETATDEP')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
ORDER BY v2.tstructt_code,v2.tfct_code,v1.numcom ASC
)
UNION(
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numarr, v1.nomarr, v1.numcae, v1.nomcae, v1.numepci, v1.nomepci,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, t4.numepci, t4.nomepci
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2,
		    bd_territoire.tm_appartenance_geo_com_cae t3,
		    bd_territoire.tm_appartenance_geo_com_epci t4
		WHERE t1.tstruct_code_officiel::text = t2.numdep::text
		AND t2.numcom = t3.numcom
		AND t3.numcom = t4.numcom
		AND tfct_code IN ('PREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PREF')
			AND t3.tstructt_code  IN ('ETATNAT')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
ORDER BY v2.tstructt_code,v2.tfct_code,v1.numcom ASC
);




------------------------------------------------------------
-- View: bd_territoire.v_annuaire_elu_commune (Union de toute les sélections)
--
-- Liste des élus à la commune
------------------------------------------------------------
------------------------------------------------------------
-- Modifié le : 28/11/2016
-- Par : Tony VINCENT
------------------------------------------------------------
DROP VIEW bd_territoire.v_annuaire_elu_commune;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_commune AS 
( 
	(
		(
			(
			-- On récupére les MAIRES
			SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numarr, v1.nomarr, 
			    v1.numcae, v1.nomcae, v1.numepci, v1.nomepci, v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, 
			    v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal, v2.tstruct_tel, v2.tstruct_fax, 
			    v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, v2.tact_mail, v2.tact_tel, 
			    v2.tact_portable, v2.tact_fax, v2.tciv_code
			FROM (
			    -- Union pour avoir les codes EPCI en focntion des départements
			    SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, 
				t4.numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
			    FROM bd_territoire.tr_emploi t1, 
				bd_territoire.tm_appartenance_geo_com_libelle t2, 
				bd_territoire.tm_appartenance_geo_com_cae t3, 
				bd_territoire.tm_appartenance_geo_com_epci t4,
				bd_territoire.tm_appartenance_geo_com_cirleg t6
			    WHERE t1.tstruct_code_officiel::text = t2.numcom::text 
				AND t1.tstruct_code_officiel::text = t3.numcom::text 
				AND t1.tstruct_code_officiel::text = t4.numcom::text 
				AND t1.tfct_code::text = 'MAIRE'::text
				AND t4.numdep NOT IN ('16','17','79', '86')
				AND t2.numcom = t6.numcom		
			    UNION
			    SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, 
				t4.numcrpcepci AS numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
			    FROM bd_territoire.tr_emploi t1, 
				bd_territoire.tm_appartenance_geo_com_libelle t2, 
				bd_territoire.tm_appartenance_geo_com_cae t3, 
				bd_territoire.tm_appartenance_geo_com_epci t4,
				bd_territoire.tm_appartenance_geo_com_cirleg t6
			    WHERE t1.tstruct_code_officiel::text = t2.numcom::text 
				AND t1.tstruct_code_officiel::text = t3.numcom::text 
				AND t1.tstruct_code_officiel::text = t4.numcom::text 
				AND t1.tfct_code::text = 'MAIRE'::text
				AND t4.numdep IN ('16','17','79', '86')
				AND t2.numcom = t6.numcom
			    ) v1, 
			    (SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, 
				t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, 
				t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, 
				t5.tact_portable, t5.tact_fax, t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
			    FROM bd_territoire.tr_emploi t1, 
				bd_territoire.t_structure t3, 
				bd_territoire.t_fonction t4, 
				bd_territoire.t_acteur t5, 
				bd_territoire.t_parti_politique t6, 
				bd_territoire.t_civilite t7
			    WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
				AND t1.tfct_code::text = t4.tfct_code::text 
				AND t1.tact_code::text = t5.tact_code::text 
				AND t5.tpp_code::text = t6.tpp_code::text 
				AND t5.tciv_code::text = t7.tciv_code::text 
				AND t4.tfct_code::text <> 'NR'::text 
				AND t1.tfct_code::text = 'MAIRE'::text
			    ) v2
			WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
			ORDER BY v1.numcom
			)
		    UNION 
			(
			    -- On récupére les CG
			    SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numarr, v1.nomarr, 
				v1.numcae, v1.nomcae, v1.numepci, v1.nomepci, v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, 
				v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal, v2.tstruct_tel, v2.tstruct_fax, 
				v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, v2.tact_mail, v2.tact_tel, 
				v2.tact_portable, v2.tact_fax, v2.tciv_code
			    FROM ( 
				-- Union pour avoir les codes EPCI en focntion des départements
				SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t3.numarr, t3.nomarr, t2.numcae, 
				    t2.nomcae, t4.numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
				FROM bd_territoire.tr_emploi t1, 
				    bd_territoire.tm_appartenance_geo_com_cae t2, 
				    bd_territoire.tm_appartenance_geo_com_libelle t3, 
				    bd_territoire.tm_appartenance_geo_com_epci t4,
				bd_territoire.tm_appartenance_geo_com_cirleg t6
                                WHERE t1.tstruct_code_officiel::text = t2.numcae::text 
				    AND t2.numcom::text = t3.numcom::text 
				    AND t2.numcom::text = t4.numcom::text 
				    AND t1.tfct_code::text = 'CG'::text
				    AND t4.numdep NOT IN ('16','17','79', '86')
				    AND t2.numcom = t6.numcom
				UNION
				SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t3.numarr, t3.nomarr, t2.numcae, 
				    t2.nomcae, t4.numcrpcepci AS numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
				FROM bd_territoire.tr_emploi t1, 
				    bd_territoire.tm_appartenance_geo_com_cae t2, 
				    bd_territoire.tm_appartenance_geo_com_libelle t3, 
				    bd_territoire.tm_appartenance_geo_com_epci t4,
				    bd_territoire.tm_appartenance_geo_com_cirleg t6
                                WHERE t1.tstruct_code_officiel::text = t2.numcae::text 
				    AND t2.numcom::text = t3.numcom::text 
				    AND t2.numcom::text = t4.numcom::text 
				    AND t1.tfct_code::text = 'CG'::text
				    AND t4.numdep IN ('16','17','79', '86')
				    AND t2.numcom = t6.numcom
				) v1, 
				(SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
                                FROM bd_territoire.tr_emploi t1, 
				    bd_territoire.t_structure t3, 
				    bd_territoire.t_fonction t4, 
				    bd_territoire.t_acteur t5, 
				    bd_territoire.t_parti_politique t6, 
				    bd_territoire.t_civilite t7
				WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
				    AND t1.tfct_code::text = t4.tfct_code::text 
				    AND t1.tact_code::text = t5.tact_code::text 
				    AND t5.tpp_code::text = t6.tpp_code::text 
				    AND t5.tciv_code::text = t7.tciv_code::text 
				    AND t4.tfct_code::text <> 'NR'::text 
				    AND t1.tfct_code::text = 'CG'::text
				) v2
			    WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
			    ORDER BY v1.numcae, v1.numcom)
			)
		    UNION 
                        ( 
			-- On récupére les SOUSPREF
			SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numarr, v1.nomarr, 
				v1.numcae, v1.nomcae, v1.numepci, v1.nomepci, v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, 
				v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal, v2.tstruct_tel, v2.tstruct_fax, 
				v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, v2.tact_mail, v2.tact_tel, 
				v2.tact_portable, v2.tact_fax, v2.tciv_code
                           FROM (
				-- Union pour avoir les codes EPCI en focntion des départements
				SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, 
				    t3.nomcae, t4.numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
				FROM bd_territoire.tr_emploi t1, 
				    bd_territoire.tm_appartenance_geo_com_libelle t2, 
				    bd_territoire.tm_appartenance_geo_com_cae t3, 
				    bd_territoire.tm_appartenance_geo_com_epci t4,
				    bd_territoire.tm_appartenance_geo_com_cirleg t6
				WHERE t1.tstruct_code_officiel::text = t2.numarr::text 
				    AND t2.numcom::text = t3.numcom::text 
				    AND t2.numcom::text = t4.numcom::text 
				    AND t1.tfct_code::text = 'SOUSPREF'::text
				    AND t4.numdep NOT IN ('16','17','79', '86')
				    AND t2.numcom = t6.numcom
				UNION
				SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, 
				    t3.nomcae, t4.numcrpcepci AS numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
				FROM bd_territoire.tr_emploi t1, 
				    bd_territoire.tm_appartenance_geo_com_libelle t2, 
				    bd_territoire.tm_appartenance_geo_com_cae t3, 
				    bd_territoire.tm_appartenance_geo_com_epci t4,
				    bd_territoire.tm_appartenance_geo_com_cirleg t6
				WHERE t1.tstruct_code_officiel::text = t2.numarr::text 
				    AND t2.numcom::text = t3.numcom::text 
				    AND t2.numcom::text = t4.numcom::text 
				    AND t1.tfct_code::text = 'SOUSPREF'::text
				    AND t4.numdep IN ('16','17','79', '86')
				    AND t2.numcom = t6.numcom
				) v1
				, ( SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
                                   FROM bd_territoire.tr_emploi t1, bd_territoire.t_structure t3, bd_territoire.t_fonction t4, bd_territoire.t_acteur t5, bd_territoire.t_parti_politique t6, bd_territoire.t_civilite t7
                                  WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text AND t1.tstructt_code::text = t3.tstructt_code::text AND t1.tfct_code::text = t4.tfct_code::text AND t1.tact_code::text = t5.tact_code::text AND t5.tpp_code::text = t6.tpp_code::text AND t5.tciv_code::text = t7.tciv_code::text AND t4.tfct_code::text <> 'NR'::text AND t1.tfct_code::text = 'SOUSPREF'::text AND (t3.tstructt_code::text = ANY (ARRAY['ETATDEP'::character varying::text, 'ETATNAT'::character varying::text]))) v2
			    WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
			    ORDER BY v1.numcae, v1.numcom)
			)
		    UNION 
			( 
			-- On récupére les PREF pour tstructt_code = 'ETATDEP'
			SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numarr, v1.nomarr, v1.numcae, 
			    v1.nomcae, v1.numepci, v1.nomepci, v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, 
			    v2.tstruct_adresse, v2.tstruct_boite_postal, v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, 
			    v2.tact_code, v2.tact_nom, v2.tact_prenom, v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
			FROM ( 
			    -- Union pour avoir les codes EPCI en focntion des départements
			    SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, 
				t4.numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
			    FROM bd_territoire.tr_emploi t1, 
				bd_territoire.tm_appartenance_geo_com_libelle t2, 
				bd_territoire.tm_appartenance_geo_com_cae t3, 
				bd_territoire.tm_appartenance_geo_com_epci t4,
				bd_territoire.tm_appartenance_geo_com_cirleg t6
			    WHERE t1.tstruct_code_officiel::text = t2.numdep::text 
				AND t2.numcom::text = t3.numcom::text 
				AND t3.numcom::text = t4.numcom::text 
				AND t1.tfct_code::text = 'PREF'::text
				AND t4.numdep NOT IN ('16','17','79', '86')
				AND t2.numcom = t6.numcom
			    UNION
			    SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, 
				t4.numcrpcepci AS numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
			    FROM bd_territoire.tr_emploi t1, 
				bd_territoire.tm_appartenance_geo_com_libelle t2, 
				bd_territoire.tm_appartenance_geo_com_cae t3, 
				bd_territoire.tm_appartenance_geo_com_epci t4,
				bd_territoire.tm_appartenance_geo_com_cirleg t6
			    WHERE t1.tstruct_code_officiel::text = t2.numdep::text 
				AND t2.numcom::text = t3.numcom::text 
				AND t3.numcom::text = t4.numcom::text 
				AND t1.tfct_code::text = 'PREF'::text
				AND t4.numdep IN ('16','17','79', '86')
				AND t2.numcom = t6.numcom
			    ) v1, 
			    ( SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
			    FROM bd_territoire.tr_emploi t1, bd_territoire.t_structure t3, bd_territoire.t_fonction t4, bd_territoire.t_acteur t5, bd_territoire.t_parti_politique t6, bd_territoire.t_civilite t7
			    WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text AND t1.tstructt_code::text = t3.tstructt_code::text AND t1.tfct_code::text = t4.tfct_code::text AND t1.tact_code::text = t5.tact_code::text AND t5.tpp_code::text = t6.tpp_code::text AND t5.tciv_code::text = t7.tciv_code::text AND t4.tfct_code::text <> 'NR'::text AND t1.tfct_code::text = 'PREF'::text AND t3.tstructt_code::text = 'ETATDEP'::text) v2
			WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
			ORDER BY v2.tstructt_code, v2.tfct_code, v1.numcom)
			)
		UNION 
			( 
	-- On récupére les PREF pour tstructt_code = 'ETATNAT'
	SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numarr, v1.nomarr, v1.numcae, v1.nomcae,
	    v1.numepci, v1.nomepci, v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, 
	    v2.tstruct_boite_postal, v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, 
	    v2.tact_prenom, v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
           FROM ( 
		-- Union pour avoir les codes EPCI en focntion des départements
		SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, t4.numepci, 
		    t4.nomepci, t6.numcirleg, t6.nomcirleg
                FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2, 
		    bd_territoire.tm_appartenance_geo_com_cae t3, 
		    bd_territoire.tm_appartenance_geo_com_epci t4,
		    bd_territoire.tm_appartenance_geo_com_cirleg t6
		WHERE t1.tstruct_code_officiel::text = t2.numreg::text 
		    AND t2.numcom::text = t3.numcom::text 
		    AND t3.numcom::text = t4.numcom::text 
		    AND t1.tfct_code::text = 'PREF'::text
		    AND t4.numdep NOT IN ('16','17','79', '86')
		    AND t2.numcom = t6.numcom
		UNION    
		SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, t4.numcrpcepci AS numepci, 
		    t4.nomepci, t6.numcirleg, t6.nomcirleg
                FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2, 
		    bd_territoire.tm_appartenance_geo_com_cae t3, 
		    bd_territoire.tm_appartenance_geo_com_epci t4,
		    bd_territoire.tm_appartenance_geo_com_cirleg t6
		WHERE t1.tstruct_code_officiel::text = t2.numreg::text 
		    AND t2.numcom::text = t3.numcom::text 
		    AND t3.numcom::text = t4.numcom::text 
		    AND t1.tfct_code::text = 'PREF'::text
		    AND t4.numdep IN ('16','17','79', '86')
		    AND t2.numcom = t6.numcom
		) v1, 
		( SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
                   FROM bd_territoire.tr_emploi t1, bd_territoire.t_structure t3, bd_territoire.t_fonction t4, bd_territoire.t_acteur t5, bd_territoire.t_parti_politique t6, bd_territoire.t_civilite t7
                  WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text AND t1.tstructt_code::text = t3.tstructt_code::text AND t1.tfct_code::text = t4.tfct_code::text AND t1.tact_code::text = t5.tact_code::text AND t5.tpp_code::text = t6.tpp_code::text AND t5.tciv_code::text = t7.tciv_code::text AND t4.tfct_code::text <> 'NR'::text AND t1.tfct_code::text = 'PREF'::text AND t3.tstructt_code::text = 'ETATNAT'::text) v2
          WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
          ORDER BY v2.tstructt_code, v2.tfct_code, v1.numcom);

ALTER TABLE bd_territoire.v_annuaire_elu_commune
  OWNER TO postgres;
------------------------------------------------------------
-- View: Elus MAIRE
--
-- Liste des Maires
------------------------------------------------------------
DROP VIEW bd_territoire.v_annuaire_elu_terri_maire_seul;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_maire_seul AS 
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numcom::text
		AND tfct_code = 'MAIRE'
	) v1,
	(SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('MAIRE')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
;


------------------------------------------------------------
-- View: Elus MAIRE
--
-- Liste des Maires avec les champs : NUMARR, NOMARR, NUMCAE, NOMCAE, NUMEPCI et NOMEPCI
--
------------------------------------------------------------

DROP VIEW bd_territoire.v_annuaire_elu_terri_maire;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_maire AS 
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom,v1.numarr, v1.nomarr, v1.numcae, v1.nomcae, v1.numepci, v1.nomepci,
	v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, t4.numepci, t4.nomepci,
		    t6.numcirleg, t6.nomcirleg
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2,
		    bd_territoire.tm_appartenance_geo_com_cae t3,
		    bd_territoire.tm_appartenance_geo_com_epci t4,
		    bd_territoire.tm_appartenance_geo_com_cirleg t6
		WHERE t1.tstruct_code_officiel::text = t2.numcom::text
		AND t1.tstruct_code_officiel::text = t3.numcom::text
		AND t1.tstruct_code_officiel::text = t4.numcom::text
		AND tfct_code = 'MAIRE'
		AND t2.numcom = t6.numcom
		AND t4.numdep NOT IN ('16','17','79', '86')
	UNION	
	SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr, t3.numcae, t3.nomcae, t4.numcrpcepci AS numepci, t4.nomepci,
		    t6.numcirleg, t6.nomcirleg
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2,
		    bd_territoire.tm_appartenance_geo_com_cae t3,
		    bd_territoire.tm_appartenance_geo_com_epci t4,
		    bd_territoire.tm_appartenance_geo_com_cirleg t6
		WHERE t1.tstruct_code_officiel::text = t2.numcom::text
		AND t1.tstruct_code_officiel::text = t3.numcom::text
		AND t1.tstruct_code_officiel::text = t4.numcom::text
		AND tfct_code = 'MAIRE'
		AND t2.numcom = t6.numcom
		AND t4.numdep IN ('16','17','79', '86')
	) v1,
	(SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('MAIRE')
	) v2

  WHERE v1.tstruct_code_officiel = v2.tstruct_code_officiel  
;

ALTER TABLE bd_territoire.v_annuaire_elu_terri_maire
  OWNER TO postgres;


------------------------------------------------------------
-- View: Elus Présidents et Vice-Présidents
--
-- Liste des Présidents et Vice-Présidents
------------------------------------------------------------
--DROP VIEW bd_territoire.v_annuaire_elu_terri_pdt_vpdt;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_pdt_vpdt AS
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numdep, v1.nomdep,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_code_postal, v2.tstruct_nom_com,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numdep, t2.nomdep ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numdep::text
		AND tfct_code IN ('PDT','VPDT')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_code_postal, t3.tstruct_nom_com, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PDT','VPDT')
			AND t3.tstructt_code  IN ('COLDEP','COLREG')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
ORDER BY v2.tstructt_code,v2.tfct_code,v1.numdep ASC
;


------------------------------------------------------------
-- View: Elus CAE
------------------------------------------------------------
DROP VIEW bd_territoire.v_annuaire_elu_terri_cae_seul;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_cae_seul AS 
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numcae, v1.nomcae,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numcae, t2.nomcae
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_cae t2
		WHERE t1.tstruct_code_officiel::text = t2.numcae::text
		AND tfct_code = 'CG'
	) v1,
	(SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('CG')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
;

------------------------------------------------------------
-- Modifié le : 30/11/2016
-- Par : Tony VINCENT
------------------------------------------------------------
-- AVEC CHAMPS : NUMARR, NOMARR, NUMCAE, NOMCAE, NUMEPCI et NOMEPCI

DROP VIEW bd_territoire.v_annuaire_elu_terri_cae;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_cae AS 

 SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numarr, v1.nomarr, v1.numcae,
	v1.nomcae, v1.numepci, v1.nomepci, v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret,
	v2.tstruct_adresse, v2.tstruct_boite_postal, v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, 
	v2.tact_nom, v2.tact_prenom, v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
   FROM ( 
	SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t3.numarr, t3.nomarr, t2.numcae, t2.nomcae, t4.numepci, t4.nomepci, 
	    t6.numcirleg, t6.nomcirleg
           FROM bd_territoire.tr_emploi t1, 
		bd_territoire.tm_appartenance_geo_com_cae t2, 
		bd_territoire.tm_appartenance_geo_com_libelle t3,
		bd_territoire.tm_appartenance_geo_com_epci t4,
		bd_territoire.tm_appartenance_geo_com_cirleg t6
          WHERE t1.tstruct_code_officiel::text = t2.numcae::text 
		AND t2.numcom::text = t3.numcom::text 
		AND t2.numcom::text = t4.numcom::text 
		AND t1.tfct_code::text = 'CG'::text
		AND t4.numdep NOT IN ('16','17','79', '86')
		AND t2.numcom = t6.numcom
	UNION
	SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t3.numarr, t3.nomarr, t2.numcae, t2.nomcae, t4.numcrpcepci AS numepci, t4.nomepci, 
	    t6.numcirleg, t6.nomcirleg
           FROM bd_territoire.tr_emploi t1, 
		bd_territoire.tm_appartenance_geo_com_cae t2, 
		bd_territoire.tm_appartenance_geo_com_libelle t3,
		bd_territoire.tm_appartenance_geo_com_epci t4,
		bd_territoire.tm_appartenance_geo_com_cirleg t6
          WHERE t1.tstruct_code_officiel::text = t2.numcae::text 
		AND t2.numcom::text = t3.numcom::text 
		AND t2.numcom::text = t4.numcom::text 
		AND t1.tfct_code::text = 'CG'::text
		AND t4.numdep IN ('16','17','79', '86')
		AND t2.numcom = t6.numcom
	) v1, 
	( 
	SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, 
	    t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, 
	    t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, 
	    t5.tact_portable, t5.tact_fax, t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
	FROM bd_territoire.tr_emploi t1, bd_territoire.t_structure t3, bd_territoire.t_fonction t4, bd_territoire.t_acteur t5,
	    bd_territoire.t_parti_politique t6, bd_territoire.t_civilite t7
	WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
	    AND t1.tfct_code::text = t4.tfct_code::text 
	    AND t1.tact_code::text = t5.tact_code::text 
	    AND t5.tpp_code::text = t6.tpp_code::text 
	    AND t5.tciv_code::text = t7.tciv_code::text 
	    AND t4.tfct_code::text <> 'NR'::text 
	    AND t1.tfct_code::text = 'CG'::text
	) v2
  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
  ORDER BY v1.numcae, v1.numcom;


ALTER TABLE bd_territoire.v_annuaire_elu_terri_cae
  OWNER TO postgres;
  
------------------------------------------------------------
-- View: Elus Préfets
------------------------------------------------------------
--DROP VIEW bd_territoire.v_annuaire_elu_terri_pref_dept;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_pref_dept AS
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numdep, v1.nomdep,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numdep, t2.nomdep ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numdep::text
		AND tfct_code IN ('PREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PREF')
			AND t3.tstructt_code  IN ('ETATDEP')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
ORDER BY v2.tstructt_code,v2.tfct_code,v1.numdep ASC
;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_pref_reg AS
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numreg, v1.nomreg,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numreg, t2.nomreg ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numreg::text
		AND tfct_code IN ('PREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PREF')
			AND t3.tstructt_code  IN ('ETATNAT')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
ORDER BY v2.tstructt_code,v2.tfct_code,v1.numreg ASC
;
------------------------------------------------------------
-- View: Elus Sous Préfets
------------------------------------------------------------
CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_souspref_seul AS
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numarr, v1.nomarr,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numarr, t2.nomarr ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numarr::text
		AND tfct_code IN ('SOUSPREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('SOUSPREF')
			AND t3.tstructt_code  IN ('ETATDEP','ETATNAT')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
;


------------------------------------------------------------
-- View: Elus Sous Préfets
--
-- Liste des Sous-Préfets avec les champs : NUMARR, NOMARR, NUMCAE, NOMCAE, NUMEPCI et NOMEPCI
------------------------------------------------------------

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_souspref AS
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom,v1.numarr, v1.nomarr, v1.numcae, v1.nomcae,v1.numepci, v1.nomepci,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numarr, t2.nomarr,
t3.numcae, t3.nomcae, 
t4.numepci, t4.nomepci
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2,
		    bd_territoire.tm_appartenance_geo_com_cae t3,
		    bd_territoire.tm_appartenance_geo_com_epci t4
		WHERE t1.tstruct_code_officiel::text = t2.numarr::text
		AND t2.numcom = t3.numcom
		AND t2.numcom = t4.numcom
		AND tfct_code IN ('SOUSPREF')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('SOUSPREF')
			AND t3.tstructt_code  IN ('ETATDEP','ETATNAT')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
order by numcae,numcom asc
;

------------------------------------------------------------
-- View: Elus Sénateurs
------------------------------------------------------------
CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_SEN AS
SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numdep, v1.nomdep,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code_officiel, t2.numdep, t2.nomdep ,t1.tstructt_code
		FROM bd_territoire.tr_emploi t1, 
		    bd_territoire.tm_appartenance_geo_com_libelle t2
		WHERE t1.tstruct_code_officiel::text = t2.numdep::text
		AND tfct_code IN ('SEN')
	) v1,
	(SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code,t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4,
			bd_territoire.t_acteur t5,
			bd_territoire.t_parti_politique t6,
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
			AND t1.tstructt_code::text = t3.tstructt_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('SEN')
			AND t3.tstructt_code  IN ('CIRCDEP')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
;

------------------------------------------------------------
-- View: bd_territoire.v_annuaire_elu_terri_pdt_vpdt_terricontract
------------------------------------------------------------
------------------------------------------------------------
-- Créé le : 28/11/2016
-- Modifié le : 29/11/2016
-- Par : Tony VINCENT
------------------------------------------------------------
DROP VIEW bd_territoire.v_annuaire_elu_terri_pdt_vpdt_terricontract;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_pdt_vpdt_terricontract AS 

SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numdep, v1.numarr, v1.nomarr, v1.numcae, v1.nomcae, v1.numepci, v1.nomepci, v1.tdppays, v1.numtdppays, 
    v1.nomtdppays, v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal, 
    v2.tstruct_nom_com, v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
    v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
FROM (
	SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numdep, t5.numarr, t5.nomarr, t3.numcrpcepci AS numepci, t3.nomepci,  
	    t4.numcae, t4.nomcae, t6.numcirleg, t6.nomcirleg, t2.tdppays, t2.numtdppays, t2.nomtdppays, t1.tstructt_code
	FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.tm_appartenance_geo_com_terricontract t2,
	    bd_territoire.tm_appartenance_geo_com_epci t3,
	    bd_territoire.tm_appartenance_geo_com_cae t4,
	    bd_territoire.tm_appartenance_geo_com_libelle t5,
	    bd_territoire.tm_appartenance_geo_com_cirleg t6
        WHERE t1.tstruct_code_officiel::text = t3.numcrpcepci::text 
	    AND (t1.tfct_code::text = ANY (ARRAY['PDT'::character varying::text, 'VPDT'::character varying::text])) 
	    AND t2.numdep IN ('16','17','79', '86')
	    AND t2.numepci = t3.numepci
	    AND t2.numcom = t4.numcom
	    AND t2.numcom = t5.numcom
	    AND t2.numcom = t6.numcom
	UNION 
	SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numdep, t5.numarr, t5.nomarr, t2.numepci, t2.nomepci, 
	    t4.numcae, t4.nomcae, t6.numcirleg, t6.nomcirleg, t2.tdppays, t2.numtdppays, t2.nomtdppays, t1.tstructt_code
        FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.tm_appartenance_geo_com_terricontract t2,
	    bd_territoire.tm_appartenance_geo_com_cae t4,
	    bd_territoire.tm_appartenance_geo_com_libelle t5,
	    bd_territoire.tm_appartenance_geo_com_cirleg t6
        WHERE t1.tstruct_code_officiel::text = t2.numepci::text 
	    AND (t1.tfct_code::text = ANY (ARRAY['PDT'::character varying::text, 'VPDT'::character varying::text])) 
	    AND (t2.numdep::text <> ALL (ARRAY['16'::character varying::text, '17'::character varying::text, '79'::character varying::text, '86'::character varying::text]))
	    AND t2.numcom = t4.numcom
	    AND t2.numcom = t5.numcom
	    AND t2.numcom = t6.numcom
	UNION
	SELECT DISTINCT t1.tstruct_code_officiel, t2.numcom, t2.nomcom, t2.numdep, t5.numarr, t5.nomarr, t2.numepci, t2.nomepci, 
	    t4.numcae, t4.nomcae, t6.numcirleg, t6.nomcirleg, t2.tdppays, t2.numtdppays, t2.nomtdppays, t1.tstructt_code
	FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.tm_appartenance_geo_com_terricontract t2,
	    bd_territoire.tm_appartenance_geo_com_cae t4,
	    bd_territoire.tm_appartenance_geo_com_libelle t5,
	    bd_territoire.tm_appartenance_geo_com_cirleg t6
        WHERE t1.tstruct_code_officiel::text = t2.numtdppays::text 
	    AND (t1.tfct_code::text = ANY (ARRAY['PDT'::character varying::text, 'VPDT'::character varying::text]))
	    AND t2.numcom = t4.numcom
	    AND t2.numcom = t5.numcom
	    AND t2.numcom = t6.numcom
 	) v1,
	(
	SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, 
	    t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_nom_com, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, 
	    t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, 
	    t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
	FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.t_structure t3, 
	    bd_territoire.t_fonction t4, 
	    bd_territoire.t_acteur t5, 
	    bd_territoire.t_parti_politique t6, 
	    bd_territoire.t_civilite t7
	WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
	    AND t1.tstructt_code::text = t3.tstructt_code::text 
	    AND t1.tfct_code::text = t4.tfct_code::text 
	    AND t1.tact_code::text = t5.tact_code::text 
	    AND t5.tpp_code::text = t6.tpp_code::text 
	    AND t5.tciv_code::text = t7.tciv_code::text 
	    AND t4.tfct_code::text <> 'NR'::text 
	    AND (t1.tfct_code::text = ANY (ARRAY['PDT'::character varying::text, 'VPDT'::character varying::text])) 
	    AND (t3.tstructt_code::text = ANY (ARRAY['COLCC'::character varying::text, 'COLCA'::character varying::text, 'COLCU'::character varying::text, 'COLPA'::character varying::text, 'COLMETRO'::character varying::text]))
	) v2
WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
ORDER BY v2.tstructt_code, v2.tfct_code, v1.numdep;

ALTER TABLE bd_territoire.v_annuaire_elu_terri_pdt_vpdt_terricontract
  OWNER TO postgres;
  

------------------------------------------------------------
-- View: bd_territoire.v_annuaire_elu_terri_epci 
------------------------------------------------------------
DROP VIEW bd_territoire.v_annuaire_elu_terri_epci;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_epci AS 
 SELECT DISTINCT v1.tstruct_code, v2.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom,
	v1.idtypeepci,  v1.codetypeepci, v1.codeepci,  v1.numepci, v1.codecrpcepci, v1.numcrpcepci , v1.nomepci,
	v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal,
	v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
	v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
--	
 FROM (SELECT DISTINCT t1.tstruct_code, t1.tstruct_code_officiel, t1.numcom, t2.nomcom, t2.idtypeepci, t2.codetypeepci, t2.codeepci, t2.numepci, t2.codecrpcepci, t2.numcrpcepci, t2.nomepci
		FROM (SELECT v1.tstruct_code, v2.tstruct_code_officiel, v1.numcom FROM bd_territoire.tr_strucut_rattache v1, bd_territoire.t_structure v2 
			WHERE v1.tstruct_code = v2.tstruct_code
		) t1,
		ref_zonage_terri.t_appartenance_geo_com_epci t2
		WHERE t1.numcom::text = t2.numcom::text
	) v1,
	-- Liste des Elus
	(SELECT DISTINCT t3.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code, t3.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
		FROM bd_territoire.tr_emploi t1, 
			bd_territoire.t_structure t3, 
			bd_territoire.t_fonction t4, 
			bd_territoire.t_acteur t5, 
			bd_territoire.t_parti_politique t6, 
			bd_territoire.t_civilite t7
		WHERE t1.tstruct_code::text = t3.tstruct_code::text 
			AND t1.tfct_code::text = t4.tfct_code::text 
			AND t1.tact_code::text = t5.tact_code::text 
			AND t5.tpp_code::text = t6.tpp_code::text 
			AND t5.tciv_code::text = t7.tciv_code::text 
			AND t4.tfct_code::text <> 'NR'::text
			AND t1.tfct_code IN ('PDT','DEP','SEN','CG','CG','ELUREF','MAIRE','DEPEURO''PREF','SOUSPREF')
	) v2

  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text 
;
COMMENT ON VIEW bd_territoire.v_annuaire_elu_terri_epci
  IS 'Vue contenant les acteurs, leurs fonctions et leurs parties politique liés aux EPCI';


------------------------------------------------------------
-- View: bd_territoire.v_annuaire_elu_terri_pdt_vpdt_epci
------------------------------------------------------------
------------------------------------------------------------
-- Créé le : 
-- Modifié le : 30/11/2016
-- Par : Tony VINCENT
------------------------------------------------------------
DROP VIEW bd_territoire.v_annuaire_elu_terri_pdt_vpdt_epci;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_pdt_vpdt_epci AS 

SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom,v1.nomcom, v1.numarr, v1.nomarr,	v1.numcae, v1.nomcae, v1.numdep, 
	v1.numepci, v1.nomepci, v1.numcirleg, v1.nomcirleg, v2.tfct_code, v2.tfct_libelle, 
    v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal, v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, 
    v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
   FROM (
	SELECT DISTINCT t1.tstruct_code_officiel, t1.tstructt_code, t1.tfct_code,
	    t2.numcom, t2.nomcom, t2.numarr, t2.nomarr ,
	    t3.numcae, t3.nomcae,
	    t4.numdep, t4.numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
	FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.tm_appartenance_geo_com_libelle t2,
	    bd_territoire.tm_appartenance_geo_com_cae t3,
	    bd_territoire.tm_appartenance_geo_com_epci t4,
	    bd_territoire.tm_appartenance_geo_com_cirleg t6
	WHERE t1.tstruct_code_officiel::text = t4.numepci::text 
	    AND t2.numcom = t4.numcom
	    AND t2.numcom = t3.numcom
	    AND (t1.tfct_code::text = ANY (ARRAY['PDT'::character varying, 'VPDT'::character varying]::text[]))
	    AND t4.numdep  NOT IN ('16','17','79', '86')
	    AND t2.numcom = t6.numcom
	UNION
	SELECT DISTINCT t1.tstruct_code_officiel, t1.tstructt_code, t1.tfct_code,
	    t2.numcom, t2.nomcom, t2.numarr, t2.nomarr,
	    t3.numcae, t3.nomcae,
	    t4.numdep, t4.numcrpcepci AS numepci, t4.nomepci, t6.numcirleg, t6.nomcirleg
	FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.tm_appartenance_geo_com_libelle t2,
	    bd_territoire.tm_appartenance_geo_com_cae t3,
	    bd_territoire.tm_appartenance_geo_com_epci t4,
	    bd_territoire.tm_appartenance_geo_com_cirleg t6
	WHERE t1.tstruct_code_officiel::text = t4.numcrpcepci::text 
	    AND t2.numcom = t4.numcom
	    AND t2.numcom = t3.numcom
	    AND (t1.tfct_code::text = ANY (ARRAY['PDT'::character varying, 'VPDT'::character varying]::text[]))
	    AND t4.numdep  IN ('16','17','79', '86')
	    AND t2.numcom = t6.numcom
	) v1, 
	(
	SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, 
	    t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web, t1.tact_code, 
	    t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code, t7.tciv_libelle, 
	    t5.tpp_code, t6.tpp_libelle, t1.tserv_code
	FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.t_structure t3, 
	    bd_territoire.t_fonction t4, 
	    bd_territoire.t_acteur t5, 
	    bd_territoire.t_parti_politique t6, 
	    bd_territoire.t_civilite t7
          WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
	    AND t1.tstructt_code::text = t3.tstructt_code::text 
	    AND t1.tfct_code::text = t4.tfct_code::text 
	    AND t1.tact_code::text = t5.tact_code::text 
	    AND t5.tpp_code::text = t6.tpp_code::text 
	    AND t5.tciv_code::text = t7.tciv_code::text 
	    AND t4.tfct_code::text <> 'NR'::text 
	    AND (t1.tfct_code::text = ANY (ARRAY['PDT'::character varying, 'VPDT'::character varying]::text[])) 
	    AND (t3.tstructt_code::text = ANY (ARRAY['COLCC'::character varying, 'COLCA'::character varying, 'COLCU'::character varying, 'COLPA'::character varying, 'COLMETRO'::character varying]::text[]))
	) v2
  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
  ORDER BY v2.tstructt_code, v2.tfct_code, v1.numdep;

ALTER TABLE bd_territoire.v_annuaire_elu_terri_pdt_vpdt_epci
  OWNER TO postgres;
COMMENT ON VIEW bd_territoire.v_annuaire_elu_terri_pdt_vpdt_epci
  IS 'Vue contenant la liste des présidents et vice-présidents liés aux EPCI';


------------------------------------------------------------
-- View: bd_territoire.v_annuaire_elu_terri_depute
------------------------------------------------------------
------------------------------------------------------------
-- Créé le : 30/11/2016
-- Modifié le : 02/12/2016
-- Par : Tony VINCENT
------------------------------------------------------------		
		
		
DROP VIEW bd_territoire.v_annuaire_elu_terri_depute;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_depute AS 

SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom,v1.nomcom, v1.numarr, v1.nomarr,	v1.numcae, v1.nomcae, v1.numdep, 
	v1.numepci, v1.nomepci, v1.numcirleg, v1.nomcirleg, v1.tdppays, v1.numtdppays, v1.nomtdppays, v2.tfct_code, v2.tfct_libelle, 
    v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal, v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, 
    v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
   FROM (
	SELECT DISTINCT t1.tstruct_code_officiel, t1.tstructt_code, t1.tfct_code,
		t2.numarr, t2.nomarr,
		t3.numcae, t3.nomcae,
		t4.numepci, t4.nomepci, t4.numdep,
		t5.tdppays, t5.numtdppays, t5.nomtdppays,
		t6.numcom, t6.nomcom, t6.numcirleg, t6.nomcirleg
	FROM bd_territoire.tr_emploi t1, 
		bd_territoire.tm_appartenance_geo_com_libelle t2,
		bd_territoire.tm_appartenance_geo_com_cae t3,
		bd_territoire.tm_appartenance_geo_com_epci t4,
		bd_territoire.tm_appartenance_geo_com_terricontract t5,
		bd_territoire.tm_appartenance_geo_com_cirleg t6
	WHERE t1.tstruct_code_officiel::text = t6.numcirleg::text
		AND t2.numcom = t6.numcom
		AND t4.numcom = t6.numcom
		AND t5.numcom = t6.numcom
		AND t3.numcom = t6.numcom
		AND tfct_code IN ('DEP')
		AND t4.numdep  NOT IN ('16','17','79', '86')
	UNION
	SELECT DISTINCT t1.tstruct_code_officiel, t1.tstructt_code, t1.tfct_code,
		t2.numarr, t2.nomarr,
		t3.numcae, t3.nomcae,
		t4.numcrpcepci AS numepci, t4.nomepci, t4.numdep,
		t5.tdppays, t5.numtdppays, t5.nomtdppays,
		t6.numcom, t6.nomcom, t6.numcirleg, t6.nomcirleg
	FROM bd_territoire.tr_emploi t1, 
		bd_territoire.tm_appartenance_geo_com_libelle t2,
		bd_territoire.tm_appartenance_geo_com_cae t3,
		bd_territoire.tm_appartenance_geo_com_epci t4,
		bd_territoire.tm_appartenance_geo_com_terricontract t5,
		bd_territoire.tm_appartenance_geo_com_cirleg t6
	WHERE t1.tstruct_code_officiel::text = t6.numcirleg::text
		AND t2.numcom = t6.numcom
		AND t4.numcom = t6.numcom
		AND t5.numcom = t6.numcom
		AND t3.numcom = t6.numcom
		AND tfct_code IN ('DEP')
		AND t4.numdep  IN ('16','17','79', '86')
	) v1, 
	(
	SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t1.tserv_code, t1.tstruct_code_officiel, t1.tact_code,
	    t4.tfct_libelle,  
	    t3.tstruct_libelle, t3.tstruct_siret, t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, t3.tstruct_web,
	    t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, t5.tciv_code, t5.tpp_code,
	    t7.tciv_libelle,
	    t6.tpp_libelle
	FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.t_structure t3, 
	    bd_territoire.t_fonction t4,
	    bd_territoire.t_acteur t5,
	    bd_territoire.t_parti_politique t6, 
	    bd_territoire.t_civilite t7
          WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
	    AND t1.tfct_code::text = t4.tfct_code::text 
	    AND t1.tact_code::text = t5.tact_code::text 
	    AND t5.tpp_code::text = t6.tpp_code::text 
	    AND t5.tciv_code::text = t7.tciv_code::text 
	    AND t4.tfct_code::text <> 'NR'::text 
	    AND t1.tfct_code IN ('DEP')	) v2
  WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
  ORDER BY v2.tstructt_code, v2.tfct_code, v1.numdep;

ALTER TABLE bd_territoire.v_annuaire_elu_terri_depute
  OWNER TO postgres;
COMMENT ON VIEW bd_territoire.v_annuaire_elu_terri_depute
  IS 'Vue contenant la liste des députés';

------------------------------------------------------------
-- View: bd_territoire.v_annuaire_elu_terri_eluref
------------------------------------------------------------
------------------------------------------------------------
-- Créé le : 02/12/2016
-- Modifié le : 02/12/2016
-- Par : Tony VINCENT
------------------------------------------------------------		
		
		
DROP VIEW bd_territoire.v_annuaire_elu_terri_eluref;

CREATE OR REPLACE VIEW bd_territoire.v_annuaire_elu_terri_eluref AS 

SELECT DISTINCT v1.tstruct_code_officiel, v2.tstructt_code, v1.numcom, v1.nomcom, v1.numdep, v1.numepci, v1.nomepci, v1.tdppays, v1.numtdppays, 
    v1.nomtdppays, v2.tfct_code, v2.tfct_libelle, v2.tstruct_libelle, v2.tstruct_siret, v2.tstruct_adresse, v2.tstruct_boite_postal, 
    v2.tstruct_nom_com, v2.tstruct_tel, v2.tstruct_fax, v2.tstruct_mail, v2.tstruct_web, v2.tact_code, v2.tact_nom, v2.tact_prenom, 
    v2.tact_mail, v2.tact_tel, v2.tact_portable, v2.tact_fax, v2.tciv_code
FROM (-- Elus réferents pour CA,CA et METRO
	SELECT DISTINCT t1.tstruct_code_officiel, t1.tstructt_code, t1.tfct_code,
		t4.numcom, t4.nomcom, t4.numepci, t4.nomepci, t4.numdep,
		t5.tdppays, t5.numtdppays, t5.nomtdppays
	FROM bd_territoire.tr_emploi t1,
		bd_territoire.tm_appartenance_geo_com_epci t4,
		bd_territoire.tm_appartenance_geo_com_terricontract t5
	WHERE t1.tstruct_code_officiel::text = t4.numepci::text
		AND  tfct_code IN ('ELUREF')
		AND t4.numdep  NOT IN ('16','17','79', '86')
		AND t5.numcom = t4.numcom
	UNION
	SELECT DISTINCT t1.tstruct_code_officiel, t1.tstructt_code, t1.tfct_code,
		t4.numcom, t4.nomcom, t4.numcrpcepci AS numepci, t4.nomepci, t4.numdep,
		t5.tdppays, t5.numtdppays, t5.nomtdppays
	FROM bd_territoire.tr_emploi t1,
		bd_territoire.tm_appartenance_geo_com_epci t4,
		bd_territoire.tm_appartenance_geo_com_terricontract t5
	WHERE t1.tstruct_code_officiel::text = t4.numcrpcepci::text
		AND  tfct_code IN ('ELUREF')
		AND t4.numdep IN ('16','17','79', '86')
		AND t5.numcom = t4.numcom
	UNION
	-- Elus réferents pour PA
	SELECT DISTINCT t1.tstruct_code_officiel, t1.tstructt_code, t1.tfct_code,
		t4.numcom, t4.nomcom, t4.numepci, t4.nomepci, t4.numdep,
		t5.tdppays, t5.numtdppays, t5.nomtdppays
	FROM bd_territoire.tr_emploi t1,
		bd_territoire.tm_appartenance_geo_com_epci t4,
		bd_territoire.tm_appartenance_geo_com_terricontract t5
	WHERE t1.tstruct_code_officiel::text = t5.numtdppays::text
		AND  tfct_code IN ('ELUREF')
		AND tstructt_code NOT IN ('COLCC','COLCA','COLMETRO')
		AND t5.numcom = t4.numcom
		AND t4.numdep  NOT IN ('16','17','79', '86')
	UNION
	SELECT DISTINCT t1.tstruct_code_officiel, t1.tstructt_code, t1.tfct_code,
		t4.numcom, t4.nomcom, t4.numcrpcepci AS numepci, t4.nomepci, t4.numdep,
		t5.tdppays, t5.numtdppays, t5.nomtdppays
	FROM bd_territoire.tr_emploi t1,
		bd_territoire.tm_appartenance_geo_com_epci t4,
		bd_territoire.tm_appartenance_geo_com_terricontract t5
	WHERE t1.tstruct_code_officiel::text = t5.numtdppays::text
		AND  tfct_code IN ('ELUREF')
		AND tstructt_code NOT IN ('COLCC','COLCA','COLMETRO')
		AND t5.numcom = t4.numcom
		AND t4.numdep IN ('16','17','79', '86')
) v1,
(
	SELECT DISTINCT t1.tstructt_code, t1.tfct_code, t4.tfct_libelle, t1.tstruct_code_officiel, t3.tstruct_libelle, t3.tstruct_siret, 
	    t3.tstruct_adresse, t3.tstruct_boite_postal, t3.tstruct_nom_com, t3.tstruct_tel, t3.tstruct_fax, t3.tstruct_mail, 
	    t3.tstruct_web, t1.tact_code, t5.tact_nom, t5.tact_prenom, t5.tact_mail, t5.tact_tel, t5.tact_portable, t5.tact_fax, 
	    t5.tciv_code, t7.tciv_libelle, t5.tpp_code, t6.tpp_libelle, t1.tserv_code
	FROM bd_territoire.tr_emploi t1, 
	    bd_territoire.t_structure t3, 
	    bd_territoire.t_fonction t4, 
	    bd_territoire.t_acteur t5, 
	    bd_territoire.t_parti_politique t6, 
	    bd_territoire.t_civilite t7
	WHERE t1.tstruct_code_officiel::text = t3.tstruct_code_officiel::text 
	    AND t1.tstructt_code::text = t3.tstructt_code::text 
	    AND t1.tfct_code::text = t4.tfct_code::text 
	    AND t1.tact_code::text = t5.tact_code::text 
	    AND t5.tpp_code::text = t6.tpp_code::text 
	    AND t5.tciv_code::text = t7.tciv_code::text 
	    AND t4.tfct_code::text <> 'NR'::text 
	    AND t1.tfct_code IN ('ELUREF') 
	    AND (t3.tstructt_code::text = ANY (ARRAY['COLCC'::character varying::text, 'COLCA'::character varying::text, 'COLCU'::character varying::text, 'COLPA'::character varying::text, 'COLMETRO'::character varying::text]))
	) v2
WHERE v1.tstruct_code_officiel::text = v2.tstruct_code_officiel::text
ORDER BY v2.tstructt_code, v2.tfct_code, v1.numdep;


ALTER TABLE bd_territoire.v_annuaire_elu_terri_eluref
  OWNER TO postgres;
COMMENT ON VIEW bd_territoire.v_annuaire_elu_terri_eluref
  IS 'Vue contenant la liste des élus de territoire';


------------------------------------------------------
-- Utile lorsque la mise à jour des données 
-- se fera directement dans postgre et non via l'ETL
------------------------------------------------------
-- Sequence: bd_territoire.t_acteur_tact_code_seq

-- DROP SEQUENCE bd_territoire.t_acteur_tact_code_seq;
CREATE SEQUENCE bd_territoire.t_acteur_tact_code_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 12500
  CACHE 1;
ALTER TABLE bd_territoire.t_acteur_tact_code_seq
  OWNER TO postgres;
  
-- Trigger: t_acteur_stamp on bd_territoire.t_acteur

-- DROP TRIGGER t_acteur_stamp ON bd_territoire.t_acteur CASCADE;
CREATE FUNCTION bd_territoire.t_acteur_stamp() RETURNS trigger AS $t_acteur_stamp$
    BEGIN
        -- Verifie que nom_employe et salary sont donnés
        IF NEW.tact_nom IS NULL THEN
            RAISE EXCEPTION 'Le champ nom ne peut pas être NULL';
        END IF;

        -- On créer le code acteur
        NEW.tact_code := nextval('bd_territoire.t_acteur_tact_code_seq'::regclass);
        RETURN NEW;
    END;
$t_acteur_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER t_acteur_stamp BEFORE INSERT OR UPDATE ON bd_territoire.t_acteur
   FOR EACH ROW EXECUTE PROCEDURE bd_territoire.t_acteur_stamp();


