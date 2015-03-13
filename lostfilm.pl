#!/usr/bin/perl

###################################################################
###################################################################
###                                                             ###
###     Парсит RSS LostFilm.TV.                                 ###
###     Скачивает торрент файлы новых серий                     ###
###     и добавляет их на закачку в Deluge                      ###
###     При желании можно использовать любой торрент-клиент     ###
###     @author Evgeny Zenka                                    ###
###     @link https://github.com/evgenyzenka/Lostfilm-Parser    ###
###                                                             ###
###################################################################
###################################################################


@series = ('castle','Strain','forever','Hundred','Interest','helix','walking','call.saul','blacklist'); #Список сериалов
$quality = '1080';#Качество
$torrents_dir = '/usr/local/scripts/series_parser/torrents';#Каталог, куда буду складываться торрент файлы
$series_dir = '/mnt/pocket/series/'; #Каталог куда будем качать файлы

$series = join('|',@series);
chdir $torrents_dir;
@torrents = `/usr/bin/wget -qO - http://www.lostfilm.tv/rssdd.xml | /bin/grep -ioe 'http.*torrent'`;
foreach $torrent(@torrents){
    chomp $torrent;
    if($torrent =~ m/($series).*$quality/i){
        $torrent_name = '';

        $torrent =~ m/\&amp;(.*torrent)/i;
        $torrent_name = $1;
        $torrent =~ s/\&amp;/\&/i;
        print $torrent_name;
        print "\n";
        if(!-e $torrent_name){
            $out = `wget -nc -i -  --header "Cookie: uid=<uid>; pass=<pass>; usess=<usess>"  -O "$torrent_name" $torrent`;
            $torrent_name =~ m/(^.+)\.(s\d{2})e\d{2}/i;
            $name = $1;
            $season = $2;
            $dir_to_download = $series_dir.$1.'/'.$2;
            $deluge = `deluge-console "add -p $dir_to_download '$torrent_name'"`;
            print $deluge;
            print "\n";
        }
    }
}
