#! /usr/bin/env bash
# in-class exercise 2019/02/25

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

        #echo "$publish_time_str $author"
        if [ `echo $publish_time_str | awk -v FS=" " '{print $2 $3}'` = "Feb19" ] # 2/19
        then
            AAAAA_in_this_article=`echo $article_page | grep -o "AAAAA\+"`
            if [ "$AAAAA_in_this_article" = "" ]
            then
                AAAAA_list+=(0)
            else
                AAAAA_list+=(`echo "$AAAAA_in_this_article" | wc -l`)
            fi
            author_list+=("$author") # mind the double-quote and no $ in front variable
            url_list+=("$url")
            #echo "${AAAAA_list[@]}"
            #echo "${author_list[@]}"
            #echo "${url_list[@]}"
        fi # feb 19
    done
done

echo '有關 { [爆卦] 我是石沐凡，我有話想說 , 2/19 } 的相關搜尋結果如下：'

# 3 : list "# of AAAAA, author, url" each line
all_AAAAA=0 # number of AAAAA* in all articles
for i in $( seq 0 $((${#AAAAA_list[@]}-1)) ); # number minus
do
    printf "%-3d %-3s %-3s\n" "${AAAAA_list[i]}" "${url_list[i]}" "${author_list[i]}" # pass argument
    all_AAAAA=$((${AAAAA_list[i]} + $all_AAAAA))
done
echo "共有 $all_AAAAA 個 AAAAA"


