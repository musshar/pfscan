#!/bin/bash

if [ $# -ne 2 ]; then
  echo "please \"command [startURL] [saveDirectory]\" "
    exit 1
    fi

if [ $(echo $1 | grep -v 'http') ]; then
  echo '"'$1'" is not include "http://" or "https://"'
    exit 1
    fi

# protocol is "http:" or "https:"
protocol=`echo $1 | cut -d '/' -f1`
mkdir $2
wget --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" -mnv -S -P $2 -e robots=off $1  > ./$2/log.txt 2>&1



# sameHostLinksとpathsは同じ配列番号のものは同じファイルを指す
sameHostLinks=(`find ./$2 -type f | sed -E 's#\./'$2/'#'$protocol'//#g'`)
#echo "${sameHostLinks[@]}"

currentPath=`pwd | sed -e s'#/#\\\/#g'`
paths=(`find ./$2 -type f | sed -E 's#\./#'$currentPath'/#g'`)
#echo "${paths[@]}"

# 外部URLを抽出
for e in ${paths[@]}; do
  exHostTmp+=(`sed -E 's/<!--.*-->//g' ${e} 2> /dev/null| grep -Eo "(src|href|background|site|classid|code|codebase|data|longdesc|profile|usemap)\s*=\s*(\"|')http(s?)://(\w|/:|%|#|\$|&|\?|\(|\)|~|\.|=|\+|\
-|/)+(\"|')" | grep -Eo "http(s?)://(\w|:|%|#|\$|&|\?|\(|\)|~|\.|=|\+|\-|/)+"`)
done

#echo "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"

exHost=(`echo ${exHostTmp[@]} | tr ' ' '\n' | grep -v $1 | sort | uniq`)

#echo "${exHost[@]}"
#echo "${sameHostLinks[@]}"
#echo `openssl md5 ${paths[@]} | cut -d " " -f 2`

echo "内部コンテンツをディレクトリ[./$2/"`echo $1 | cut -d '/' -f3`"/]に保存しました."

echo ""
echo ""
echo "＊＊＊＊＊＊＊＊内部コンテンツ＊＊＊＊＊＊＊＊＊"
i=0
for e in ${sameHostLinks[@]}; do
    #echo `openssl md5 ${paths[i]} | cut -d " " -f 2` ${e}
    echo ${e} `openssl md5 ${paths[i]} | cut -d " " -f 2`
    i=$i+1
    done

echo ""
echo ""
echo "＊＊＊＊＊＊＊＊外部コンテンツ＊＊＊＊＊＊＊＊＊"

i=0
for e in ${exHost[@]}; do
  echo ${e}
    i=$i+1
    done

exit 0
