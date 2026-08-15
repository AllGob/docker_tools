# Docker_file с автоустановкой библиотек для биоинженеринга (Python)
## Introduction
Сборка Docker образа с свежими совместимыми версиями библиотек 
- samtools + htslib + libdeflate;
- bcftools;
- vcftools.
<details>
<summary>Установленные библиотеки</summary>    
 
- autoconf 
- automake 
- make 
- gcc
- bzip2 
- perl
- zlib1g-dev 
- libbz2-dev 
- liblzma-dev 
- libcurl4-gnutls-dev 
- libssl-dev
- libdeflate-dev
- wget 
- samtools 1.22.1 
- bcftools 1.22 
- VCFtools 0.1.17 
</details>

## PS
Сборка на Ubuntu 22, свежее версия - меньше мороки с созависимостями пакетов. 
Сами пакеты обновляются(проверил), а значит должно быть учтено, что они выходят под свежие версии пакетов зависимостей. 
"export DEBIAN_FRONTEND=noninteractive" выполнено локально в слое, поскольку иначе переменная окружения будет сохранена в докер контейнере, что нам может помешать в последствии. Тажке сопровождал некоторые блоки комментариями. 