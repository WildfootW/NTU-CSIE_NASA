#! /usr/bin/env bash
# in-class exercise 2019/02/25

all_AAAAA=0 # number of AAAAA* in all articles
author_list=()
AAAAA_list=()
url_list=()

for i in {1..2};
do
    search_url="https://www.ptt.cc/bbs/Gossiping/search?page=$i&q=我是石沐凡，我有話想說"
    search_result=`curl --cookie "over18=1" $search_url --silent`

    # 1 : get all articles' url
    # Hint   : lookup all "/bbs/Gossiping/......"
    urls=`echo $search_result | grep -o "/bbs/Gossiping/M.[0-9]\{10\}.A.[0-9A-Z]\{3\}.html"`

    for url in $urls;
    do
        url="https://www.ptt.cc"$url
        article_page=`curl --cookie "over18=1" $url --silent`
        # 2 : Add # of AAAAA* in the article if the article is published during 02/19
        # Hint   : whether 02/19 in article-meta-value ......
        author=`echo "$article_page" | awk -v FS="(article-meta-value\">)" '{print $2}' | awk -v FS="(</span>)" '{print $1}' | sed '/^$/d'`
        publish_time_str=`echo $article_page | awk -v FS="article-meta-value\">" '{print $5}' | awk -v FS="</span>" '{print $1}'`

        echo "$publish_time_str $author"

        if []; # 2/19
        then
            AAAAA_in_this_article=
        fi
    done
done

echo '有關 { [爆卦] 我是石沐凡，我有話想說 , 2/19 } 的相關搜尋結果如下：'

# TODO 3 : list "# of AAAAA, author, url" each line
# for ...;
# do
#	printf "%-3d %-3s %-3s\n" "<# of AAAAA>" "<url>" "<author>"
# done
echo "共有 $all_AAAAA 個 AAAAA"


