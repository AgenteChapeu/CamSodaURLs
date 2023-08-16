#!/bin/bash

awk '{printf("INSERT INTO tb_camsoda (url) VALUES ($token$%s$token$) ON CONFLICT DO NOTHING;\n", $1);}' camsoda.urls.txt > script.sql
