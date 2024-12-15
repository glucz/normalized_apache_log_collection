#!/usr/bin/perl

use DBI;
use Time::Local;

my $agentinfo_database="FILL_OUT";
my $agentinfo_username="FILL_OUT";
my $agentinfo_password="FILL_OUT";

my $iplocation_database="FILL_OUT";
my $iplocation_username="FILL_OUT";
my $iplocation_password="FILL_OUT";

%months = ('Jan',0,'Feb',1,'Mar',2,'Apr',3,'May',4,'Jun',5,'Jul',6,'Aug',7,'Sep',8,'Oct',9,'Nov',10,'Dec',11);

# Preserved time of the start of the processing
$ctime=time();

# Create database connection to the agentinfo database
$iploc = DBI->connect('DBI:mysql:'.$agentinfo_database.';host=localhost',$agentinfo_username,$agentinfo_password);

# Create database connection to the iplocation database
# Queries may need to be adjusted to your your specific database or omitted alltogether

$urlag = DBI->connect('DBI:mysql:'.$iplocation_database.';host=localhost',$iplocation_username,$iplocation_password);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year = $year+1900;

# IPlocation related queries
my $sth = $iploc->prepare("select country_code FROM iplocation WHERE ip_from<=? order by ip_from desc limit 1");
my $stj = $iploc->prepare("select country_code FROM ipproxy WHERE ip_from<=? and ip_to>=? limit 1");

# Data storage queries
my $i_surl=$urlag->prepare("insert into files (u_name) values (?)");
my $i_eurl=$urlag->prepare("insert into exturl (e_name) values (?)");
my $i_sage=$urlag->prepare("insert into agent (a_name) values (?)");
my $s_surl=$urlag->prepare("select u_id from files where u_name=?");
my $s_eurl=$urlag->prepare("select e_id from exturl where e_name=?");
my $s_sage=$urlag->prepare("select a_id from agent where a_name=?");
my $i_hits=$urlag->prepare("insert into hits (h_a_id,h_u_id,h_ccode,h_prox,h_status,h_i_id,h_d_id,h_ts,h_mode,h_e_id) values (?,?,?,?,?,?,?,now(),?,?)");
my $i_ip=$urlag->prepare("insert into ip (i_name,i_agent,i_year,i_month,i_ccode,i_proxy) values (?,?,?,?,?,?)");
my $incr_ip=$urlag->prepare("update ip set i_count=i_count+1 where i_name=? and i_agent=? and i_year=? and i_month=?");
my $s_ip=$urlag->prepare("select i_id from ip where i_name=? and i_agent=? and i_year=? and i_month=?");
my $i_dom=$urlag->prepare("insert into domain (d_name) values (?)");
my $s_dom=$urlag->prepare("select d_id from domain where d_name=?");

$fle=$ARGV[0];
if (1) # Placeholder for filtering the file name 
{
   my $domid=getdomid($fle);
   open F,"$fle";
   while (<F>)
   { 
      $log=$_;
      chop($log);

      # Scan logline for data
      if ($log=~/(.*?) - - (.*?)\"(\S+)\s(.*?)\"\s(\d+)\s\S+\s\".*?\" \"(.*?)\"$/)
      {
         my($ip,$date,$mode,$url,$code,$agent)=($1,$2,$3,$4,$5,$6);

         # Scan timestamp
         if ($date=~/\[(\d+)\/([^\/]+)\/(\d+):(\d+):(\d+):(\d+)/)
         {
            my $epoch=timelocal($6,$5,$4,$1,$months{$2},$3);
            my $dsec=($ctime-$epoch)/86400;

            # Lookup IP location
            if (length($chash{$ip})<1) {$chash{$ip}=getcountry($ip);}
            my $country=$chash{$ip};

            # Lookup reported proxy presence
            if (length($cprox{$ip})<1) {$cprox{$ip}=isproxy($ip);}
            my $proxy=$cprox{$ip};

            #### Uncomment to debug
            #print "IP   : ".$ip." -- ".$country."\n";
            #print "MODE : ".$mode."\n";
            #print "DATE : ".$date."\n";
            
            $url=reverse $url;
            $eurl=$url;
            if ($url=~/PTTH (.*?)\//)
            {$url=reverse $1;} else {$url="@"};
            if ($url=~/^(.*?)\?/) {$url=$1;}
            if ($eurl=~/PTTH (.*?\/.*?)\//)
            {$eurl=reverse $1;} else {$eurl="@"};
            if ($eurl=~/^(.*?)\?/) {$eurl=$1;}

            #### Uncomment to debug
            #print "URL  : ".$url."\n";
            #print "EURL : ".$eurl."\n";
            #print "CODE : ".$code."\n";
            #print "AGENT: ".$agent."\n";
            #print "\n-----------------------------\n";

            # Store data
            $i_surl->execute($url);
            $i_sage->execute($agent);
            $i_eurl->execute($eurl);
            $s_surl->execute($url);
            if (my $sresult = $s_surl->fetchrow_hashref())
            {
               my $uid=$sresult->{u_id};
               $s_sage->execute($agent);
               if (my $aresult = $s_sage->fetchrow_hashref())
               {
                  my $aid=$aresult->{a_id};
                  $i_ip->execute($ip,$aid,$year,$mon,$country,$proxy);
                  $incr_ip->execute($ip,$aid,$year,$mon);
                  $s_ip->execute($ip,$aid,$year,$mon);
                  if (my $iresult = $s_ip->fetchrow_hashref())
                  {
                     my $ipid=$iresult->{i_id};
                     $s_eurl->execute($eurl);
                     if (my $eresult = $s_eurl->fetchrow_hashref())
                     {
                        my $ieurl=$eresult->{e_id};
                        $i_hits->execute($aid,$uid,$country,$proxy,$code,$ipid,$domid,$mode,$ieurl);
                     }
                  }
               }
            }
         }
         else
         {
            print "NOMATCH\n";
            #### Uncomment to debug
            #exit;
         }
      }
      print $fle."\n";
      #### Uncomment to debug
      #exit;
   }
}


sub getdomid
{
   my $doname="";
   my $domid=0;
   my $flname=$_[0];
   if ($flname=~/\/([^\/]+)$/)
   {
      $doname=$1;
      $doname=~s/-ssl_log//;
      $i_dom->execute($doname);
      $s_dom->execute($doname);
      if (my $sresult = $s_dom->fetchrow_hashref())
      {
         $domid=$sresult->{d_id};
      }
   }
   return $domid;
}
   

sub isproxy
{
   my $ip=$_[0];
   if ($ip=~/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/)
   {
      my $decip=ip2dec($ip);
      $stj->execute($decip,$decip);
      if (my $result = $sth->fetchrow_hashref())
      {
         return 1;
      }
      return 0;
   }
}

sub getcountry
{
   my $ip=$_[0];
   if ($ip=~/^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/)
   {
      my $decip=ip2dec($ip);
     
      $sth->execute($decip);
      if (my $result = $sth->fetchrow_hashref())
      {
         return ($result->{country_code});
      }
   }
   return "--";
}

sub dec2ip ($) {
    join '.', unpack 'C4', pack 'N', shift;
}
 
sub ip2dec ($) {
    unpack N => pack CCCC => split /\./ => shift;
}
