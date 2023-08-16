SET SEARCH_PATH = dbdevel, public;
SET DATESTYLE = GERMAN;

--DROP TABLE IF EXISTS tb_camsoda;
/*
CREATE TABLE public.tb_camsoda (
	id BIGSERIAL PRIMARY KEY,
	url TEXT NOT NULL,
	timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/

DROP TABLE IF EXISTS tb_camsoda_url;

CREATE TABLE public.tb_camsoda_url (
	id BIGSERIAL PRIMARY KEY,
	url TEXT NOT NULL,
	hash BIGINT NOT NULL UNIQUE
);

BEGIN;

-- FAZ CARGA
INSERT INTO tb_camsoda_url (url, hash)
(SELECT distinct
 	cs.url,
 	right(digest(cs.url, 'md5')::text, -1)::bit(64)::bigint AS hash
 FROM
 	tb_camsoda AS cs
 WHERE
	cs.url ILIKE 'https://%' OR
	cs.url ILIKE 'http://%'
GROUP BY cs.url, 2
ORDER BY cs.url) ON CONFLICT DO NOTHING;

UPDATE tb_camsoda_url set URL = REPLACE(URL, '/+isSrc+','/')
WHERE url ilike '%/+isSrc+';

COMMIT;

-- Recupera todas as URLs com a contagem de repetição
SELECT id, url, hash from tb_camsoda_url order by 1 desc;

-- Recupera registros contendo URLs que apresentam o padrao de texto
select * from tb_camsoda_url where
url ilike '%.mp4' OR url ilike '%.avi' OR url ilike '%.mov'

-- Recupera contagem total de URLs na tabela
SELECT count(1) from tb_camsoda_url;
SELECT * from tb_camsoda_url WHERE RANDOM() > 0.99 LIMIT 100;

-- VERIFICA COLISOES
SELECT distinct hash, count(1) FROM tb_camsoda_url group by 1 order by 2 desc

-- EXTRAI CSV DA TABELA
SELECT
	--cs.id,
	cs.url--,
	--cs.hash AS hash64
FROM
	tb_camsoda_url AS cs
WHERE
	cs.url ILIKE 'https://%' OR
	cs.url ILIKE 'http://%'
ORDER BY
	cs.url;

--- EOF ---
