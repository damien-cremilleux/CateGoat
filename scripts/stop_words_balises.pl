#!/usr/bin/perl

my $trainingfile = "CateGoat.train";
my $testfile = "CateGoat.test";
my $debug = "CateGoat.debug";
my $split = "";

open(TRAINING, ">$trainingfile") or die "Unable to open file $trainingfile\n";
open(TEST, ">$testfile") or die "Unable to open file $testfile\n";

#mode debug
#open(RES, ">$debug") or die "Unable to open file $debug\n";

my $phrase;
my @texts;
my @stopWords = ("a", "b", "c" ,"d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "i\'d","at","about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "gt", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "lt", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "vs", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the","reuter");

my $trouve;
my $file = 0;


while($file <= $#ARGV){
	print "Chargement du fichier $ARGV[$file] en cours\n";
	my $entryfile = $ARGV[$file];
	open(ENTRYFILE, "<$entryfile") or die "Unable to open $entryfile\n";

	while ($line = <ENTRYFILE>)
	{
		if ($line !~ /<!DOCTYPE.*>/)
		{
			$line =~ s/\n/##/;
			if($line !~ /<\/REUTERS>/)
			{
				my $tmp = $phrase;
				$phrase = join('', $tmp, $line);
			}
			else
			{
				my $tmp = $phrase;
				$phrase = join('', $tmp, "</REUTERS>\n");
				push @texts, $phrase;
				$phrase = "";
			}
		}
	}
	close ENTRYFILE;
	$file++;
}


foreach my $l (@texts)
{
	if ($l =~ /<REUTERS TOPICS="(.*?)" LEWISSPLIT="(.*?)" CGISPLIT="(.*?)" OLDID=(.*)>/)
	{
		print RES "TOPICS : $1\n";
		print RES "LEWIS : $2\n";
		print RES "CGI : $3\n";
		$split = $2;
	}

	if ($l =~ /<TOPICS>(.*?)<\/TOPICS>/)
	{
		my $tmp = $1;
		$tmp =~ s/<D>//g;
		$tmp =~ s/<\/D>/,/g;
		chop($tmp);
		print RES "TOPICS : $tmp\n";
	}

	if ($l =~ /<TITLE>(.*?)<\/TITLE>/)
	{
		print RES "TITLE : $1\n";
	}

	if ($l =~ /<BODY>(.*)<\/BODY>/)
	{	
		$tmp = $1;		
		$tmp =~ s/##/\n/g;
		$tmp = lc ($tmp);
		$tmp =~ s/[.,;:\+\-\*=\$"'\/?!()[\]<>^@&#]/ /g;
		$tmp =~ s/\d+/ /g;
		@words = split( /\s+/, $tmp );


		$ligne_finale = "";

		foreach my $word(@words) {
			$trouve = 0;
			foreach my $element(@stopWords){
				if ($word eq $element){
					#StopWord trouvé donc on le réécrit pas
					$trouve = 1;	
					break;
				}
			}

			if ($trouve == 0) {
				$ligne_finale = $ligne_finale." ".$word; 
			}

		}

		#CHOIX DE L'IMPRESSION.
		#	$split == TEST  		-> écriture dans test
		# 	$split == TRAINING  	-> écriture dans training
		if($split eq "TEST") { print TEST "$ligne_finale\n\n"; }
		if($split eq "TRAIN") { print TRAINING "$ligne_finale\n\n"; }
		print RES "$ligne_finale\n\n";
	
	}
}

close TRAINING;
close TEST;
close RES;
