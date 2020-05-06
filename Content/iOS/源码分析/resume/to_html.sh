#! /bin/bash

pandoc -f markdown -t html -o resume-web-cn.html resume-web-cn.md -T "Mengjie Cai's Resume" -c css/main.css
