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


@series = ('castle','Strain','forever','Hundred','Interest','helix','walking'); #Список сериалов
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
        print $torrent_name;
        if(!-e $torrent_name){
            $out = `wget -nc -i --header "Cookie: uid=1028047; pass=da628af1b41a0eb88b7f98fc185c7318; usess=4bd00e645198a4021ad94496899638ef" -O "$torrent_name" "$torrent"`;
            $torrent_name =~ m/(^.+)\.(s\d{2})e\d{2}/i;
            $name = $1;
            $season = $2;
            $dir_to_download = $series_dir.$1.'/'.$2;
            $deluge = `deluge-console "add -p $dir_to_download $torrent_name"`;
            print $deluge;
        }
    }
}
