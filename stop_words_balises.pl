#!/usr/bin/perl

my $file1 = "reut2-000.sgm";
my $valid = "validation.txt";
my $test = "test.txt";
my $res = "res.txt";

open(FILE1, "<$file1") or die "Unable to open $file1\n";

open(VALIDATION, ">$valid") or die "Unable to open file $valid\n";
open(TEST, ">$test") or die "Unable to open file $test\n";

open(RES, ">$res") or die "Unable to open file $res\n";

my $phrase;
my @texts;
my @stopWords = ("a","i","i\'d","\'","at","about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the", "&gt", ",", "&lt","&#3;", ";", ".","reuter", "&#");

my $trouve;

while ($line = <FILE1>)
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

foreach my $l (@texts)
{
	if ($l =~ /<REUTERS TOPICS=(.*?) LEWISSPLIT=(.*?) CGISPLIT=(.*?) OLDID=(.*)>/)
	{
		print RES "TOPICS : $1\n";
		print RES "LEWIS : $2\n";
		print RES "CGI : $3\n";
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
		print RES "TITLE : $1\n\n";
	}

	if ($l =~ /<BODY>(.*)<\/BODY>/)
	{	
		$tmp = $1;		
		$tmp =~ s/##/\n/g;
		$tmp = lc ($tmp);
		$tmp =~ s/\d+((,|.)?\d*)*//g;
		@words = split( /\s+/, $tmp );


		$ligne_finale = "";

		foreach my $word(@words) {
			$trouve = 0;
			foreach my $element(@stopWords){
				if ($word eq $element){
					#StopWord trouvé donc on le réécrit pas
					$trouve = 1;	
				}
			}
	
			if ($trouve == 0) {
				$ligne_finale = $ligne_finale." ".$word; 
			}

		}

		print RES "$ligne_finale\n\n";
	}
	
	print RES "*****************************************************************************************\n\n";
}

close FILE1;
close RES;
